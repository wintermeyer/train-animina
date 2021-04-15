defmodule Animina.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Inspect, except: [:password]}
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :confirmed_at, :naive_datetime
    field :first_name, :string
    field :last_name, :string
    field :gender, :string
    field :username, :string
    field :email_md5sum, :string
    field :birthday, :date
    field :about, :string
    field :homepage, :string
    field :lang, :string
    field :timezone, :string
    field :points, :integer
    field :lifetime_points, :integer
    field :coupon_code, :string
    field :redeemed_coupon_code, :string
    has_many :messages, Animina.Chats.Message
    has_many :received_transfers, Animina.Points.Transfer, foreign_key: :receiver_id
    has_many :teams, Animina.Games.Team, foreign_key: :owner_id, on_delete: :delete_all

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [
      :email,
      :password,
      :first_name,
      :last_name,
      :gender,
      :birthday,
      :username,
      :lang,
      :timezone,
      :redeemed_coupon_code
    ])
    |> validate_length(:username, min: 2, max: 40)
    |> validate_email()
    |> validate_required([:email, :username, :lang, :gender, :last_name, :first_name, :timezone])
    |> downcase_username
    |> create_and_set_coupon_code
    |> validate_redeemed_coupon_code
    |> validate_inclusion(:gender, ["male", "female", "other", "prefer not to say"])
    |> validate_inclusion(:lang, ["de", "en"])
    |> validate_inclusion(:timezone, TimeZoneInfo.time_zones())
    |> validate_exclusion(:birthday, [~D[1900-01-01]], message: "please enter your real birthday")
    |> unique_constraint([:username, :email])
    |> unique_constraint([:username, :coupon_code])
    |> validate_length(:first_name, max: 255)
    |> validate_length(:last_name, max: 255)
    |> validate_password(opts)
  end

  defp create_and_set_coupon_code(changeset) do
    put_change(changeset, :coupon_code, CouponCode.generate())
  end

  defp validate_redeemed_coupon_code(changeset) do
    case get_change(changeset, :redeemed_coupon_code) do
      nil ->
        changeset

      redeemed_coupon_code ->
        case CouponCode.validate(redeemed_coupon_code) do
          {:ok, validated_coupon_code} ->
            put_change(changeset, :redeemed_coupon_code, validated_coupon_code)

          _ ->
            changeset
        end
    end
  end

  defp downcase_email_address(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end

  defp downcase_username(changeset) do
    update_change(changeset, :username, &String.downcase/1)
  end

  defp fill_email_md5sum(changeset) do
    if email = get_change(changeset, :email) do
      email_md5sum =
        :crypto.hash(:md5, email)
        |> Base.encode16()
        |> String.downcase()

      put_change(changeset, :email_md5sum, email_md5sum)
    else
      changeset
    end
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> downcase_email_address
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, min: 5, max: 255)
    |> unsafe_validate_unique(:email, Animina.Repo)
    |> unique_constraint([:email, :username])
    |> fill_email_md5sum
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password,
      min: Application.fetch_env!(:animina, :min_password_length),
      max: 80
    )
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Animina.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :first_name,
      :last_name,
      :gender,
      :birthday,
      :username,
      :about,
      :homepage,
      :lang,
      :timezone,
      :points,
      :lifetime_points
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :gender,
      :birthday,
      :username,
      :lang,
      :timezone,
      :points,
      :lifetime_points
    ])
    |> validate_length(:username, min: 2, max: 40)
    |> downcase_username
    |> validate_inclusion(:gender, ["male", "female", "other", "prefer not to say"])
    |> validate_exclusion(:birthday, [~D[1900-01-01]], message: "please enter your real birthday")
    |> unique_constraint(:username)
    |> validate_length(:first_name, max: 255)
    |> validate_length(:last_name, max: 255)
    |> validate_length(:about, max: 512)
    |> validate_inclusion(:lang, ["de", "en"])
    |> validate_inclusion(:timezone, TimeZoneInfo.time_zones())
    |> validate_number(:points, greater_than_or_equal_to: 0)
    |> validate_number(:lifetime_points, greater_than_or_equal_to: 0)
  end
end
