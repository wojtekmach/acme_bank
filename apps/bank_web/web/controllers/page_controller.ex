defmodule BankWeb.PageController do
  use BankWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
