# Guardian.Backdoor

`Guardian.Backdoor` is a plug to enable writing faster acceptance tests by skipping the sign-in process. This feature is inspired by Clearance’s backdoor.

## Installation

[Available in Hex](https://hex.pm/packages/guardian_backdoor), the package can be installed
by adding `guardian_backdoor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:guardian_backdoor, "~> 1.0.0", only: :test}
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
> to a production environment.

## Usage

Now that `Guardian.Plug.Backdoor` is installed, it's time to sign in. Pass your
claims as `claims` in the query string of your route.

```elixir
conn = get(conn, "/", claims: %{sub: "User:1"})

resource = MyApp.Guardian.Plug.current_resource(conn)
%{"sub" => "User:1"} = MyApp.Guardian.Plug.current_claims(conn)
```

When the `Guardian.Plug.Backdoor` plug runs, it fetches the resource from your
Guardian implementation with those claims and signs in.

Alternatively, encode your claims into a token and pass that as `token` in the
query string instead.

```elixir
{:ok, token, _claims} = MyApp.Guardian.encode_and_sign(resource)

conn = get(conn, "/", token: token)

resource = MyApp.Guardian.Plug.current_resource(conn)
```

### Hound

If you're using [Hound](https://github.com/HashNuke/hound), you can write the following code.

```elixir
query_params = Plug.Conn.Query.encode(claims: %{sub: "User:1"})

navigate_to("/?" <> query_params)
```

```elixir
{:ok, token, _claims} = MyApp.Guardian.encode_and_sign(resource)

navigate_to("/?token=#{token}")
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/guardian_backdoor](https://hexdocs.pm/guardian_backdoor).
