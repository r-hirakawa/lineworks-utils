#!/bin/zsh
##
# アクセストークンを生成する
# @see https://developers.worksmobile.com/jp/docs/auth-jwt#generate-jwt
##

source .env

# CREATE HEADER
HEADER=`cat <<EOS
{
  "alg": "RS256",
  "typ": "JWT"
}
EOS`

# CREATE PAYLOAD
IAT=`date +%s`
EXP=`date -v+1H +%s`
PAYLOAD=`cat <<EOS
{
  "iss": "${CLIENT_ID}",
  "sub": "${SERVICE_ACCOUNT_ID}",
  "iat": ${IAT},
  "exp": ${EXP}
}
EOS`

# CREATE SIGNATURE
TARGET=`echo -n "${HEADER}" | base64`.`echo -n "${PAYLOAD}" | base64`
SIGNATURE=`echo -n ${TARGET} | openssl dgst -sha256 -sign private.key -binary | base64 | sed s/\+/-/g | sed 's/\//_/g' | sed -E s/=+$//`

ASSERTION="${TARGET}.${SIGNATURE}"

# ISSUE ACCESS TOKEN
RESP=`curl \
  -s \
  -w "\n%{response_code}" \
  -X POST "https://auth.worksmobile.com/oauth2/v2.0/token" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "assertion=${ASSERTION}" \
  --data-urlencode "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer" \
  --data-urlencode "client_id=${CLIENT_ID}" \
  --data-urlencode "client_secret=${CLIENT_SECRET}" \
  --data-urlencode "scope=bot"`

BODY=`echo -n ${RESP} | sed "$ d"`
STATUS=`echo -n ${RESP} | tail -n 1`

# ISSUE ACCESS TOKEN RESULT
if [ "${STATUS}" = "200" ]; then
  echo "API: SUCCESS"
  CREDENTIAL=`cat <<EOS
export ACCESS_TOKEN="$(echo -n ${BODY} | jq -r '.access_token')"
export REFRESH_TOKEN="$(echo -n ${BODY} | jq -r '.refresh_token')"
EOS`
  # SAVE CREDENTIAL
  echo "${CREDENTIAL}" > .credential
  echo "ACCESS TOKEN SAVED"
else
  echo "API: ERROR(${STATUS})"
  echo "${BODY}"
fi
