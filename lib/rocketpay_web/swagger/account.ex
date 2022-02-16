defmodule RocketpayWeb.Swagger.Account do
  defmacro __using__(_) do
    quote do
      use PhoenixSwagger
      use RocketpayWeb.Swagger.Schemas

      alias PhoenixSwagger.Schema

      swagger_path(:deposit) do
        tag("Accounts")

        summary("Operação de depósito em uma conta")

        post("/api/accounts/{id}/deposit")
        produces("application/json")
        consumes("application/json")

        description("Essa é uma descrição do endpoint")

        parameters do
          id(:path, :string, "Account id", required: true)
          body(:body, Schema.ref(:OperationRequest), "Parâmetros para realização da operação",
            required: true
          )
        end

        response(200, "Ok", Schema.ref(:OperationResponse))

        response(400, "Bad request", Schema.ref(:OperationErrorResponse))

        response(401, "Unauthorized")

        response(500, "Internal server error")
      end

      swagger_path(:withdraw) do
        tag("Accounts")

        summary("Operação de saque de uma conta")

        post("/api/accounts/{id}/withdraw")
        produces("application/json")
        consumes("application/json")

        description("Essa é uma descrição do endpoint")

        parameters do
          id(:path, :string, "Account id", required: true)
          body(:body, Schema.ref(:OperationRequest), "Parâmetros para realização da operação",
            required: true
          )
        end

        response(200, "Ok", Schema.ref(:OperationResponse))

        response(400, "Bad request", Schema.ref(:OperationErrorResponse))

        response(401, "Unauthorized")

        response(500, "Internal server error")
      end

      swagger_path(:transaction) do
        tag("Accounts")

        summary("Operação de transferência de uma conta para outra")

        post("/api/accounts/transaction")
        produces("application/json")
        consumes("application/json")

        description("Essa é uma descrição do endpoint")

        parameters do
          body(:body, Schema.ref(:TransactionRequest), "Parâmetros para realização da transferência",
            required: true
          )
        end

        response(200, "Ok", Schema.ref(:TransactionResponse))

        response(400, "Bad request", Schema.ref(:OperationErrorResponse))

        response(401, "Unauthorized")

        response(500, "Internal server error")
      end
    end
  end
end
