defmodule Rocketpay.Users.Get do
  alias Rocketpay.{Error, Repo, User}

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.build_user_not_found_error()}
      user -> preload_data(user)
    end
  end

  def by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, Error.build_user_not_found_error()}
      user -> preload_data(user)
    end
  end

  defp preload_data(user) do
    {:ok, Repo.preload(user, :account)}
  end
end
