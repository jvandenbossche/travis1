echo "SCRIPT EXECUTION IS WORKING"
CONTRAST_USERNAME=sourabh.katti@contrastsecurity.com
CONTRAST_URL=https://apptwo.contrastsecurity.com/Contrast
CONTRAST_SERVICE_KEY=ZAXHB4LTKMH25NQ1
CONTRAST_API_KEY=KpAoBf7Plj71LFl4ihODRX8CgFh8hyO8
CONTRAST_ORG_ID=f7ea7169-d4eb-42c4-b32e-5c0ea0ca9733
CONTRAST_AUTH=c291cmFiaC5rYXR0aUBjb250cmFzdHNlY3VyaXR5LmNvbTpaQVhIQjRMVEtNSDI1TlEx

CONTRAST_APP_ID=1b2d676a-3357-4ab5-ac68-fffc5006426f


API_URL="$CONTRAST_URL/api/ng/$CONTRAST_ORG_ID/orgtraces/filter/severity/listing?expand=skip_links&quickFilter=OPEN&modules=$CONTRAST_APP_ID&tracked=false&untracked=false"

echo $API_URL

curl -X GET "$API_URL" -H API-Key:"$CONTRAST_API_KEY" -H Authorization:"$CONTRAST_AUTH"

# curl -X GET -H 'API-Key: KpAoBf7Plj71LFl4ihODRX8CgFh8hyO8' -H 'Authorization: c291cmFiaC5rYXR0aUBjb250cmFzdHNlY3VyaXR5LmNvbTpaQVhIQjRMVEtNSDI1TlEx' $API_URL