defmodule TaskTracker2.TrackerTest do
  use TaskTracker2.DataCase

  alias TaskTracker2.Tracker

  describe "tasks" do
    alias TaskTracker2.Tracker.Task

    @valid_attrs %{description: "some description", end_time: 42, is_finish: true, start_time: 42, title: "some title"}
    @update_attrs %{description: "some updated description", end_time: 43, is_finish: false, start_time: 43, title: "some updated title"}
    @invalid_attrs %{description: nil, end_time: nil, is_finish: nil, start_time: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracker.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tracker.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tracker.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Tracker.create_task(@valid_attrs)
      assert task.description == "some description"
      assert task.end_time == 42
      assert task.is_finish == true
      assert task.start_time == 42
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Tracker.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.description == "some updated description"
      assert task.end_time == 43
      assert task.is_finish == false
      assert task.start_time == 43
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_task(task, @invalid_attrs)
      assert task == Tracker.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tracker.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tracker.change_task(task)
    end
  end

  describe "slots" do
    alias TaskTracker2.Tracker.Slot

    @valid_attrs %{end_time: 42, start_time: 42}
    @update_attrs %{end_time: 43, start_time: 43}
    @invalid_attrs %{end_time: nil, start_time: nil}

    def slot_fixture(attrs \\ %{}) do
      {:ok, slot} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracker.create_slot()

      slot
    end

    test "list_slots/0 returns all slots" do
      slot = slot_fixture()
      assert Tracker.list_slots() == [slot]
    end

    test "get_slot!/1 returns the slot with given id" do
      slot = slot_fixture()
      assert Tracker.get_slot!(slot.id) == slot
    end

    test "create_slot/1 with valid data creates a slot" do
      assert {:ok, %Slot{} = slot} = Tracker.create_slot(@valid_attrs)
      assert slot.end_time == 42
      assert slot.start_time == 42
    end

    test "create_slot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_slot(@invalid_attrs)
    end

    test "update_slot/2 with valid data updates the slot" do
      slot = slot_fixture()
      assert {:ok, slot} = Tracker.update_slot(slot, @update_attrs)
      assert %Slot{} = slot
      assert slot.end_time == 43
      assert slot.start_time == 43
    end

    test "update_slot/2 with invalid data returns error changeset" do
      slot = slot_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_slot(slot, @invalid_attrs)
      assert slot == Tracker.get_slot!(slot.id)
    end

    test "delete_slot/1 deletes the slot" do
      slot = slot_fixture()
      assert {:ok, %Slot{}} = Tracker.delete_slot(slot)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_slot!(slot.id) end
    end

    test "change_slot/1 returns a slot changeset" do
      slot = slot_fixture()
      assert %Ecto.Changeset{} = Tracker.change_slot(slot)
    end
  end
end
