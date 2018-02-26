defmodule TaskTrackerWeb.PageController do
  use TaskTrackerWeb, :controller

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
  #   posts = TaskTracker.Tracker.list_posts()
  #   changeset = TaskTracker.Tracker.change_post(%TaskTracker.Tracker.Task{})
  #   render conn, "feed.html", posts: posts, changeset: changeset
  # end
end
