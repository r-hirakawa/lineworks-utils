#!/bin/zsh
##
# リッチメニューに画像を紐付ける
# @see https://developers.worksmobile.com/jp/docs/bot-richmenu-image-set
##

source .env
source .credential

RICHMENU_ID=xxxx
FILE_ID=xxxx

# DEFINE SET RICHMENU IMAGE
SET_RICHMENU=`cat <<EOS
{
  "fileId": "${FILE_ID}",
  "i18nFileIds": []
}
EOS`

# SET RICHMENU IMAGE
RESP=`curl \
  -s \
  -w "\n%{response_code}" \
  -X POST "https://www.worksapis.com/v1.0/bots/${BOT_ID}/richmenus/${RICHMENU_ID}/image" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${SET_RICHMENU}"`

BODY=`echo -n ${RESP} | sed "$ d"`
STATUS=`echo -n ${RESP} | tail -n 1`

# SET RICHMENU IMAGE RESULT
if [ "${STATUS}" = "204" ]; then
  echo "API: SUCCESS"
  echo "RICHMENU IMAGE LINKED"
else
  echo "API: ERROR(${STATUS})"
  echo "${BODY}"
fi
