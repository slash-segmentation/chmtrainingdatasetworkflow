#!/usr/bin/env bats

load test_helper

#
#
#
@test "copy of data fail" {
  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/fakewf/images"
  mkdir -p "$THE_TMP/fakewf/labels"

  echo "hi" > "$THE_TMP/fakewf/images/1.png"
  echo "hi" > "$THE_TMP/fakewf/images/2.png"

  echo "hi" > "$THE_TMP/fakewf/labels/1.png"
  echo "hi" > "$THE_TMP/fakewf/labels/2.png"

  echo "0,,," > "$THE_TMP/bin/command.tasks"

  echo "0,images/001.png PNG 500x500 17387x17422+7934+7350 8-bit PseudoClass 256c 203kb\\nimages/002.png[1] PNG 500x500 17387x17422+10764+13750 8-bit PseudoClass 256c 200kb\\nlabels/001.png[2] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.09kb\\nlabels/002.png[3] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.34kb,," >> "$THE_TMP/bin/command.tasks"

  echo "0,images/001.png PNG 500x500 17387x17422+7934+7350 8-bit PseudoClass 256c 203kb\\nimages/002.png[1] PNG 500x500 17387x17422+10764+13750 8-bit PseudoClass 256c 200kb\\nlabels/001.png[2] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.09kb\\nlabels/002.png[3] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.34kb,," >> "$THE_TMP/bin/command.tasks"

  echo "0,images/001.png PNG 500x500 17387x17422+7934+7350 8-bit PseudoClass 256c 203kb\\nimages/002.png[1] PNG 500x500 17387x17422+10764+13750 8-bit PseudoClass 256c 200kb\\nlabels/001.png[2] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.09kb\\nlabels/002.png[3] PNG 500x500 500x500+0+0 8-bit PseudoClass 256c 3.34kb,," >> "$THE_TMP/bin/command.tasks"

  echo "1,stdout,error," >> "$THE_TMP/bin/command.tasks"

  # Run kepler.sh with no other arguments
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -identifyCmd "$THE_TMP/bin/command" -cpCmd "$THE_TMP/bin/command" -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -inputPathRaw "$THE_TMP/fakewf" -CWS_outputdir $THE_TMP $WF


  # Check exit code
  [ "$status" -eq 0 ]

  # Check output from kepler.sh
  [[ "${lines[0]}" == "The base dir is"* ]]

  echo "Output from kepler.  Should only see this if something below fails ${lines[@]}"
  echo ""

  # Verify we got a workflow failed txt file
  [ -s "$THE_TMP/$WORKFLOW_FAILED_TXT" ]

  # Check output of workflow failed txt file
  run cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "$status" -eq 0 ]
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "${lines[0]}" == "simple.error.message=Error copying data" ]
  [ "${lines[1]}" == "detailed.error.message=Error running $THE_TMP/bin/command $THE_TMP/fakewf $THE_TMP/data : error" ]

  run cat "$THE_TMP/$WORKFLOW_STATUS"

  [ "$status" -eq 0 ]
  cat "$THE_TMP/$WORKFLOW_STATUS"
  [ "${lines[3]}" == "phase=Examining data" ]
  [ "${lines[6]}" == "phase.list=Examining data,Copying data,Done" ]


}

