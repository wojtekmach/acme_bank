defmodule Backoffice.PageController do
  use Backoffice.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
