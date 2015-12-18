defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase
  alias Rumbl.Video

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      get(conn, video_path(conn, :edit, "123")),
      get(conn, video_path(conn, :update, "123")),
      get(conn, video_path(conn, :create, %{})),
      get(conn, video_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  setup %{conn: conn}=config do
    if username = config[:login_as] do
      user = insert_user(username: username)
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag login_as: "max"
  test "lists all user's videos on index", %{user: user, conn: conn} do
    user_video = insert_video(user, title: "funny cats")
    other_video = insert_video(insert_user(username: "other"), title: "another video")

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/My Videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  @valid_attrs %{url: "http://youtu.be", title: "video", description: "video"}
  @invalid_attrs %{title: "invalid"}

  @tag login_as: "max"
  test "creates user video and redirects", %{conn: conn, user: user} do
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)
    assert Repo.get_by!(Video, @valid_attrs).user_id == user.id
  end

  @tag login_as: "max"
  test "does not create a video and renders errors", %{conn: conn} do
    conn = post conn, video_path(conn, :create), video: @invalid_attrs
    assert html_response(conn, 200) =~ ~r/Oops, something went wrong! Please check the errors below/
    assert html_response(conn, 200) =~ ~r/Url can&#39;t be blank/
  end

  @tag login_as: "max"
  test "cannot show, edit, update, or delete another user's videos", %{user: owner, conn: conn} do
    video = insert_video(owner, title: "cats afraid of cucumbers")
    interloper = insert_user(username: "ted")
    conn = assign(conn, :current_user, interloper)

    assert_raise Ecto.NoResultsError, fn ->
      get(conn, video_path(conn, :show, video))
    end
    assert_raise Ecto.NoResultsError, fn ->
      get(conn, video_path(conn, :edit, video))
    end
    assert_raise Ecto.NoResultsError, fn ->
      put(conn, video_path(conn, :show, video), video: @valid_attrs)
    end
    assert_raise Ecto.NoResultsError, fn ->
      delete(conn, video_path(conn, :delete, video))
    end
  end
end
