-module(auth_me_handler).
-export([init/2]).
-export([allowed_methods/2]).
-export([content_types_provided/2]).
-export([get_json/2]).

init(Req, State) ->
  {cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
  {[<<"GET">>], Req, State}.

content_types_provided(Req, State) ->
  {[
    {{<<"application">>,<<"json">>,[]}, get_json}], 
    Req, State}.

get_json(Req, State) ->
  Priv_directory = code:priv_dir(towing_company),
  {ok, Json} = file:read_file(Priv_directory ++ "/users/admins.json"),
  io:format("Data get~n"),
  {Json, Req, State}.
