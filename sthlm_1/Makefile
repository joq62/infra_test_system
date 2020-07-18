all:
	rm -rf include configs *_service  erl_crasch.dump;
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
	erl -pa */ebin -vm_service services log_service -s vm_service boot -sname sthlm_1
