defmodule Guardian.Plug.BackdoorTest do
  @moduledoc false
  use ExUnit.Case, async: true
  use Plug.Test

  alias Guardian.Plug.Backdoor

  @resource %{id: "bobby"}

  defmodule Impl do
    @moduledoc false
    use Guardian,
      otp_app: :guardian_backdoor,
      secret_key: "guardian_backdoor"

    def subject_for_token(%{id: id}, _claims), do: {:ok, id}
    def subject_for_token(%{"id" => id}, _claims), do: {:ok, id}

    def resource_from_claims(%{"sub" => id}), do: {:ok, %{id: id}}
  end

  setup do
    [
      impl: __MODULE__.Impl,
      plug: __MODULE__.Impl.Plug
    ]
  end

  test "fetch resource from token", context do
    {:ok, token, _} = context.impl.encode_and_sign(@resource)

    conn =
      conn(:get, "/?token=#{token}")
      |> Backdoor.call(Backdoor.init(module: context.impl))

    assert context.plug.current_resource(conn) == @resource
  end

  test "no resource without token", context do
    conn =
      conn(:get, "/")
      |> Backdoor.call(Backdoor.init(module: context.impl))

    assert context.plug.current_resource(conn) == nil
  end

  test "no resource from invalid token", context do
    conn =
      conn(:get, "/?token=foo")
      |> Backdoor.call(Backdoor.init(module: context.impl))

    assert context.plug.current_resource(conn) == nil
  end
end
