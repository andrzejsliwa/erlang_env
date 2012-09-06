-module(erlang_env).

%% Library interface
-export([get_value/1]).
-export([get_value/2]).
-export([get/0]).

get_value(Key) ->
    {ok, Config} = application:get_env(erlang_env:get()),
    value(Key, Config).

get_value(Application, Key) ->
    {ok, Config} = application:get_env(Application, erlang_env:get()),
    value(Key, Config).

value(Key, Config) ->
    case proplists:get_value(Key, Config) of
        undefined -> {error, no_value};
        Other     -> {ok, Other}
    end.

get() ->
    case os:getenv("ERLANG_ENV") of
        false -> development;
        Other -> list_to_atom(Other)
    end.
