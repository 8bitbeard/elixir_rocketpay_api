defmodule RocketpayWeb.Swagger.Auth do
  defmacro __using__(_) do
    quote do
      use PhoenixSwagger
      use RocketpayWeb.Swagger.Schemas

      alias PhoenixSwagger.Schema

      swagger_path(:login) do
        tag("Authentication")

        summary("Autenticação de um usuário na aplicação")

        post("/api/auth/login")
        produces("application/json")
        consumes("application/json")

        description("Essa é uma descrição do endpoint")

        parameters do
          body(:body, Schema.ref(:AuthenticateParams), "Parâmetros de autenticação do usuário",
            required: true
          )
        end

        response(201, "Created", Schema.ref(:AuthenticateResponse))

        response(400, "Bad request", Schema.ref(:AuthenticateErrorResponse))

        response(500, "Internal server error")
      end
    end
  end
end
