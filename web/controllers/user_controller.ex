defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  plug :authenticate_user when action in [:index, :show]
  alias Rumbl.User

  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
    {:ok, user} ->
      conn
      |> Rumbl.Auth.login(user)
      |> put_flash(:info, "#{user.name} created!")
      |> redirect(to: user_path(conn, :index))
    {:error, changeset} ->
      render conn, "new.html", changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    to_delete = %User{id: String.to_integer(id)}
    user = Repo.delete!(to_delete)

    conn
    |> put_flash(:info, "#{user.name} deleted!")
    |> redirect(to: user_path(conn, :index))
  end
end
