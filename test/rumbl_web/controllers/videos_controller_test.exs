defmodule RumblWeb.VideosControllerTest do
  use RumblWeb.ConnCase

  alias Rumbl.Multimedia

  @create_attrs %{description: "some description", title: "some title", url: "some url"}
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    url: "some updated url"
  }
  @invalid_attrs %{description: nil, title: nil, url: nil}

  def fixture(:videos) do
    {:ok, videos} = Multimedia.create_videos(@create_attrs)
    videos
  end

  describe "index" do
    test "lists all videos", %{conn: conn} do
      conn = get(conn, Routes.videos_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Videos"
    end
  end

  describe "new videos" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.videos_path(conn, :new))
      assert html_response(conn, 200) =~ "New Videos"
    end
  end

  describe "create videos" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.videos_path(conn, :create), videos: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.videos_path(conn, :show, id)

      conn = get(conn, Routes.videos_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Videos"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.videos_path(conn, :create), videos: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Videos"
    end
  end

  describe "edit videos" do
    setup [:create_videos]

    test "renders form for editing chosen videos", %{conn: conn, videos: videos} do
      conn = get(conn, Routes.videos_path(conn, :edit, videos))
      assert html_response(conn, 200) =~ "Edit Videos"
    end
  end

  describe "update videos" do
    setup [:create_videos]

    test "redirects when data is valid", %{conn: conn, videos: videos} do
      conn = put(conn, Routes.videos_path(conn, :update, videos), videos: @update_attrs)
      assert redirected_to(conn) == Routes.videos_path(conn, :show, videos)

      conn = get(conn, Routes.videos_path(conn, :show, videos))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, videos: videos} do
      conn = put(conn, Routes.videos_path(conn, :update, videos), videos: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Videos"
    end
  end

  describe "delete videos" do
    setup [:create_videos]

    test "deletes chosen videos", %{conn: conn, videos: videos} do
      conn = delete(conn, Routes.videos_path(conn, :delete, videos))
      assert redirected_to(conn) == Routes.videos_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.videos_path(conn, :show, videos))
      end
    end
  end

  defp create_videos(_) do
    videos = fixture(:videos)
    %{videos: videos}
  end
end
