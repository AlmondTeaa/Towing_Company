-module(auth_login_handler).
-export([init/2]).
-export([allowed_methods/2]).
-export([content_types_provided/2]).
-export([content_types_accepted/2]).

-export([check_credential/2]).

init(Req, State) ->
  {cowboy_rest, Req, State}.

allowed_methods(Req,State) ->
  {[<<"GET">>,<<"POST">>], Req, State}.
  
content_types_provided(Req, State) ->
  {[
    {{<<"application">>,<<"json">>, []}, get_html}],
    Req, State}.

  content_types_accepted(Req, State) ->
  {[
    {{<<"application">>,<<"x-www-form-urlencoded">>, []}, check_credential}],
    Req, State}.

  check_credential(Req, State) ->
    {ok, [{<<"username">>, Name},{<<"password">>, Password}], Req1} = cowboy_req:read_urlencoded_body(Req),
    Users_Priv_Directory = code:priv_dir(towing_company),
    {ok, Json_data} = file:read_file(Users_Priv_Directory ++ "/users/admins.json"),
    Json_data_decoded = json:decode(Json_data),
    EmployeeData = maps:get(Name, Json_data_decoded),
    EmployeePassword = maps:get(<<"password">>,EmployeeData),
    case Password==EmployeePassword of
      true -> erlang:display("Crendential Accepted");
      false -> erlang:display("Crendential Rejected")  
    end,
    
    {true, Req1, State}.