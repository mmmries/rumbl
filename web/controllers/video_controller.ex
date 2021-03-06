defmodule Rumbl.VideoController do
  use Rumbl.Web, :controller

  alias Rumbl.Video

  plug :scrub_params, "video" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    videos = Repo.all(user_videos(user))

    render(conn, "index.html", videos: videos)
  end

  def show(conn, %{"id" => id}, user) do
    {id, _rest} = Integer.parse(id)
    video = Repo.get!(user_videos(user), id)
    render(conn, "show.html", video: video)
  end

  def new(conn, _params, user) do
    changeset = user
    |> build(:videos)
    |> Video.changeset

    render(conn, "new.html", changeset: changeset, categories: all_categories)
  end

  def create(conn, %{"video" => video_params}, user) do
    changeset = user
    |> build(:videos)
    |> Video.changeset(video_params)

    case Repo.insert(changeset) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, categories: all_categories)
    end
  end

  def edit(conn, %{"id" => id}, user) do
    {id, _rest} = Integer.parse(id)
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset, categories: all_categories)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    {id, _rest} = Integer.parse(id)
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video, video_params)

    case Repo.update(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset, categories: all_categories)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    {id, _rest} = Integer.parse(id)
    video = Repo.get!(user_videos(user), id)
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  defp all_categories do
    Repo.all( from c in Rumbl.Category, select: {c.name, c.id} )
  end

  defp user_videos(user) do
    assoc(user, :videos)
  end
end
