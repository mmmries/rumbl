defmodule Rumbl.GameOfLifeController do
  use Rumbl.Web, :controller
  import Rumbl.GameOfLife

  def show(conn, _params) do
    render conn, "show.html", board: generate({30,30})
  end

  def next_generation(conn, params) do
    next_board = parse_params(params, {30,30}) |> next_generation
    render conn, "show.html", board: next_board
  end
end
