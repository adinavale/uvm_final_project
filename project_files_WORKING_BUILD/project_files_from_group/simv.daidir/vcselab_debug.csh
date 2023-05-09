#!/bin/csh -f

cd /home/016648840@SJSUAD.SJSU.EDU/EE273_01/risc_v/project_files

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/apps/synopsys/VCS_current/vcs/R-2020.12/linux/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

