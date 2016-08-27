defmodule BankWeb.Router do
  use BankWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BankWeb.Authentication
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    post "/sign_in_as/:username", SessionController, :sign_in_as
    get "/sign_out", SessionController, :sign_out

    get "/account", AccountController, :show

    get "/transfers/new", TransferController, :new
    post "/transfers", TransferController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", BankWeb do
  #   pipe_through :api
  # end
end
