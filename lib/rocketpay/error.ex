defmodule Rocketpay.Error do
  @keys [:status, :result]

  @enforce_keys @keys

  defstruct @keys

  def build(status, result) do
    %__MODULE__{
      status: status,
      result: result
    }
  end

  def build_user_not_found_error, do: build(:not_found, "User not found")
  def build_invalid_operation_error, do: build(:bad_request, "Invalid operation!")
end

