defmodule RocketpayWeb.Swagger.Schemas.User do
  use PhoenixSwagger

  def build do
    %{
      UserParams:
        swagger_schema do
          title("CreateUser")
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
        end,
      User:
        swagger_schema do
          title("User")
          description("User data")

          properties do
            id(:string, "User id")
            name(:string, "Users name")
            nickname(:string, "Users nickname")
            email(:string, "Users email")
            password(:string, "Users password")
            age(:integer, "Users age")
          end

          example(%{
            id: "75837acb-3f3d-407e-ac27-f245a41fecfc",
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
