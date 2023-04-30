TOPMODULE=tb_pe_top
FILELIST=./filelist/project.f
INCLUDE_DIR=/home/yangy/Course/EE216/FinalProject/deisgn/
Mdir=./csrc
makeDirs= mkdir -p out log csrc

vcsBaseCommand = vcs -full64 \
					-sverilog \
					+incdir+$(INCLUDE_DIR) \
					-timescale=1ns/1ns \
					-top $(TOPMODULE) \
					-Mdir=$(Mdir) \
					-kdb \
					-debug_access+all \
					+lint=all   \
					-l ./log/compile.log \
					-o ./out/simv \
					-f $(FILELIST)

compile: clean
		$(makeDirs)
		$(vcsBaseCommand)

run:
	./out/simv -l log/run.log

.PHONY: clean
clean:
	\rm -rf simv* *.log *.vpd *.dump csrc *.sim *.mra *.log ucli.key session* *.db vcs.key out/simv* tmp DVEfiles temp $(Mdir)