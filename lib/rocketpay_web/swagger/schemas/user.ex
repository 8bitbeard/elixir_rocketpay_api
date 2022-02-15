defmodule RocketpayWeb.Swagger.Schemas.User do
  use PhoenixSwagger

  def build do
    %{
      UserParams:
        swagger_schema do
          title("User parameters")
          description("Users")

          properties do
            name(:string, "Users name", required: true)
            nickname(:string, "Users nickname", required: true)
            email(:string, "Users email", required: true)
            password(:string, "Users password", required: true)
            age(:integer, "Users age", required: true)
          end

          example(%{
            name: "Joe",
            nickname: "joe",
            email: "joe@example.com",
            password: "joe123",
            age: 45
          })
        end
    }
  end
end
