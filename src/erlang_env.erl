-module(erlang_env).

%% Interface
-export([get_value/2]).
-export([raw_value/2]).
-export([load_default_config/1]).
-export([load_config/1]).
-export([load_config/2]).
-export([environment/0]).

get_value(Key, Configuration) ->
    {ok, SubConfiguration} = raw_value(environment(), Configuration),
    raw_value(Key, SubConfiguration).

raw_value(Key, Configuration) ->
    case proplists:get_value(Key, Configuration) of
        undefined -> {error, no_value};
        Other     -> {ok, Other}
    end.

load_default_config(Name) ->
    load_config("config/", Name).

load_config(Path, Name) when is_atom(Name) ->
    load_config(Path, atom_to_list(Name));
load_config(Path, Name) when is_list(Name) ->
    FileName = Name ++ ".yml",
    load_config(filename:join([Path, FileName])).

load_config(FullPath) ->
    case filelib:is_regular(FullPath) of
        true  ->
            file:consult(FullPath),
        false ->
            {error, {missing_file, FullPath}}
    end.

environment() ->
    case os:getenv("ERLANG_ENV") of
        false -> development;
        Other -> list_to_atom(Other)
    end.
