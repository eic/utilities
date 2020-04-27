#!/bin/tcsh -f


if (! $?build_type) then       
  echo "build_type is undefined, use new"
  set build_type=new
else
  echo "use predefined build_type = ${build_type}"
endif

if (! $?system_config) then       
  echo "system_config is undefined, use x8664_sl7"
  set system_config=x8664_sl7
else
  echo "use predefined system_config = ${system_config}"
endif

echo source /cvmfs/sphenix.sdcc.bnl.gov/${system_config}/opt/sphenix/core/bin/sphenix_setup.csh  -n $build_type;
source /cvmfs/sphenix.sdcc.bnl.gov/${system_config}/opt/sphenix/core/bin/sphenix_setup.csh  -n $build_type;

env;

if (! -d ./test ) then
	mkdir test
endif

cd test

echo '{int ret = gSystem->Load("libg4detectors"); cout <<"Load libg4detectors = "<<ret<<endl;assert(ret == 0);exit(0);}' > test.C

root -b -q test.C

set build_ret = $?;

if ($build_ret != 0) then
	echo "======================================================="
	echo "Failed build with return = ${build_ret}.";
	echo "======================================================="
	exit $build_ret;
endif

echo "Build step - singularity test - done"
