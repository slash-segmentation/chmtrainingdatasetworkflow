#!/usr/bin/env bats

load test_helper

#
#
#
@test "names of png files dont match" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/images"
  mkdir -p "$THE_TMP/labels"

  echo "hi" > "$THE_TMP/images/1.png"
  echo "hi" > "$THE_TMP/images/2.png"

  echo "hi" > "$THE_TMP/labels/1.png"
  echo "hi" > "$THE_TMP/labels/3.png"

  # Run kepler.sh with no other arguments
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -inputPathRaw "$THE_TMP" -CWS_outputdir $THE_TMP $WF


  # Check exit code
  [ "$status" -eq 0 ]

  # Check output from kepler.sh
  [[ "${lines[0]}" == "The base dir is"* ]]

  echo "Output from kepler.  Should only see this if something below fails ${lines[@]}"


  cat "$THE_TMP/$README_TXT"
  # Verify we got a workflow failed txt file
  [ -s "$THE_TMP/$WORKFLOW_FAILED_TXT" ]

  # Check output of workflow failed txt file
  run cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "$status" -eq 0 ]
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "${lines[0]}" == "simple.error.message=File names do not match between images/ and labels/ directories" ]
  [ "${lines[1]}" == "detailed.error.message=Unique filename count 3 differs from number of png files in labels/ directory 2" ]

  # Check output of README.txt file
  [ -s "$THE_TMP/$README_TXT" ]
  run cat "$THE_TMP/$README_TXT"
  [ "$status" -eq 0 ]
  [ "${lines[5]}" == "Path: $THE_TMP" ]

  # Check output of workflow.status file
  [ -s "$THE_TMP/$WORKFLOW_STATUS" ]
  run cat "$THE_TMP/$WORKFLOW_STATUS"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "# Seconds since"* ]]
  [[ "${lines[1]}" == "time="* ]]
  [[ "${lines[3]}" == "phase=Examining"* ]]

}
 
