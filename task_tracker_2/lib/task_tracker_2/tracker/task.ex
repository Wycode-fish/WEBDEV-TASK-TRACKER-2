defmodule TaskTracker2.Tracker.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker2.Tracker.Task
  alias TaskTracker2.Tracker.Slot

  schema "tasks" do
    field :description, :string
    field :is_finish, :boolean, default: false
    field :start_time, :integer, default: :os.system_time(:seconds)
    field :title, :string
    field :end_time, :integer, default: :os.system_time(:seconds)
    belongs_to :creator, TaskTracker2.Accounts.User
    belongs_to :assignee, TaskTracker2.Accounts.User
    has_many :task_slots, TaskTracker2.Tracker.Slot, foreign_key: :task_id
    # has_many :followers, through: [:task_slots, :task]


    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
        |> cast(attrs, [:title, :description, :start_time, :is_finish, :creator_id, :assignee_id, :end_time])
        |> foreign_key_constraint(:creator_id)
        |> foreign_key_constraint(:assignee_id)
        # |> foreign_key_constraint(:task_slots)
        |> validate_required([:title, :description, :start_time, :is_finish, :creator_id, :assignee_id, :end_time])
  end
end
