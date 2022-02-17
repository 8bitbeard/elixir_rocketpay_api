defmodule RocketpayWeb.Swagger.Schemas.Auth do
  use PhoenixSwagger

  def build do
    %{
      AuthenticateParams:
        swagger_schema do
          title("Authenticate")
          description("Authenticate")

          properties do
            email(:string, "Users email", required: true)
            password(:string, "Users password", required: true)
          end

          example(%{
            email: "joe@example.com",
            password: "joe123"
          })
        end,
      AuthenticateResponse:
        swagger_schema do
          title("AuthenticateResponse")
          description("Authenticate Response")

          properties do
            message(:string, "Success message", example: "Authenticated successfully")

            token(:string, "Bearer token",
              example:
                "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJyb2NrZXRwYXkiLCJleHAa" <>
                  "iOjE2NDc1Mzk1NjYsImlhdCI6MTY0NTEyMDM2NiwiaXNzIjoicm9ja2V0cGF5IiwianRp" <>
                  "IjoiMDQ5MjlmNzItMzFhYi00MzMwLTg1M2YtOWY4ODU3Yjc5N2E2IiwibmJmIjoxNjQ1M" <>
                  "TIwMzY1LCJzdWIiOiJmNmE0ODU2NS0yODFkLTQ0NTctYjViOS01OTU2NTE1MDgwOGEiLC" <>
                  "J0eXAiOiJhY2Nlc3MifQ.hVEmpUfPIElmN66FL2uCkfCmeSC_3usyAHOzj21or5wwpfXO" <>
                  "tL9ujf-7X5wo7QhBK4rGVHH2tG_CQXPCaiy6vw"
            )
          end
        end,
      AuthenticateErrorResponse:
        swagger_schema do
          title("UserErrorResponse")
          description("User")

          properties do
            message(:string, "Error message", example: "Wrong e-mail or password!")
          end
        end
    }
  end
end
