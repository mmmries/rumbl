defmodule Rumbl.WatchController do
  use Rumbl.Web, :controller
  alias Rumbl.Video

  def show(conn, %{"id" => id}) do
    {id, _rest} = Integer.parse(id)
    video = Repo.get!(Video, id)
    render conn, "show.html", video: video
  end
end
