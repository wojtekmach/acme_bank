defimpl ExAdmin.Render, for: Money do
  defdelegate to_string(money), to: Money
end

defmodule Backoffice.ExAdmin.Dashboard do
  use ExAdmin.Register

  register_page "Dashboard" do
    menu priority: 1, label: "Dashboard"
    content do
      div ".blank_slate_container#dashboard_default_message" do
        span ".blank_slate" do
          span "Welcome to Acme Bank Backoffice"
        end
      end
    end
  end
end
