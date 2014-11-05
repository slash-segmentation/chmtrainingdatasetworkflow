#!/usr/bin/env bats

setup() {
  WF="${BATS_TEST_DIRNAME}/../src/chmtrainingdataset.kar"
  KEPLER_SH="kepler.sh"
  WORKFLOW_FAILED_TXT="WORKFLOW.FAILED.txt"
  README_TXT="README.txt"
  WORKFLOW_STATUS="workflow.status"
  export THE_TMP="${BATS_TMPDIR}/"`uuidgen`
  /bin/mkdir -p $THE_TMP
  /bin/cp -a "${BATS_TEST_DIRNAME}/bin" "${THE_TMP}/."
  /bin/rm -rf ~/.kepler
}

teardown() {
  #echo "Removing $THE_TMP" 1>&2
  /bin/rm -rf $THE_TMP
}

#
# Verify $KEPLER_SH is in path if not skip whatever test we are in
#
skipIfKeplerNotInPath() {

  # verify $KEPLER_SH is in path if not skip this test
  run which $KEPLER_SH

  if [ "$status" -eq 1 ] ; then
    skip "$KEPLER_SH is not in path"
  fi

}

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
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "# Seconds since"* ]]
  [[ "${lines[1]}" == "time="* ]]
  [[ "${lines[3]}" == "phase=Examining"* ]]
  [[ "${lines[4]}" == "phase.help=In this phase"* ]]
  [[ "${lines[8]}" == "phase.list=Examining"* ]]
  
}

#
# Test 
#
@test "No labels/ subdirectory in path error" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/images"

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
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "${lines[0]}" == "simple.error.message=No labels directory found in WorkspaceFile" ]
  [ "${lines[1]}" == "detailed.error.message=$THE_TMP/labels directory does not exist" ]

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
  [[ "${lines[4]}" == "phase.help=In this phase"* ]]
  [[ "${lines[8]}" == "phase.list=Examining"* ]]

}

#
# Test 
#
@test "No png files in images/ subdirectory in path error" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/images"
  mkdir -p "$THE_TMP/labels"

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
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "${lines[0]}" == "simple.error.message=No png files in images/ directory" ]
  [ "${lines[1]}" == "detailed.error.message=$THE_TMP/images contains no png files" ]

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
  [[ "${lines[4]}" == "phase.help=In this phase"* ]]
  [[ "${lines[8]}" == "phase.list=Examining"* ]]

}


#
# Test 
#
@test "1 png file in images/ and 0 in labels/" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/images"
  mkdir -p "$THE_TMP/labels"

  echo "hi" > "$THE_TMP/images/1.png"

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
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "${lines[0]}" == "simple.error.message=Number of png files in images/ and labels/ differs" ]
  [ "${lines[1]}" == "detailed.error.message=Found 0 png files in labels/ and 1 files in images/" ]

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
  [[ "${lines[4]}" == "phase.help=In this phase"* ]]
  [[ "${lines[8]}" == "phase.list=Examining"* ]]

}

#
# Test 
#
@test "3 png file in images/ and 2 in labels/" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/images"
  mkdir -p "$THE_TMP/labels"

  echo "hi" > "$THE_TMP/images/1.png"
  echo "hi" > "$THE_TMP/images/2.png"
  echo "hi" > "$THE_TMP/images/3.png"

  echo "hi" > "$THE_TMP/labels/1.png"
  echo "hi" > "$THE_TMP/labels/2.png"

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
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "${lines[0]}" == "simple.error.message=Number of png files in images/ and labels/ differs" ]
  [ "${lines[1]}" == "detailed.error.message=Found 2 png files in labels/ and 3 files in images/" ]

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
  [[ "${lines[4]}" == "phase.help=In this phase"* ]]
  [[ "${lines[8]}" == "phase.list=Examining"* ]]

}

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
  [[ "${lines[4]}" == "phase.help=In this phase"* ]]
  [[ "${lines[8]}" == "phase.list=Examining"* ]]

}
 
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
  [[ "${lines[1]}" == "detailed.error.message=Error running identify : "* ]]

}

#
#
#
@test "one or more files is not 8 bit depth" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/images"
  mkdir -p "$THE_TMP/labels"

  echo "hi" > "$THE_TMP/images/1.png"
  echo "hi" > "$THE_TMP/images/2.png"

  echo "hi" > "$THE_TMP/labels/1.png"
  echo "hi" > "$THE_TMP/labels/2.png"

  echo "0,images/001.png PNG 500x500 17387x17422+7934+7350 8-bit PseudoClass 256c 203kb\\nimages/002.png[1] PNG 500x500 17387x17422+10764+13750 8-bit PseudoClass 256c 200kb\\nlabels/001.png[2] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.09kb\\nlabels/002.png[3] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.34kb,," > "$THE_TMP/bin/command.tasks"

  echo "0,images/001.png PNG 500x500 17387x17422+7934+7350 8-bit PseudoClass 256c 203kb\\nimages/002.png[1] PNG 500x500 17387x17422+10764+13750 8-bit PseudoClass 256c 200kb\\nlabels/001.png[2] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.09kb\\nlabels/002.png[3] PNG 500x500 500x500+0+0 7-bit PseudoClass 256c 3.34kb,," >> "$THE_TMP/bin/command.tasks"

  # Run kepler.sh with no other arguments
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -identifyCmd "$THE_TMP/bin/command" -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -inputPathRaw "$THE_TMP" -CWS_outputdir $THE_TMP $WF


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
  [ "${lines[0]}" == "simple.error.message=One or more images are not 8bit" ]
  [[ "${lines[1]}" == "detailed.error.message=Error running identify : "* ]]

}

