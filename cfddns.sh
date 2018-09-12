#!/bin/bash


### Define functions

function scriptHelp {
echo -e "\e[1;31mInvalid parameter(s) provided\e[0m"
echo -e "\e[1;39mUsage: \e[1;36m$(basename ${0})" \
    "\e[1;35m-f path/to/account/details.file" \
    "\e[1;33m-r record.to.update\e[0m" \
    "\e[1;33m[-r another.record.to.update]\e[0m\n"
echo -e "\e[1;39mExample: \e[1;36m$(basename ${0})" \
    "\e[1;35m-f /home/janedoe/myCloudFlareDetails.info" \
    "\e[1;33m-r server.mydomain.com\e[0m"
echo -e "\e[1;39mExample: \e[1;36m$(basename ${0})" \
    "\e[1;35m-f /home/janedoe/myCloudFlareDetails.info" \
    "\e[1;33m-r server.mydomain.com\e[0m" \
    "\e[1;33m-r server2.mydomain.com\e[0m"
exit 1
}

### end of functions


### unset environment variables used in this script and initialize arrays
unset PARAMS
unset accountFile
dnsRecords=()
cfDetails=()


### Process script parameters
if [ -z $1 ]; then
    scriptHelp
fi
while getopts ':f:r:' PARAMS; do
    case "$PARAMS" in
        f)
            accountFile="${OPTARG}"
            ;;
        r)
            dnsRecords+=($OPTARG)
            ;;
        ?)
            scriptHelp            
            ;;
    esac
done

# Check validity of parameters
if [ -z "$accountFile" ] || [[ $accountFile == -* ]]; then
    echo -e "\e[1;31mNo file containing account details was specified."
    echo -e "\e[0;31m(-f parameter empty or missing)\e[0m"
    exit 101
elif [ ! -s "$accountFile" ]; then
    echo -e "\e[1;31mAccount details file is either empty or does not" \
        "exist.\e[0m"
    exit 102
elif [ -z ${dnsRecords} ]; then
    echo -e "\e[1;31mNo DNS records were specified."
    echo -e "\e[0;31m(-r parameter(s) empty or missing)\e[0m"
    exit 103
fi


## Extract needed information from accountDetails file
mapfile -t cfDetails < "$accountFile"


### Echo results (testing)
echo -e "\nBased on parameters provided:"
echo -e "\e[0;35mLogin details at: ${accountFile}"
echo -e "\tAuthorized email: ${cfDetails[0]}"
echo -e "\tAuthorized key: ${cfDetails[1]}"
echo -e "\tZone identifier: ${cfDetails[2]}"
echo -e "\e[0;33mUpdating records: ${dnsRecords[*]}\e[0m\n"

exit 0
