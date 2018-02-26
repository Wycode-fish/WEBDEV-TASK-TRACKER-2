defmodule TaskTracker2Web.TaskController do
  use TaskTracker2Web, :controller

  alias TaskTracker2.Tracker
  alias TaskTracker2.Tracker.Task
  alias TaskTracker2.Accounts
  alias TaskTracker2.Accounts.User

# Enum.map(assignees, fn(n) -> Enum.reduce([n|>Map.get(:id), n|>Map.get(:name)], "-" ) end)
# time_slots|>Enum.reduce(0, f(x, acc) -> (acc+(x|>Map.get(:end_time)-x|>Map.get(:start_time))/60)|>round end);
# Enum.reduce(time_slots, 0, fn(x, acc) -> (x|>Map.get(:end_time) - x|>Map.get(:end_time))/60 + acc end)
  def index(conn, _params) do
    current_user = Map.get(conn.assigns, :current_user);
    assignees = Accounts.get_assignees_by_manager_id(current_user.id);
    tasks = Tracker.get_tasks_by_creator_id(current_user.id);
    works = Tracker.get_tasks_by_assignee_id(current_user.id);
    id_name_list = Enum.map(assignees, fn(n) -> Enum.join([n|>Map.get(:id), n|>Map.get(:name)], "-" ) end);

    render(conn, "index.html", tasks: tasks, id_name_list: id_name_list, this_assignees: assignees, works: works);
  end

  def new(conn, _params) do
    changeset = Tracker.change_task(%Task{})
    current_user = Map.get(conn.assigns, :current_user);
    assignees = Accounts.get_assignees_by_manager_id(current_user.id);
    id_list = Enum.map(assignees, fn(n) -> n|>Map.get(:id) end);
    render(conn, "new.html", changeset: changeset, this_assignees_ids: id_list)
  end

  def create(conn, %{"task" => task_params}) do
    task_params = Map.put(task_params, "start_time", :os.system_time(:second));
    case Tracker.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    time_slots = Tracker.get_slots_by_id(id);
    # Map.get(x, :end_time)|>Kernel.-(Map.get(x, :start))
    duration_list = time_slots|>Enum.map(fn(x) -> get_duration(x) end);
    total_time = duration_list|>Enum.reduce(0, fn(x, acc) -> acc + Float.ceil(x/60) end);
    # total_time = Enum.reduce(time_slots, 0, fn(x, acc) -> (x|>Map.get(:end_time) - x|>Map.get(:end_time))/60 + acc end);
    render(conn, "show.html", task: task, time_slots: time_slots, total_time: total_time)
  end

  def get_duration(slot) do
    stime = slot|>Map.get(:start_time);
    etime = slot|>Map.get(:end_time);
    etime - stime;
  end

  # def check(conn,  %{"id" => id}) do
  #   task = Tracker.get_task!(id)
  #   changeset = Tracker.change_task(task)
  #   render(conn, "check.html", task: task, changeset: changeset)
  # end

  def edit(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    time_slots = Tracker.get_slots_by_id(id);
    changeset = Tracker.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset, time_slots: time_slots)
  end

  def slot_edit(conn, %{"task_id" => id}) do
    slot = Tracker.get_slot!(id);
    changeset = Tracker.change_slot(slot);
    task_id = slot|>Map.get(:task_id);
    render(conn, "slotedit.html", slot: slot, changeset: changeset, task_id: task_id);
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tracker.get_task!(id)
    # time_slots = Trakcer.get_slots_by_id(id);
    isFinish = Map.get(task, :is_finish);

    if not isFinish do
      IO.puts "haha";
      IO.puts Integer.to_string(:os.system_time(:second));
      task_params = Map.put(task_params, "end_time", :os.system_time(:second));
      IO.puts Integer.to_string(task|>Map.get(:end_time));
    end

    case Tracker.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end


  def delete(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    {:ok, _task} = Tracker.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end
end
