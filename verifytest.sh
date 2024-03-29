echo ""
echo "-------------- JV -----------"
echo "Contrast - Travis Build Verify Step"
echo "Contrast Server"
echo $CONTRAST_MAVEN_USERNAME
echo $CONTRAST_MAVEN_APIKEY
echo $CONTRAST_MAVEN_SERVICEKEY
echo $CONTRAST_MAVEN_TEAMSERVERURL
echo $CONTRAST_MAVEN_ORGUUID
echo $CONTRAST_MAVEN_APPID
echo $CONTRAST_MAVEN_AUTH

CONTRAST_URL="http://ec2-3-14-248-29.us-east-2.compute.amazonaws.com:8080/Contrast/api"
CONTRAST_API_KEY="agY87ph58xxxxxxQVuXU4lmTVq"
CONTRAST_ORG_ID="7f887276-c2efxxxxxaedd547fdbb"
CONTRAST_SERVICE_KEY="L7WNxxxxHRA6I"
CONTRAST_AUTH="amFtZXMudmFuZGVuYm9zc2NoZxxxxxxx0TDdXTk5HQkc1MkhSQTZJ"
CONTRAST_APP_ID="00f1339a-b3e8-4b0f-943b-4b792d531cf0"

# SET THRESHOLD MAXIMUMS FOR EACH VULNERABILITY SEVERITY
CONTRAST_CRITICAL_COUNT=1
CONTRAST_MEDIUM_COUNT=1
CONTRAST_HIGH_COUNT=1
CONTRAST_LOW_COUNT=1
CONTRAST_NOTE_COUNT=1

API_URL="$CONTRAST_URL/ng/$CONTRAST_ORG_ID/orgtraces/filter/severity/listing?expand=skip_links&quickFilter=OPEN&modules=$CONTRAST_APP_ID&tracked=false&untracked=false&metadataFilters=%5B%5D"

echo "CONTRAST API - BASE URL"
echo $API_URL

CONTRAST_OUTPUT=$(curl -X GET "$API_URL" -H API-Key:"$CONTRAST_API_KEY" -H Authorization:"$CONTRAST_AUTH")

echo "CONTRAST API - RESPONSE"
echo $CONTRAST_OUTPUT

FAILED_REQUEST=$(echo $CONTRAST_OUTPUT | grep -Eo '[0-9]' -c)

if [ $FAILED_REQUEST -lt 1 ]
    then
        echo "Error: Unable to reach the Contrast UI. Please verify the keys and the url are correct"
        echo "Exiting AND Failing job.."
        exit 1
fi


##################################################
##################################################
# Capture Number Of Vulnerabilities per app

echo "Contrast Security found the following severities in this application:\n"

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