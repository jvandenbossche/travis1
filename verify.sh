echo ""
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "Contrast Security - Travis Build Verification"
echo "PlugIn Integration - Version 2019_08_20"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+"

CONTRAST_URL=$TRAVIS_ENV_CONTRAST_TEAMSERVERURL
CONTRAST_API_KEY=$TRAVIS_ENV_CONTRAST_APIKEY
CONTRAST_ORG_ID=$TRAVIS_ENV_CONTRAST_ORGUUID
CONTRAST_AUTH=$TRAVIS_ENV_CONTRAST_AUTH
CONTRAST_APP_ID=$TRAVIS_ENV_CONTRAST_APPID

echo "Team Server URL: $CONTRAST_URL"

# SET THRESHOLD MAXIMUMS FOR EACH VULNERABILITY SEVERITY TYPE
CONTRAST_CRITICAL_COUNT=0
CONTRAST_HIGH_COUNT=0
CONTRAST_MEDIUM_COUNT=0
CONTRAST_LOW_COUNT=0
CONTRAST_NOTE_COUNT=0

# IMPORT SETTINGS FROM "ContrastTravis.conf"

echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "IBM Travis Build Vulnerability Threshold Settings"
echo "If current open vulnerabilities exceeds thresholds, the build will be failed"
echo "Critical > $CONTRAST_CRITICAL_COUNT"
echo "High     > $CONTRAST_HIGH_COUNT"
echo "Medium   > $CONTRAST_MEDIUM_COUNT"
echo "Low      > $CONTRAST_LOW_COUNT"
echo "Note     > $CONTRAST_NOTE_COUNT"


##################################################
# Construct Contrast Security API URL and execute it

API_URL="$CONTRAST_URL/ng/$CONTRAST_ORG_ID/orgtraces/filter/severity/listing?expand=skip_links&quickFilter=OPEN&modules=$CONTRAST_APP_ID&tracked=false&untracked=false&metadataFilters=%5B%5D"

echo "CONTRAST API CALL : $API_URL"

CONTRAST_OUTPUT=$(curl -X GET "$API_URL" -H API-Key:"$CONTRAST_API_KEY" -H Authorization:"$CONTRAST_AUTH")

FAILED_REQUEST=$(echo $CONTRAST_OUTPUT | grep -Eo '[0-9]' -c)
if [ $FAILED_REQUEST -lt 1 ]
    then
        echo "FAILURE >> Unable to reach the Contrast UI. Please verify the keys and the url are correct"
        echo "FAILURE >> Exiting AND Failing Travis Build.."
        exit 1
fi


##################################################
# Capture Number Of Vulnerabilities per app

echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "Current Open Vulnerabilities for this application in Contrast Security"

# Get Critical vulnerability count
c1=$(echo "$CONTRAST_OUTPUT" | grep "Critical" -A 2)
CRIT_COUNT=$(echo "$c1" | grep -Eo '[0-9]{1,3}')
echo "Critical count: $CRIT_COUNT"
CRIT_COUNT=$CRIT_COUNT

# Get High vulnerability count
h1=$(echo "$CONTRAST_OUTPUT" | grep "High" -A 2)
HIGH_COUNT=$(echo "$h1" | grep -Eo '[0-9]{1,4}')
echo "High count: $HIGH_COUNT"

# Get Medium vulnerability count
m1=$(echo "$CONTRAST_OUTPUT" | grep "Medium" -A 2)
MED_COUNT=$(echo "$m1" | grep -Eo '[0-9]{1,4}')
echo "Medium count: $MED_COUNT"

# Get Low vulnerability count
l1=$(echo "$CONTRAST_OUTPUT" | grep "Low" -A 2)
LOW_COUNT=$(echo "$l1" | grep -Eo '[0-9]{1,4}')
echo "Low count: $LOW_COUNT"

# Get Note vulnerability count
n1=$(echo "$CONTRAST_OUTPUT" | grep "Note" -A 2)
NOTE_COUNT=$(echo "$n1" | grep -Eo '[0-9]{1,4}')
echo "Note count: $NOTE_COUNT"

##################################################
# Verify Contrast Thresholds

# Compare Critical vulnerability threshold
if (($CRIT_COUNT>$CONTRAST_CRITICAL_COUNT)); then
     echo "$CRIT_COUNT is greater than the threshold of  $CONTRAST_CRITICAL_COUNT"
     echo "Failing job because Critical vulnerability threshold was violated"
     echo "Please check the Contrast UI for the vulnerability details and how to fix them."
     echo "Refer to https://docs.contrastsecurity.com/user-vulns.html#analyze for steps to set the vulnerability status to closed (Remediated or Not a Problem)"
     exit 1
fi

# Compare High vulnerability threshold
if (($HIGH_COUNT>$CONTRAST_HIGH_COUNT)); then
    echo "$HIGH_COUNT is greater than the threshold of  $CONTRAST_HIGH_COUNT"
    echo "Failing job because High vulnerability threshold was violated"
     echo "Please check the Contrast UI for the vulnerability details and how to fix them."
     echo "Refer to https://docs.contrastsecurity.com/user-vulns.html#analyze for steps to set the vulnerability status to closed (Remediated or Not a Problem)"
     exit 1
fi

# Compare Medium vulnerability threshold
if (($MED_COUNT>$CONTRAST_MEDIUM_COUNT)); then
    echo "$MED_COUNT is greater than the threshold of  $CONTRAST_MEDIUM_COUNT"
    echo "Failing job because Medium vulnerability threshold was violated"
     echo "Please check the Contrast UI for the vulnerability details and how to fix them."
     echo "Refer to https://docs.contrastsecurity.com/user-vulns.html#analyze for steps to set the vulnerability status to closed (Remediated or Not a Problem)"
     exit 1
fi

# Compare Low vulnerability threshold
if (($LOW_COUNT>$CONTRAST_LOW_COUNT)); then
    echo "$LOW_COUNT is greater than the threshold of  $CONTRAST_LOW_COUNT"
    echo "Failing job because Low vulnerability threshold was violated"
     echo "Please check the Contrast UI for the vulnerability details and how to fix them."
     echo "Refer to https://docs.contrastsecurity.com/user-vulns.html#analyze for steps to set the vulnerability status to closed (Remediated or Not a Problem)"
     exit 1
fi

# Compare Note vulnerability threshold
if (($NOTE_COUNT>$CONTRAST_NOTE_COUNT)); then
    echo "$NOTE_COUNT is greater than the threshold of  $CONTRAST_NOTE_COUNT"
    echo "Failing job because Note vulnerability threshold was violated"
     echo "Please check the Contrast UI for the vulnerability details and how to fix them."
     echo "Refer to https://docs.contrastsecurity.com/user-vulns.html#analyze for steps to set the vulnerability status to closed (Remediated or Not a Problem)"
     exit 1
fi