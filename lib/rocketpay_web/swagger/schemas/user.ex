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
            message(:string, "Message", example: "User created")

            user(
              Schema.new do
                properties do
                  account(Schema.ref(:Account))
                end
              end
            )

            id(:string, "User id", example: "75837acb-3f3d-407e-ac27-f245a41fecfc")
            name(:string, "Users name", example: "Joe")
            nickname(:string, "Users nickname", example: "joe")
          end
        end,
      UserErrorResponse:
        swagger_schema do
          title("UserErrorResponse")
          description("User")

          properties do
            message(
              Schema.new do
                properties do
                  age(:array, "Age related errors",
                    example: ["must be greater than or equal to 18"]
                  )

                  email(:array, "Email related errors", example: ["has invalid format"])
                  name(:array, "Name related errors", example: ["can't be blank"])
                  nickname(:array, "Nickname related errors", example: ["can't be blank"])

                  password(:array, "Password related errors",
                    example: ["should be at least 6 character(s)"]
                  )
                end
              end
            )
          end
        end
    }
  end
end
