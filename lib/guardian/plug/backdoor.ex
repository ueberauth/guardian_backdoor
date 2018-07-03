defmodule Guardian.Plug.Backdoor do
  @moduledoc """
  This plug allows you to bypass authentication in acceptance tests by passing
  the token needed to load the current resource directly to your Guardian module
  via a query string parameter.

  ## Installation

  Add the following to your Phoenix router before other Guardian plugs.

  ```
  if Mix.env() == :test do
    plug Guardian.Plug.Backdoor, module: MyApp.Guardian
  end
  plug Guardian.Plug.VerifySession
  ```

  NOTE: This plug is designed for acceptance testing and should never be added
  to a production environment.

  ## Usage

  Now that `Guardian.Plug.Backdoor` is installed, it's time to sign in. Pass
  your claims as `claims` in the query string of your route.

  ```
  conn = get(conn, "/", claims: %{sub: "User:1"})

  resource = MyApp.Guardian.Plug.current_resource(conn)
  %{"sub" => "User:1"} = MyApp.Guardian.Plug.current_claims(conn)
  ```

  When the `Guardian.Plug.Backdoor` plug runs, it fetches the resource from your
  Guardian implementation with those claims and signs in.

  Alternatively, encode your claims into a token and pass that as `token` in the
  query string instead.

  ```
  {:ok, token, _claims} = MyApp.Guardian.encode_and_sign(resource)

  conn = get(conn, "/", token: token)

  resource = MyApp.Guardian.Plug.current_resource(conn)
  ```

  ## Options

    `:module` - Your app's `Guardian` implementation module. Required.

  [hound]: https://github.com/HashNuke/hound
  """
  import Plug.Conn

  @doc false
  def init(opts) do
    Enum.into(opts, %{})
  end

  @doc false
  def call(conn, %{module: module}) do
    conn = fetch_query_params(conn)

    case resource_from_params(module, conn.params) do
      {:ok, resource, claims} ->
        module = Module.concat(module, Plug)
        module.sign_in(conn, resource, claims)

      _ ->
        conn
    end
  end

  defp resource_from_params(module, %{"token" => token}) do
    case module.resource_from_token(token) do
      {:ok, resource, claims} -> {:ok, resource, claims}
      error -> error
    end
  end

  defp resource_from_params(module, %{"claims" => claims}) do
    case module.resource_from_claims(claims) do
      {:ok, resource} -> {:ok, resource, claims}
      error -> error
    end
  end

  defp resource_from_params(_module, _params), do: :no_resource_found
end
