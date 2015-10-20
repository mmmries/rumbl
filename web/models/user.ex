defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username email), [])
    |> update_change(:email, &String.downcase/1)
    |> update_change(:email, &String.strip/1)
    |> update_change(:username, &String.downcase/1)
    |> update_change(:username, &String.strip/1)
    |> validate_length(:username, min: 1, max: 20)
  end
end
