defmodule Backoffice.Repo do
  use Ecto.Repo, otp_app: :backoffice
  use Scrivener, page_size: 10
end
