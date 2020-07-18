%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(single_vm_test).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

-define(CATALOG_FILE,"configs/catalog.config").
%% --------------------------------------------------------------------
%-compile(export_all).0
-export([start/0,stop/0]).


-define(SINGLE_NODE,sthlm_1@asus).
-define(ALL_SERVICES,
	[{"log_service",sthlm_1@asus},
	 {"vm_service",sthlm_1@asus}]).
%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:emulate loader
%% Description: requires pod+container module
%% Returns: non
%% --------------------------------------------------------------------
start()->
    ?debugMsg("setup"),    
    ?assertEqual(ok,setup()),

    ?debugMsg("start_adder"),    
    ?assertEqual(ok,start_adder()),  

%    ?debugMsg("available_services_1"),    
%    ?assertEqual(ok,available_services_1()),   
%    ?debugMsg("available_services_2"),    
%    ?assertEqual(ok,available_services_2()),   
 %   ?debugMsg("stop"),    
    stop(),    
    
    ok.

%% --------------------------------------------------------------------
%% Function:emulate loader
%% Description: requires pod+container module
%% Returns: non
%% --------------------------------------------------------------------
setup()->
    ok.
start_adder()->
    {ok,CatalogInfo}=file:consult(?CATALOG_FILE),
    glurk=lists:keyfind("adder_service",1,CatalogInfo),
    ok.
available_services_1()->
    
    AllServices=service:all(),
    R=[{lists:member({ServiceId,Node},AllServices),ServiceId,Node}||{ServiceId,Node}<-?ALL_SERVICES],
%    io:format("~p~n",[[{ServiceId,Node}||{false,ServiceId,Node}<-R]]),
    case [{ServiceId,Node}||{false,ServiceId,Node}<-R] of
	[]->
	    io:format("Ok  ~p~n",[{?MODULE,available_services}]);
	Err->
	    io:format("error in ~p~n",[{?MODULE,available_services,Err}])
    end,
    ok.

available_services_2()->
    Nodes=nodes(),
    check_other_nodes(Nodes),
    ok.

check_other_nodes([])->
    ok;
check_other_nodes([WorkerNode|T])->
    case rpc:call(WorkerNode,dns_service,all,[]) of
	{badrpc,Err}->
	    io:format("badrpc in ~p~n",[{?MODULE,?LINE,available_services_2,Err}]);
	AllServices->
	    R=[{lists:member({ServiceId,Node},AllServices),ServiceId,Node}||{ServiceId,Node}<-?ALL_SERVICES],
	    case [{ServiceId,Node}||{false,ServiceId,Node}<-R] of
		[]->
		    io:format("Ok  ~p~n",[{?MODULE,?LINE,available_services_2,WorkerNode}]);
		Err->
		    io:format("error in ~p~n",[{?MODULE,available_services_2,WorkerNode,Err}])
	    end
    end,
    check_other_nodes(T).
  
stop()->
    init:stop().
