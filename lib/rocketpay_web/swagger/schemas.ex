defmodule RocketpayWeb.Swagger.Schemas do
  defmacro __using__(_opts) do
    quote do
      @schemas [
        RocketpayWeb.Swagger.Schemas.User,
        RocketpayWeb.Swagger.Schemas.Account,
        RocketpayWeb.Swagger.Schemas.Auth
      ]

      def swagger_definitions do
        Enum.reduce(@schemas, %{}, fn schema, schemas ->
          Map.merge(schemas, schema.build())
        end)
      end
    end
  end
end
