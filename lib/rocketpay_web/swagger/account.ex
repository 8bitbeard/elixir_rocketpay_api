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
          body(:body, Schema.ref(:Operation), "Parâmetros para realização da operação", required: true)
        end

        response(201, "Created", Schema.ref(:Operation))
      end
    end
  end
end
