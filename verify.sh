echo "Contrast Verify Step"

API_URL="$CONTRAST_URL/api/ng/$CONTRAST_ORG_ID/orgtraces/filter/severity/listing?expand=skip_links&quickFilter=OPEN&modules=$CONTRAST_APP_ID&tracked=false&untracked=false"

var="$(CONTRAST_OUTPUT=curl -X GET "$API_URL" -H API-Key:"$CONTRAST_API_KEY" -H Authorization:"$CONTRAST_AUTH" 2>/dev/null)"
<<<"$var" CONTRAST_OUTPUT -F'"'

echo $CONTRAST_OUTPUT