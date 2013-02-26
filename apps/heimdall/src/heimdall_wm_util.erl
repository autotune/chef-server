-module(heimdall_wm_util).

-include("heimdall_wm.hrl").

-export([generate_authz_id/0,
         get_requestor/2,
         set_created_response/2,
         set_json_body/2]).

%% Generate random authz IDs for new objects
generate_authz_id() ->
    lists:flatten([io_lib:format("~4.16.0b", [X]) ||
                      <<X:16>> <= crypto:rand_bytes(16) ]).

%% Extract the requestor from the request headers and return updated base state.
get_requestor(Req, State) ->
    case wrq:get_req_header("X-Ops-Requesting-Actor-Id", Req) of
        undefined ->
            State;
        Id ->
            % TODO: we should probably verify that the requestor actually exists or
            % throw an exception
            State#base_state{requestor_id = Id}
    end.

scheme(Req) ->
    case wrq:get_req_header("x-forwarded-proto", Req) of
        undefined ->
            case wrq:scheme(Req) of
                https -> "https";
                http -> "http"
            end;
        Proto -> Proto
    end.

port_string(Default) when Default =:= 80; Default =:= 443 ->
    "";
port_string(Port) ->
    [$:|erlang:integer_to_list(Port)].

base_uri(Req) ->
    Scheme = scheme(Req),
    Host = string:join(lists:reverse(wrq:host_tokens(Req)), "."),
    PortString = port_string(wrq:port(Req)),
    Scheme ++ "://" ++ Host ++ PortString.

full_uri(Req) ->
    base_uri(Req) ++ wrq:disp_path(Req).

set_json_body(Req, EjsonData) ->
    Json = jiffy:encode(EjsonData),
    wrq:set_resp_body(Json, Req).

%% Used for all POST /<type> response bodies; always contains ID + URI
set_created_response(Req, AuthzId) ->
    Uri = full_uri(Req),
    Req0 = set_json_body(Req, {[{<<"id">>, list_to_binary(AuthzId)},
                                {<<"uri">>, list_to_binary(Uri)}]}),
    wrq:set_resp_header("Location", Uri, Req0).