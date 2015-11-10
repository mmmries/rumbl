defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :videos, Rumbl.Video

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

  def registration_changeset(model, params \\ :empty) do
    changeset(model, params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
    %{valid?: true, changes: %{password: password}} ->
      put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    _ ->
      changeset
    end
  end
end
