#!/usr/bin/env bats

load test_helper
 
#
#
#
@test "one or more files are not png files" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/images"
  mkdir -p "$THE_TMP/labels"

  echo "hi" > "$THE_TMP/images/1.png"
  echo "hi" > "$THE_TMP/images/2.png"

  echo "hi" > "$THE_TMP/labels/1.png"
  echo "hi" > "$THE_TMP/labels/2.png"

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
  [ "${lines[0]}" == "simple.error.message=One or more images do not have dimension of 500x500" ]
  echo ":${lines[1]}:"
  [[ "${lines[1]}" == "detailed.error.message=identify returned these dimensions :  and this for error : identify: Improper"* ]]

}

