# Normal
./sslittle-na-sstrix/bin/gcc -o operation.o operation.c
./simplesim-3.0/sim-outorder -config config/config_a.cfg -ptrace config_a.trc 0:1024 -redir:sim operation.out operation.o

# Optimization O2
./sslittle-na-sstrix/bin/gcc -o operation_o2.o operation.c
./simplesim-3.0/sim-outorder -config config/config_a.cfg -ptrace config_a_o2.trc 0:1024 -redir:sim operation_o2.out operation_o2.o

# Optimization O3
./sslittle-na-sstrix/bin/gcc -o operation_o3.o operation.c
./simplesim-3.0/sim-outorder -config config/config_a.cfg -ptrace config_a_o3.trc 0:1024 -redir:sim operation_o3.out operation_o3.o
