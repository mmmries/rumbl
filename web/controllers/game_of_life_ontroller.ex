defmodule Rumbl.GameOfLifeController do
  use Rumbl.Web, :controller

  def show(conn, _params) do
    render conn, "show.html", board: %{}
  end

  def next_generation(conn, params) do
    render conn, "show.html", board: params
  end
end
