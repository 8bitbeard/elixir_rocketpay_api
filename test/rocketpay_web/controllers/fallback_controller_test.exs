defmodule RocketpayWeb.FallbackControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias RocketpayWeb.FallbackController

  describe "call/2" do
    test "when called with a error tuple, renders an error", %{conn: conn} do

      response = FallbackController.call(conn, {:error, "tuple error message"})

      assert json_response(response, 400) == %{"message" => "tuple error message"}
    end
  end
end
