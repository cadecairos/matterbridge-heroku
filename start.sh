#!/bin/bash

###############################################################################################
# Apply some defaults values, and remove quotes that Heroku adds to truthy and numeric values #
###############################################################################################

export IRC_USE_TLS=`echo ${UseIRC_USE_TLSTLS:=true} | tr -d \"`
export IRC_USE_SASL=`echo ${IRC_USE_SASL:=true} | tr -d \"`
export IRC_SKIP_TLS_VERIFY=`echo ${IRC_SKIP_TLS_VERIFY:=false} | tr -d \"`
export MATTERMOST_NO_TLS=`echo ${MATTERMOST_NO_TLS:=false} | tr -d \"`
export MATTERMOST_SKIP_TLS_VERIFY=`echo ${MATTERMOST_SKIP_TLS_VERIFY:=false} | tr -d \"`
export MATTERMOST_SHOW_JOIN_PART=`echo ${MATTERMOST_SHOW_JOIN_PART:=false} | tr -d \"`
export MATTERMOST_PREFIX_MSG_WITH_NICK=`echo ${MATTERMOST_PREFIX_MSG_WITH_NICK:=false} | tr -d \"`
export MATTERMOST_NICKS_PER_ROW=`echo ${MATTERMOST_NICKS_PER_ROW:=4} | tr -d \"`

########################################################################
# Write Config variables in envrionment to the configuration JSON file #
########################################################################
lib/envsubst < config/config-heroku-template.toml > config/config-heroku.toml

#####################################
# Pass SIGTERM to Matterbridge proc #
#####################################
function _term {
  echo "Sending SIGTERM to matterbridge"

  kill --TERM "$PID" 2>/dev/null
}

trap _term SIGTERM

####################
# Start Matterbridge #
####################
./matterbridge -conf=config/config-heroku.toml &

PID=$!

#####################################
# Wait for this process to complete #
#####################################
wait "$PID"
