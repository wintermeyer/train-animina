defmodule Animina.Points.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transfers" do
    field :amount, :integer
    field :description, :string
    belongs_to :receiver, Animina.Accounts.User
    belongs_to :sender, Animina.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(transfer, attrs) do
    transfer
    |> cast(attrs, [:receiver_id, :sender_id, :amount, :description])
    |> validate_required([:receiver_id, :amount])
    |> assoc_constraint(:receiver)
  end
end
