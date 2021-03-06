#!/bin/bash

function controller_call {
  debug "Calling $CONFIG_CONTROLLER_HOST"
  local METHOD="GET"
  while getopts "X:d:" opt "$@";
  do
    case "${opt}" in
      X)
	METHOD=${OPTARG}
      ;;
      d)
        PAYLOAD=${OPTARG}
      ;;
    esac
  done

  shiftOptInd
  shift $SHIFTS

  ENDPOINT=$*

  controller_login
  # Debug the COMMAND_RESULT from controller_login
  debug $COMMAND_RESULT
  if [ $CONTROLLER_LOGIN_STATUS -eq 1 ]; then
    COMMAND_RESULT=$(httpClient -s -b $CONFIG_CONTROLLER_COOKIE_LOCATION \
          -X $METHOD\
          -H "X-CSRF-TOKEN: $XCSRFTOKEN" \
          -H "Content-Type: application/json;charset=UTF-8" \
          -H "Accept: application/json, text/plain, */*"\
          -d "$PAYLOAD" \
          $CONFIG_CONTROLLER_HOST$ENDPOINT)
   else
     COMMAND_RESULT="Controller Login Error! Please check hostname and credentials"
   fi
}

register controller_call Send a custom HTTP call to a controller
describe controller_call << EOF
Send a custom HTTP call to an AppDynamics controller. Provide the endpoint you want to call as parameter:\n

$0 controller call /controller/restui/health_rules/getHealthRuleCurrentEvaluationStatus/app/41/healthRuleID/233\n

You can modify the http method with option -X and add payload with option -d.
EOF
