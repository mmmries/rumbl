defmodule Rumbl.GameOfLife do
  def generate({height,width}) do
    (1..height) |> Enum.map( fn(_row) ->
      (1..width) |> Enum.map( fn(_col) ->
        0
      end)
    end)
  end

  def parse_params(params, {height,width}) do
    (1..height) |> Enum.map( fn(row) ->
      (1..width) |> Enum.map( fn(col) ->
        case params["#{row},#{col}"] do
          "1" -> 1
          _ -> 0
        end
      end)
    end)
  end

  def next_generation(board) do
    board
    |> pad_board # the board with 0-padding rows and columns
    |> neighborhoods # each position represented as a 3x3 matrix
    |> count_neighbors_in_groups # each position represents as {current,number_of_neighbors}
    |> decide_who_lives_and_dies # back to a board
  end

  defp alive_or_dead?(1, num) when num < 2, do: 0
  defp alive_or_dead?(1, num) when num > 3, do: 0
  defp alive_or_dead?(0, 3), do: 1
  defp alive_or_dead?(current, _), do: current

  defp decide_who_lives_and_dies(board) do
    Enum.map(board, fn(row) ->
      Enum.map(row, fn({current, number_of_neighbors}) ->
        alive_or_dead?(current, number_of_neighbors)
      end)
    end)
  end

  defp neighborhoods(board) do
    board |> Enum.chunk(3,1) |> Enum.map( fn(rows) ->
      rows
      |> Enum.map(&( Enum.chunk(&1,3,1) ))
      |> transpose
    end)
  end

  defp pad_board(board) do
    width = Enum.count(List.first(board))
    empty_row = [List.duplicate(0, width + 2)]
    column_padded = Enum.map(board, fn(row) -> [0] ++ row ++ [0] end)
    empty_row ++ column_padded ++ empty_row
  end

  defp count_neighbors_in_groups(board) do
    Enum.map(board, fn(row) ->
      Enum.map(row, fn([[al,am,ar],[l,me,r],[bl,bm,br]]) ->
        {me, Enum.sum([al,am,ar,l,r,bl,bm,br])}
      end)
    end)
  end

  defp transpose([[]|_]), do: []
  defp transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end
end
