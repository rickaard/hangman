defmodule Hangman.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :room_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :room_id])
    |> validate_required([:name, :room_id])
    |> validate_length(:name, min: 2)
    |> validate_length(:room_id, is: 4, message: "must be 4 characters")
  end
end
