defmodule TaskTracker2.Tracker do
  @moduledoc """
  The Tracker context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker2.Repo

  alias TaskTracker2.Tracker.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
    |> Repo.preload(:creator)
    |> Repo.preload(:assignee)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Repo.get!(Task, id)
    |> Repo.preload(:creator)
    |> Repo.preload(:assignee)
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def get_tasks_by_creator_id(cid) do
    query = from t in Task,
          where: t.creator_id == ^cid
    Repo.all(query);
  end

  def get_tasks_by_assignee_id(aid) do
    query = from t in Task,
          where: t.assignee_id == ^aid
    Repo.all(query);
  end


  alias TaskTracker2.Tracker.Slot

  @doc """
  Returns the list of slots.

  ## Examples

      iex> list_slots()
      [%Slot{}, ...]

  """
  def list_slots do
    Repo.all(Slot)
  end

  @doc """
  Gets a single slot.

  Raises `Ecto.NoResultsError` if the Slot does not exist.

  ## Examples

      iex> get_slot!(123)
      %Slot{}

      iex> get_slot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_slot!(id), do: Repo.get!(Slot, id)

  @doc """
  Creates a slot.

  ## Examples

      iex> create_slot(%{field: value})
      {:ok, %Slot{}}

      iex> create_slot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slot(attrs \\ %{}) do
    %Slot{}
    |> Slot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a slot.

  ## Examples

      iex> update_slot(slot, %{field: new_value})
      {:ok, %Slot{}}

      iex> update_slot(slot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_slot(%Slot{} = slot, attrs) do
    slot
    |> Slot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Slot.

  ## Examples

      iex> delete_slot(slot)
      {:ok, %Slot{}}

      iex> delete_slot(slot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_slot(%Slot{} = slot) do
    Repo.delete(slot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slot changes.

  ## Examples

      iex> change_slot(slot)
      %Ecto.Changeset{source: %Slot{}}

  """
  def change_slot(%Slot{} = slot) do
    Slot.changeset(slot, %{})
  end


  def get_slots_by_id(id) do
    query = from s in Slot,
      where: s.task_id == ^id
    Repo.all(query);
  end

end
