defmodule TaskTracker2Web.PageController do
  use TaskTracker2Web, :controller

  def index(conn, params) do
    IO.puts "----------=--------------"
    IO.inspect conn.assigns;
    current_user = Map.get(conn.assigns, :current_user);
    IO.puts "*************************"
    IO.inspect current_user;
    if current_user do
      conn
      |> put_flash(:info, "Session Restored.")
      |> redirect(to: task_path(conn, :index))
    else
      render conn, "index.html"
    end
  end

  # def feed(conn, _params) do
  #   posts = TaskTracker2.Tracker.list_posts()
  #   changeset = TaskTracker2.Tracker.change_post(%TaskTracker2.Tracker.Task{})
  #   render conn, "feed.html", posts: posts, changeset: changeset
  # end
end
