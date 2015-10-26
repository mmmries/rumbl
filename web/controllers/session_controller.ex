defmodule Rumbl.SessionController do
  use Rumbl.Web, :controller
  alias Rumbl.User

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Rumbl.Auth.login_by_username_and_password(conn, username, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Logged In!")
        |> redirect(to: user_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Rumbl.Auth.logout
    |> put_flash(:info, "You are now logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
