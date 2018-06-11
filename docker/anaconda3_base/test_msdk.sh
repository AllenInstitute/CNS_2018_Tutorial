#!/bin/bash

MSDK_HOME=/home/build/modelingsdk
TESTS_HOME=${MSDK_HOME}/docs/examples/simulator

source activate modelingsdk

echo "TESTING bionet"
echo ">> testing example 1"
python ${TESTS_HOME}/bionet/example1/run_bionet.py ${TESTS_HOME}/bionet/example1/config.json
echo ">> testing example 2"
python ${TESTS_HOME}/bionet/example2/run_bionet.py ${TESTS_HOME}/bionet/example2/config.json
echo ">> bionet testing done."
echo

echo "TESTING pointnet"
echo ${INSTALL_PATH}
source /home/shared/nest/bin/nest_vars.sh
python ${TESTS_HOME}/pointnet/example1/run_pointnet.py ${TESTS_HOME}/pointnet/example1/config.json
echo ">> pointnet testing done."
echo

echo "TESTING popnet"
python ${TESTS_HOME}/popnet/example1/run_popnet.py ${TESTS_HOME}/popnet/example1/config.json
echo ">> popnet testing done."
echo

# NOTE: Due to mintnet's relience on matplotlib and PIL it can't be ran directly from a docker command
# need to work on the code base to get around issue.
# echo 
#cd ${TESTS_HOME}/mintnet/example1
#python run_mintnet.py

echo "Done Testing Modeling SDK"

