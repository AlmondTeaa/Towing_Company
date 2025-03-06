-module(auth_register_handler).
-export([init/2]).
-export([allowed_methods/2]).
-export([content_types_accepted/2]).
-export([post_json/2]).

init(Req, State) ->
  {cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
  {[<<"POST">>], Req, State}.

content_types_accepted(Req, State) ->
  {[
    {{<<"application">>,<<"json">>,[]}, post_json}], 
    Req, State}.

post_json(Req, State) ->
  Priv_directory = code:priv_dir(towing_company),
  {ok, Json} = file:read_file(Priv_directory ++ "/users/admins.json"),
  {Json, Req, State}.
