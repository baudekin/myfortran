FCOM=gfortran

EXE=hello


hello : hello.o
	$(FCOM) hello.o -o hello

hello.o : hello.f90
	$(FCOM) -c hello.f90

clean : 
	rm hello hello.o

all :
	make clean
	make hello
