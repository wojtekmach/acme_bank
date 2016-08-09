defmodule Backoffice.ExAdmin.AuthAccount do
  use ExAdmin.Register

  register_resource Auth.Account do
    menu label: "Auth Accounts"
    options resource_name: "auth_account", controller_route: "auth_accounts"

    filter [:id, :email]

    index do
      column :id
      column :email
    end

    show _account do
      attributes_table do
        row :id
        row :email
        row :inserted_at
        row :updated_at
      end
    end

    form account do
      inputs do
        input account, :email

        unless account.id do
          input account, :password
        end
      end
    end
  end
end
