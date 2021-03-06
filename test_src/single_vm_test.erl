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

%% --------------------------------------------------------------------
%-compile(export_all).0
-export([start/0,stop/0]).


-define(VM_1,sthlm_1@asus).
-define(INITIAL_SERVICES,
	[{"sd_service",sthlm_1@asus},
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
    
    ?assertMatch({pong,_,vm_service},rpc:call(?VM_1,vm_service,ping,[])),
    rpc:call(?VM_1,vm_service,stop_service,["adder_service"]),
    ok.
start_adder()->

    {ok,CatalogInfo}=file:consult(?CATALOG_FILE),
    {ServiceId,Type,Source}=lists:keyfind("adder_service",1,CatalogInfo),
    ?assertMatch({"adder_service",git,_},{ServiceId,Type,Source}),
    ?assertEqual({ok,"adder_service"},
		 rpc:call(?VM_1,vm_service,start_service,[ServiceId,Type,Source])),
%    timer:sleep(1000),
    ?assertEqual(42,
		 rpc:call(?VM_1,adder_service,add,[20,22])),
    ok.
    
    
stop()->
    rpc:call(?VM_1,vm_service,stop_service,["adder_service"]),
    ok.
