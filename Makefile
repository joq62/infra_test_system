all:
	rm -rf include configs test_src/*.beam test_ebin/* *_service  erl_crasch.dump *~ */*~;
#	sthlm_1
	rm -rf sthlm_1/include sthlm_1/configs sthlm_1/*_service  sthlm_1/erl_crasch.dump;
#	sthlm_2
	rm -rf sthlm_2/include sthlm_2/configs sthlm_2/*_service  sthlm_2/erl_crasch.dump;
test:
	rm -rf include configs test_src/*.beam test_ebin/* *_service  erl_crasch.dump;
#	include
	git clone https://github.com/joq62/include.git;
#	configs
	cp -r test_src/configs .;
#	log_service
	git clone https://github.com/joq62/log_service.git;	
	cp log_service/src/*.app log_service/ebin;
	erlc -I include -o log_service/ebin log_service/src/*.erl;
#	orchistrate_service
	git clone https://github.com/joq62/orchistrate_service.git;	
	cp orchistrate_service/src/*.app orchistrate_service/ebin;
	erlc -I include -o orchistrate_service/ebin orchistrate_service/src/*.erl;
#	config_service
	git clone https://github.com/joq62/config_service.git;	
	cp config_service/src/*.app config_service/ebin;
	erlc -I include -o config_service/ebin config_service/src/*.erl;
#	sd_service
	git clone https://github.com/joq62/service_discovery_service.git;	
	cp service_discovery_service/src/*.app service_discovery_service/ebin;
	erlc -I include -o service_discovery_service/ebin service_discovery_service/src/*.erl;
#	vm_service
	git clone https://github.com/joq62/vm_service.git;	
	cp vm_service/src/*.app vm_service/ebin;
	erlc -I include -o vm_service/ebin vm_service/src/*.erl;
#	test
	cp -r test_src/test_service .;
	cp test_service/src/*.app test_service/ebin;
	erlc -I include -o test_service/ebin test_service/src/*.erl;
	erl -config test.config -pa */ebin -s vm_service boot -sname test_service
