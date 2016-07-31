defmodule BankWeb.PageController do
  use BankWeb.Web, :controller
  plug BankWeb.Authentication.Require

  def index(conn, _params) do
    render conn, "index.html"
  end
end
