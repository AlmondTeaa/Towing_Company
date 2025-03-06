%%%-------------------------------------------------------------------
%% @doc towing_company public API
%% @end
%%%-------------------------------------------------------------------

-module(towing_company_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{
    '_', [
            {"/api/auth/login", auth_login_handler, []},
            {"/api/auth/me", auth_me_handler, []}
        ]}
    ]),

    Priv_directory = code:priv_dir(towing_company),
    {ok, _} = cowboy:start_tls(https, [{port,8443},
        {certfile, Priv_directory ++ "/ssl/towing_company.crt"},
        {keyfile, Priv_directory ++ "/ssl/towing_company.key"}],
        #{env => #{dispatch => Dispatch}}
    ),

    towing_company_sup:start_link().

stop(_State) ->
    ok = cowboy:stop_listener(https).

%% internal functions
