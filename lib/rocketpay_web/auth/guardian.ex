defmodule RocketpayWeb.Auth.Guardian do
  use Guardian, otp_app: :rocketpay

  alias Rocketpay.{Error, User}
  alias Rocketpay.Users.Get, as: UsersGet

  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> UsersGet.by_id()
  end

  def authenticate(%{"email" => email, "password" => password}) do
    with {:ok, %User{password_hash: hash} = user} <- UsersGet.by_email(email),
         true <- Bcrypt.verify_pass(password, hash),
         {:ok, token, _claims} <- encode_and_sign(user) do
      {:ok, token}
    else
      _ -> {:error, Error.build(:unauthorized, "Wrong e-mail or password!")}
    end
  end

  def authenticate(_), do: {:error, Error.build(:bad_request, "Invalid or missing params")}
end
