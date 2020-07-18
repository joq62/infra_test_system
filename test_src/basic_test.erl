%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(basic_test).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------
%-compile(export_all).0
-export([start/0,stop/0]).



-define(ALL_SERVICES,
	[{"dns_service",worker_sthlm_1@asus},
	 {"boot_service",worker_sthlm_1@asus},
	 {"dns_service",worker_sthlm_2@asus},
	 {"boot_service",worker_sthlm_2@asus},
	 {"dns_service",worker_sthlm_3@asus},
	 {"boot_service",worker_sthlm_3@asus}]).
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
    ?debugMsg("available_services_1"),    
    ?assertEqual(ok,available_services_1()),   
    ?debugMsg("available_services_2"),    
    ?assertEqual(ok,available_services_2()),   
    ?debugMsg("stop"),    
    stop(),    
    
    ok.

%% --------------------------------------------------------------------
%% Function:emulate loader
%% Description: requires pod+container module
%% Returns: non
%% --------------------------------------------------------------------
setup()->
    ok=application:start(dns_service),
    timer:sleep(2000),
    ok.
available_services_1()->
    
    AllServices=dns_service:all(),
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
