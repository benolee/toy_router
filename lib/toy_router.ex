defmodule ToyRouter do
  @behaviour :vegur_interface

  require Record
  Record.defrecord :state, tries: []

  def init(accept_time, upstream) do
    :random.seed(accept_time)
    {:ok, upstream, state()}
  end

  def lookup_domain_name(_all_domains, upstream, state) do
    servers = [
      {1, {127,0,0,1}, 8081},
      {2, {127,0,0,1}, 8082},
    ]

    {:ok, servers, upstream, state}
  end

  def checkout_service(servers, upstream, state = state(tries: tried)) do
    available = servers -- tried
    case available do
      [] ->
        {:error, :all_blocked, upstream, state}
      _  ->
        n = :random.uniform(length(available))
        pick = :lists.nth(n, available)
        {:service, pick, upstream, state(tries: [pick | tried])}
    end
  end

  def service_backend({_id, ip, port}, upstream, state) do
    {{ip, port}, upstream, state}
  end

  def checkin_service(_servers, _pick, _phase, _serv_state, upstream, state) do
    {:ok, upstream, state}
  end

  def feature(_who_cares, state) do
    {:disabled, state}
  end

  def additional_headers(_direction, _log, _upstream, state) do
    {[], state}
  end

  # Vegur-returned errors that should be handled no matter what.
  # Full list in src/vegur_stub.erl
  def error_page({:upstream, _reason}, _domain_group, upstream, handler_state) do
    # Blame the caller
    {{400, [], ""}, upstream, handler_state}
  end

  def error_page({:downstream, _reason}, _domain_group, upstream, handler_state) do
    # Blame the server
    {{500, [], ""}, upstream, handler_state};
  end

  def error_page({:undefined, _reason}, _domain_group, upstream, handler_state) do
    # Who knows who was to blame!
    {{500, [], ""}, upstream, handler_state};
  end

  # Specific error codes from middleware
  def error_page(:empty_host, _domain_group, upstream, handler_state) do
    {{400, [], ""}, upstream, handler_state};
  end
  def error_page(:bad_request, _domain_group, upstream, handler_state) do
    {{400, [], ""}, upstream, handler_state};
  end
  def error_page(:expectation_failed, _domain_group, upstream, handler_state) do
    {{417, [], ""}, upstream, handler_state};
  end

  # Catch-all
  def error_page(_, _domain_group, upstream, handler_state) do
    {{500, [], ""}, upstream, handler_state}
  end

  def terminate(_, _, _) do
    :ok
  end


  #   use Application
  #   # See http://elixir-lang.org/docs/stable/elixir/Application.html
  #   # for more information on OTP Applications
  #   def start(_type, _args) do
  #     import Supervisor.Spec, warn: false
  #
  #     children = [
  #       # Define workers and child supervisors to be supervised
  #       # worker(ToyRouter.Worker, [arg1, arg2, arg3]),
  #     ]
  #
  #     # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
  #     # for other strategies and supported options
  #     opts = [strategy: :one_for_one, name: ToyRouter.Supervisor]
  #     Supervisor.start_link(children, opts)
  #   end
end
