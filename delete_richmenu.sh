#!/bin/zsh
##
# リッチメニューの削除
# @see https://developers.worksmobile.com/jp/docs/bot-richmenu-delete
##

source .env
source .credential

RICHMENU_ID=xxxx

# DELETE RICHMENU
RESP=`curl \
  -s \
  -w "\n%{response_code}" \
  -X DELETE "https://www.worksapis.com/v1.0/bots/${BOT_ID}/richmenus/${RICHMENU_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}"`

BODY=`echo -n ${RESP} | sed "$ d"`
STATUS=`echo -n ${RESP} | tail -n 1`

# DELETE RICHMENU RESULT
if [ "${STATUS}" = "204" ]; then
  echo "API: SUCCESS"
  echo "${BODY}"
else
  echo "API: ERROR(${STATUS})"
  echo "${BODY}"
fi
