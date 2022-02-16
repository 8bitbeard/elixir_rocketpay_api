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
      OperationRequest:
        swagger_schema do
          title("Operation")
          description("Operation")

          properties do
            value(:string, "Operation value", example: "5.15")
          end
        end,
      TransactionRequest:
        swagger_schema do
          title("Transaction")
          description("Transaction")

          properties do
            from(:string, "Id of account that the transaction is comming from",
              example: "39b05f73-ee6a-46a3-9db7-8363a94287d1"
            )

            to(:string, "Id of account that the transaction is going to",
              example: "3b0f83f8-9ad9-4913-92f5-cd76a4997e6a"
            )

            value(:string, "Value of transaction", example: "15.12")
          end
        end,
      OperationResponse:
        swagger_schema do
          title("OperationResponse")
          description("Response of Deposit and Withdraw operations")

          properties do
            message(:string, "Message of transaction", example: "Balance changed successfully")
            account(Schema.ref(:Account))
          end
        end,
      TransactionResponse:
        swagger_schema do
          title("TransactionResponse")
          description("Response of transaction operations")

          properties do
            message(:string, "Message of transaction", example: "Transaction done successfully")

            transaction(
              Schema.new do
                properties do
                  from_account(Schema.ref(:Account))
                  to_account(Schema.ref(:Account))
                end
              end
            )
          end
        end,
      OperationErrorResponse:
        swagger_schema do
          title("OperationErrorResponse")
          description("Error response for operation")

          properties do
            message(:string, "Error message", example: "Invalid transaction value!")
          end
        end
    }
  end
end
