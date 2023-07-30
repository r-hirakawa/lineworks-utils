#!/bin/zsh
##
# リッチメニューリストの取得
# @see https://developers.worksmobile.com/jp/docs/bot-richmenu-list
##

source .env
source .credential

# GET RICHMENU LIST
RESP=`curl \
  -s \
  -w "\n%{response_code}" \
  -X GET "https://www.worksapis.com/v1.0/bots/${BOT_ID}/richmenus" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}"`

BODY=`echo -n ${RESP} | sed "$ d"`
STATUS=`echo -n ${RESP} | tail -n 1`

# GET RICHMENU LIST RESULT
if [ "${STATUS}" = "200" ]; then
  echo "API: SUCCESS"
  echo "${BODY}"
else
  echo "API: ERROR(${STATUS})"
  echo "${BODY}"
fi
