defmodule RocketpayWeb.Swagger.Schemas.Account do
  use PhoenixSwagger

  def build do
    %{
      Account:
        swagger_schema do
          title("Account")
          description("Account")

          properties do
            id(:string, "Account id")
            balance(:string, "Account balance")
          end

          example(%{
            id: "d1103a13-d6c4-4d61-a632-3c8844f6e5f5",
            balance: "0.00"
          })
        end,
      Operation:
        swagger_schema do
          title("Operation")
          description("Operation")

          properties do
            id(:string, "Account id")
            value(:string, "Operation value")
          end

          example(%{
            id: "d1103a13-d6c4-4d61-a632-3c8844f6e5f5",
            value: "5.15"
          })
        end
    }
  end
end
