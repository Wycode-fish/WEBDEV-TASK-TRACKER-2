defmodule TaskTracker2.Tracker.Slot do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker2.Tracker.Slot
  alias TaskTracker2.Tracker.Task

  schema "slots" do
    field :end_time, :integer
    field :start_time, :integer
    # field :task_id, :id
    belongs_to :task, TaskTracker2.Tracker.Task

    timestamps()
  end

  @doc false
  def changeset(%Slot{} = slot, attrs) do
    slot
    |> cast(attrs, [:start_time, :end_time, :task_id])
    |> validate_required([:start_time, :end_time, :task_id])
  end
end
