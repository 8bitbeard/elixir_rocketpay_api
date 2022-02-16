defmodule RocketpayWeb.Swagger.User do

  defmacro __using__(_) do
    quote do
      use PhoenixSwagger
      use RocketpayWeb.Swagger.Schemas

      alias PhoenixSwagger.Schema

      swagger_path(:create) do
        tag("Users")

        summary("Cadastro de um novo usuário no sistema")

        post("/api/users")
        produces("application/json")
        consumes("application/json")

        description("Essa é uma descrição do endpoint")

        parameters do
          body(:body, Schema.ref(:UserParams), "Parâmetros de criação de um novo User", required: true)
        end

        response(201, "Created", Schema.ref(:User))

        response(400, "Bad request", Schema.ref(:UserErrorResponse))

        response(500, "Internal server error")
      end
    end
  end
end
