echo "Pipelining and Superscalar using SimpleScalar"
soo -config config/config_a.cfg -ptrace config_a.trc 0:1024 -redir:sim sim_configa.out bin.little/test-math
pv config_a.trc | less