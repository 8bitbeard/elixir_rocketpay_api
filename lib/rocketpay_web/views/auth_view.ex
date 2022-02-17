defmodule RocketpayWeb.AuthView do
  use RocketpayWeb, :view

  def render("login.json", %{token: token}) do
    %{
      message: "Authenticated successfully",
      token: token,
    }
  end
end
