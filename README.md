# Guardian.Backdoor

`Guardian.Backdoor` is a plug to enable writing faster acceptance tests by skipping the sign-in process. This feature is inspired by Clearance’s backdoor.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `guardian_backdoor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:guardian_backdoor, "~> 0.1.0", only: :test}
  ]
end
```

Add the following to your Phoenix router before other Guardian plugs.

  ```elixir
  if Mix.env() == :test do
    plug Guardian.Plug.Backdoor, module: MyApp.Guardian
  end
  plug Guardian.Plug.VerifySession
  ```

  > NOTE: This plug is designed for acceptance testing and should never be added
  to a production environment.

  ## Usage

  Now that `Guardian.Plug.Backdoor` is installed, it's time to sign in. A simple GET request will work.

  ```elixir
  {:ok, token, _claims} = MyApp.Guardian.encode_and_sign(resource)

  conn = get(conn, "/?token=#{token}")

  resource = MyApp.Guardian.Plug.current_resource(conn)
  ```

  When the `Guardian.Plug.Backdoor` plug runs, it looks up the resource from the `token` passed in and signs in.

  ### Hound

  If you're using [Hound](https://github.com/HashNuke/hound), you can write the following code.

  ```elixir
  {:ok, token, _claims} = MyApp.Guardian.encode_and_sign(resource)

  navigate_to("/?token=#{token}")
  ```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/guardian_backdoor](https://hexdocs.pm/guardian_backdoor).
