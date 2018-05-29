#!/bin/sh
set -e

#Note: Before executing install 'jq'

uname="spasem"
pwd="sekhar_1212"
api_ep="https://api.cortex.insights.ai"
token_ep="/v2/admin/ascension/users/authenticate"
match_ep="/v3/actions/AS/match_exception/invoke"
ctype_json="Content-Type: application/json"
log_fname="me_script_log.txt"
token_json='{"username": "'$uname'", "password": "'$pwd'"}'
me_json='{ "payload": {"match_exception":"sekhar"}}'

get_token(){
	echo "Getting token...." | tee -a $log_fname
	local __tokenvar=$1
	local token_res; local jwt;
	token_res=$(curl -s -X POST $api_ep$token_ep -H "$ctype_json" -d "$token_json")
	eval $__tokenvar="'$token_res'"
}
invoke_me_skill(){
	echo "Invoking skill..." | tee -a $log_fname
	local token=$1;
	local __me_response=$2
	response=$(curl -s -X POST $api_ep$match_ep -H "$ctype_json" -H "authorization: Bearer $token" -d "$me_json")
	eval $__me_response="'$response'"

}
start(){
	echo "--------------------------" | tee -a $log_fname
	echo `date` | tee -a $log_fname
	#getting token
	get_token token_response
	#parsing jwt from response
	token=$(echo ${token_response} | jq -r '.jwt')

	if [[ "$token" != null ]]; then
		echo "Received token successfully..." | tee -a $log_fname
		#invoke match_exception skill
        invoke_me_skill $token me_response
        echo $me_response | tee -a $log_fname
        echo "Executed successfully..." | tee -a $log_fname
    else
    	echo "Error!" | tee -a $log_fname
        echo $token_response | tee -a $log_fname
    fi
    echo "--------------------------" | tee -a $log_fname

}
start