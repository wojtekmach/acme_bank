defmodule Backoffice.Router do
  use Backoffice.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  use ExAdmin.Router

  scope "/backoffice", ExAdmin do
    pipe_through :browser
    admin_routes
  end
end
