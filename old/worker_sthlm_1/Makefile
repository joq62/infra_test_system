all:
	rm -rf include test_ebin test_src/*~ test_src/*.beam *_service *_config catalog erl_crasch.dump;
#	include
	git clone https://github.com/joq62/include.git;
#	node_config
	git clone https://github.com/joq62/node_config.git;
#	catalog
	git clone https://github.com/joq62/catalog.git;
#	log_service
	git clone https://github.com/joq62/log_service.git;	
	cp log_service/src/*.app log_service/ebin;
	erlc -I include -o log_service/ebin log_service/src/*.erl;
#	dns_service
	git clone https://github.com/joq62/dns_service.git;	
	cp dns_service/src/*.app dns_service/ebin;
	erlc -I include -o dns_service/ebin dns_service/src/*.erl;
#	boot_service
	git clone https://github.com/joq62/boot_service.git;	
	cp boot_service/src/*.app boot_service/ebin;
	erlc -I include -o boot_service/ebin boot_service/src/*.erl;
#	test_agent
	mkdir test_ebin;
	cp ../test_agent/src/*.app test_ebin;
	erlc -o test_ebin ../test_agent/src/*.erl;
	erl -pa test_ebin -pa */ebin -boot_service services dns_serviceXlog_service -s boot_service boot -sname worker_sthlm_1
