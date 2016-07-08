if Code.ensure_loaded?(Ecto.Type) do
  defmodule Money.Ecto do
    @moduledoc ~S"""

    Provides custom Ecto type to use `Money`.

    It might work with different adapters, but it has only been tested
    on PostgreSQL as a composite type.

    ## Usage:
    
    Schema:

        defmodule Item do
          use Ecto.Schema

          schema "items" do
            field :name, :string
            field :price, Money.Ecto
          end
        end

    Migration:

        def change do
          execute "
            CREATE TYPE moneyz AS (
              cents integer,
              currency varchar
            );
          "

          create table(:items) do
            add :name, :string
            add :price, :moneyz
          end
        end

    """

    @behaviour Ecto.Type

    def type, do: :moneyz

    # TODO:
    def cast(_), do: :error

    def load({cents, currency}) when is_integer(cents) and is_binary(currency) do
      {:ok, %Money{cents: cents, currency: currency}}
    end
    def load(_), do: :error

    def dump(%Money{cents: cents, currency: currency}) do
      {:ok, {cents, currency}}
    end
    def dump(_), do: :error
  end
end
