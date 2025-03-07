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
    {{<<"application">>,<<"x-www-form-urlencoded">>,[]}, post_json}], 
    Req, State}.

post_json(Req, State) ->
  User_directory = code:priv_dir(towing_company) ++ "/users/admins.json",
  {ok, Json} = file:read_file(User_directory),
  Json_decoded = json:decode(Json),
  {ok, Body,Req1} = cowboy_req:read_urlencoded_body(Req),
  New_data = maps:from_list(Body),
  Employee = maps:get(<<"Name">>, New_data),
  New_data_employee_removed = maps:remove(<<"Name">>, New_data),
  New_data_map = #{Employee => New_data_employee_removed},
  Concated_data = maps:merge(New_data_map,Json_decoded),
  ok = file:write_file(User_directory,json:encode(Concated_data)),
  %erlang:display(Concated_data),
  io:format("Data Received~n"),
  {true, Req1, State}.
