#!/bin/zsh
##
# 作成したリッチメニューを Bot の既定値に設定
# @see https://developers.worksmobile.com/jp/docs/bot-update-patch
##

source .env
source .credential

RICHMENU_ID=xxxx

# DEFINE DEFAULT RICHMENU
DEFAULT_RICHMENU=`cat <<EOS
{
  "defaultRichmenuId": "${RICHMENU_ID}"
}
EOS`

# SET DEFAULT RICHMENU
RESP=`curl \
  -s \
  -w "\n%{response_code}" \
  -X PATCH "https://www.worksapis.com/v1.0/bots/${BOT_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${DEFAULT_RICHMENU}"`

BODY=`echo -n ${RESP} | sed "$ d"`
STATUS=`echo -n ${RESP} | tail -n 1`

# SET DEFAULT RICHMENU RESULT
if [ "${STATUS}" = "200" ]; then
  echo "API: SUCCESS"
  echo "SET DEFAULT RICHMENU"
  echo "${BODY}"
else
  echo "API: ERROR(${STATUS})"
  echo "${BODY}"
fi
