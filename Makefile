all:
	rm -rf include configs test_src/*.beam test_ebin/* *_service  erl_crasch.dump;
#	sthlm_1
	rm -rf sthlm_1/include sthlm_1/configs sthlm_1/*_service  sthlm_1/erl_crasch.dump;
test:
	rm -rf include configs test_src/*.beam test_ebin/* *_service  erl_crasch.dump;
#	include
	git clone https://github.com/joq62/include.git;
#	configs
	git clone https://github.com/joq62/configs.git;
#	log_service
	git clone https://github.com/joq62/log_service.git;	
	cp log_service/src/*.app log_service/ebin;
	erlc -I include -o log_service/ebin log_service/src/*.erl;
#	vm_service
	git clone https://github.com/joq62/vm_service.git;	
	cp vm_service/src/*.app vm_service/ebin;
	erlc -I include -o vm_service/ebin vm_service/src/*.erl;
#	test
	mkdir ta_service;
	mkdir ta_service/ebin;
	cp test_src/*.app ta_service/ebin;
	erlc -I include -o ta_service/ebin test_src/*.erl;
	erl -pa */ebin -vm_service services log_serviceXta -s vm_service boot -sname test_agent
