defmodule TaskTracker2Web.SlotControllerTest do
  use TaskTracker2Web.ConnCase

  alias TaskTracker2.Tracker
  alias TaskTracker2.Tracker.Slot

  @create_attrs %{end_time: 42, start_time: 42}
  @update_attrs %{end_time: 43, start_time: 43}
  @invalid_attrs %{end_time: nil, start_time: nil}

  def fixture(:slot) do
    {:ok, slot} = Tracker.create_slot(@create_attrs)
    slot
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all slots", %{conn: conn} do
      conn = get conn, slot_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create slot" do
    test "renders slot when data is valid", %{conn: conn} do
      conn = post conn, slot_path(conn, :create), slot: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, slot_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_time" => 42,
        "start_time" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, slot_path(conn, :create), slot: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update slot" do
    setup [:create_slot]

    test "renders slot when data is valid", %{conn: conn, slot: %Slot{id: id} = slot} do
      conn = put conn, slot_path(conn, :update, slot), slot: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, slot_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_time" => 43,
        "start_time" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, slot: slot} do
      conn = put conn, slot_path(conn, :update, slot), slot: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete slot" do
    setup [:create_slot]

    test "deletes chosen slot", %{conn: conn, slot: slot} do
      conn = delete conn, slot_path(conn, :delete, slot)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, slot_path(conn, :show, slot)
      end
    end
  end

  defp create_slot(_) do
    slot = fixture(:slot)
    {:ok, slot: slot}
  end
end
