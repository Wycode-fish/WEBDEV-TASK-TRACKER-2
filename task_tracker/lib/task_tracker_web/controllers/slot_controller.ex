defmodule TaskTrackerWeb.SlotController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Tracker
  alias TaskTracker.Tracker.Slot

  action_fallback TaskTrackerWeb.FallbackController

  def index(conn, _params) do
    slots = Tracker.list_slots()
    render(conn, "index.json", slots: slots)
  end

  def create(conn, %{"slot" => slot_params}) do
    with {:ok, %Slot{} = slot} <- Tracker.create_slot(slot_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", slot_path(conn, :show, slot))
      |> render("show.json", slot: slot)
    end
  end

  def show(conn, %{"id" => id}) do
    slot = Tracker.get_slot!(id)
    render(conn, "show.json", slot: slot)
  end

  def update(conn, %{"id" => id, "slot" => slot_params}) do
    slot = Tracker.get_slot!(id)
    IO.inspect slot_params;
    IO.inspect slot;

    ori_stime_struct = slot.start_time|>DateTime.from_unix()|>elem(1);
    start_year = slot_params|>Map.get("start_year")|>String.to_integer;
    start_month = slot_params|>Map.get("start_month")|>String.to_integer;
    start_day = slot_params|>Map.get("start_day")|>String.to_integer;
    start_hour = slot_params|>Map.get("start_hour")|>String.to_integer;

    new_stime = ori_stime_struct|>Map.put(:year, start_year)
                                |>Map.put(:month, start_month)
                                |>Map.put(:day, start_day)
                                |>Map.put(:hour, start_hour)
                                |>DateTime.to_unix;


    ori_etime_struct = slot.end_time|>DateTime.from_unix()|>elem(1);
    end_year = slot_params|>Map.get("end_year")|>String.to_integer;
    end_month = slot_params|>Map.get("end_month")|>String.to_integer;
    end_day = slot_params|>Map.get("end_day")|>String.to_integer;
    end_hour = slot_params|>Map.get("end_hour")|>String.to_integer;

    new_etime = ori_etime_struct|>Map.put(:year, end_year)
                                |>Map.put(:month, end_month)
                                |>Map.put(:day, end_day)
                                |>Map.put(:hour, end_hour)
                                |>DateTime.to_unix;


    slot_params = %{}|>Map.put(:start_time, new_stime)
                      |>Map.put(:end_time, new_etime);

    # time = Timex.parse("08/02/2016 6:15 PM", "{0D}/{0M}/{YYYY} {h12}:{m} {AM}")
    with {:ok, %Slot{} = slot} <- Tracker.update_slot(slot, slot_params) do
      # render(conn, "/", slot: slot)
      conn|> redirect(to: task_path(conn, :show, slot|>Map.get(:task_id)))
    end
  end

  def delete(conn, %{"id" => id}) do
    slot = Tracker.get_slot!(id)
    with {:ok, %Slot{}} <- Tracker.delete_slot(slot) do
      send_resp(conn, :no_content, "")
    end
  end
end
