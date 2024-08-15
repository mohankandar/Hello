#!/bin/bash

#
# JWT Encoder Bash Script
# Edit the payload as needed
# The sample below assumes an external user (NOT a Common Security System user) is accessing the API
# https://willhaley.com/blog/generate-jwt-with-bash/

# Update the "secret" variable and the "iss" portion of the "payload" variable json will the real issuer value

#Testing token with curl and reference person:
#curl -X GET "https://<environment host name>/api/v1/persons/bogus" -H "accept: application/json" -H "Authorization: Bearer <token value from this script>"
#curl -X GET "https://<environment host name>/api/v1/persons/bogus" -H "accept: application/json" -H "Authorization: Bearer <token value from this script>"
# Should return a 404 or 200; otherwise may be any issue (pod may need a restart to pick up a new vault config)

# this value is stored in Vault (defaults to "secret" if not specified)
secret='<replace-with-generated-secret>'

# Static header fields.
header='{
	"alg": "HS256",
	"typ": "JWT"
}'

# Use jq to set the dynamic `iat` and `exp`
# fields on the header using the current time.
# `iat` is set to now, and `exp` is now + 900 second.
header=$(
	echo "${header}" | jq --arg time_str "$(date +%s)" \
	'
	($time_str | tonumber) as $time_num
	| .iat=$time_num
	| .exp=($time_num + 900)
	'
)
#Issuer defaults to "Vets.gov" if not specified in vault
payload='{
	"iss": "<replace-with-issuer>",
	"jti": "d3cf8355-7263-4c86-b413-1f476f54253b",
        "lastName": "DOE",
  "gender": "FEMALE",
  "appToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9",
  "prefix": "Ms",
  "assuranceLevel": 2,
  "suffix": "S",
  "birthDate": "2000-01-23",
  "userID": "vhaislXXXXX",
  "firstName": "JANE",
  "correlationIds": [
    "77779102^NI^200M^USVHA^P",
    "912444689^PI^200BRLS^USVBA^A",
    "6666345^PI^200CORP^USVBA^A",
    "1105051936^NI^200DOD^USDOD^A",
    "912444689^SS"
  ],
  "middleName": "M",
  "applicationID": "ShareUI",
  "email": "jane.doe@va.gov",
  "stationID": "310"
}'

base64_encode()
{
	declare input=${1:-$(</dev/stdin)}
	# Use `tr` to URL encode the output from base64.
	printf '%s' "${input}" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}

json() {
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | jq -c .
}

hmacsha256_sign()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl dgst -binary -sha256 -hmac "${secret}"
}

echo "${header}"

header_base64=$(echo "${header}" | json | base64_encode)
payload_base64=$(echo "${payload}" | json | base64_encode)

header_payload=$(echo "${header_base64}.${payload_base64}")
signature=$(echo "${header_payload}" | hmacsha256_sign | base64_encode)

echo "${header_payload}.${signature}"
