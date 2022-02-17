defmodule RocketpayWeb.FallbackControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.Error
  alias RocketpayWeb.FallbackController

  describe "call/2" do
    test "when called with a error struct, renders an error", %{conn: conn} do
      response =
        FallbackController.call(conn, {:error, Error.build(:bad_request, "tuple error message")})

      assert json_response(response, 400) == %{"message" => "tuple error message"}
    end
  end
end
