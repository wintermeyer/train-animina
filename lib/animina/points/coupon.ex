defmodule Animina.Points.Coupon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coupons" do
    field :amount, :integer
    field :code, :string
    belongs_to :redeemer, Animina.Accounts.User, foreign_key: :redeemer_id

    timestamps()
  end

  @doc false
  def changeset(coupon, attrs) do
    coupon
    |> cast(attrs, [:amount, :redeemer_id])
    |> create_coupon_code()
    |> validate_required([:code, :amount])
    |> unique_constraint(:code)
  end

  defp create_coupon_code(changeset) do
    put_change(changeset, :code, CouponCode.generate())
  end
end
