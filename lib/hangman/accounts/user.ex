defmodule Hangman.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :room_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :room_id])
    |> validate_required([:name, :room_id])
    |> validate_length(:name, min: 2)
    |> validate_number(:room_id, greater_than: 0, message: "Not a valid room ID.")
  end
end
