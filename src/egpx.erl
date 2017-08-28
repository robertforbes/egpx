-module(egpx).

%% egpx: egpx library's entry point.

-export([read_file/2, read_file2/1, event_func/3]).


%% API

read_file(GpxFile, XsdSchema) ->
    {ok, Model} = erlsom:compile_xsd_file(XsdSchema), 
    {ok, Xml} = file:read_file(GpxFile),
    {ok, Result, _} = erlsom:scan(Xml, Model),
    {ok, Result}.


read_file2(GpxFile) ->
    xmerl_sax_parser:file(GpxFile, [{event_fun, fun event_func/3}]).

%% @doc Callback to use as an EventFun.
event_func(Event, Location, State) ->
    io:format("Ev: ~p Loc: ~p St: ~p~n", [Event, Location, State]),
    handle_event(Event, Location, State).

%% @doc Handle the events generated by the XML parser.
handle_event({startElement, _, _, _, _}, _, State) ->
    io:format("Start element detected~n"),
    State;
handle_event(_, _, State) -> State.

%% End of Module.
