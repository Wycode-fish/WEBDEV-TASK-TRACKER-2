defmodule TaskTracker.Repo.Migrations.CreateSlots do
  use Ecto.Migration

  def change do
    create table(:slots) do
      add :start_time, :integer, null: false
      add :end_time, :integer, null: false
      add :task_id, references(:tasks, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:slots, [:task_id])
  end
end
