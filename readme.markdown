```
$ mix deps.get
$ iex -S mix
```

```elixir
iex(1)> r ToyRouter
{:reloaded, ToyRouter, [ToyRouter]}
iex(2)> :application.ensure_all_started(:vegur)
{:ok,
 [:ranch, :ranch_proxy_protocol, :cowlib, :cowboyku, :midjan, :uuid,
  :erequest_id, :vegur]}
iex(3)> :vegur.start_http(8080, ToyRouter, [{:middlewares, :vegur.default_middlewares()}])
{:ok, #PID<0.297.0>}
```
