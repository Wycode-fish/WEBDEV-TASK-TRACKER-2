defmodule TaskTracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    belongs_to :manager, TaskTracker.Accounts.User

    timestamps()
  end
  @required_fields ~w()
  @optional_fields ~w(name email user_id access_token access_token_expires_at refresh_token)

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :manager_id])
    |> validate_required([:email, :name])
  end
end
