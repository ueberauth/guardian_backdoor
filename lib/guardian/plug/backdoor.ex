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

  Now that `Guardian.Plug.Backdoor` is installed, it's time to sign in.

  ```
  {:ok, token, _claims} = MyApp.Guardian.encode_and_sign(resource)

  conn = get(conn, "/?token=\#{token}")

  resource = MyApp.Guardian.Plug.current_resource(conn)
  ```

  When the `Guardian.Plug.Backdoor` plug runs, it looks up the resource from the
  `token` passed in and signs in.

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
    with {:ok, token} <- get_token(conn),
         {:ok, resource, _} <- module.resource_from_token(token) do
      sign_in(conn, module, resource)
    else
      _ -> conn
    end
  end

  defp get_token(conn) do
    conn = fetch_query_params(conn)
    Map.fetch(conn.params, "token")
  end

  defp sign_in(conn, module, resource) do
    app_plug = Module.concat(module, :Plug)
    app_plug.sign_in(conn, resource)
  end
end
