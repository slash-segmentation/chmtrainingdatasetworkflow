#!/usr/bin/env bats

load test_helper

#
# Test 
#
@test "No images/ or images/data path error" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath
  # Run kepler.sh with no other arguments
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -inputPathRaw "$THE_TMP" -CWS_outputdir $THE_TMP $WF

  # Check exit code
  [ "$status" -eq 0 ]

  # Check output from kepler.sh
  [[ "${lines[0]}" == "The base dir is"* ]]

  echo "Output from kepler.  Should only see this if something below fails ${lines[@]}"

  # Verify we got a workflow failed txt file
  [ -s "$THE_TMP/$WORKFLOW_FAILED_TXT" ] 

  # Check output of workflow failed txt file
  run cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "$status" -eq 0 ] 
  [ "${lines[0]}" == "simple.error.message=No images directory found in WorkspaceFile" ] 
  [ "${lines[1]}" == "detailed.error.message=Neither $THE_TMP/images or $THE_TMP/data/images exists" ]

  # Check output of README.txt file
  [ -s "$THE_TMP/$README_TXT" ]
  run cat "$THE_TMP/$README_TXT"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "CHM training dataset" ]
  [ "${lines[1]}" == "Job Name: jname" ]
  [ "${lines[2]}" == "User: joe" ] 
  [ "${lines[3]}" == "Workflow Job Id: 123" ]
  [ "${lines[5]}" == "Path: $THE_TMP" ]

  # Check output of workflow.status file
  [ -s "$THE_TMP/$WORKFLOW_STATUS" ]
  run cat "$THE_TMP/$WORKFLOW_STATUS"
  cat "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "# Seconds since"* ]]
  [[ "${lines[1]}" == "time="* ]]
  [[ "${lines[3]}" == "phase=Examining"* ]]
  [[ "${lines[4]}" == "phase.help=In this phase"* ]]
  [[ "${lines[6]}" == "phase.list=Examining"* ]]
  
}

#
