#!/bin/zsh
##
# リッチメニューの登録
# @see https://developers.worksmobile.com/jp/docs/bot-richmenu-create
##

source .env
source .credential

# DEFINE RICHMENU
RICHMENU=`cat <<EOS
{
  "richmenuName": "EmployeeRichMenu",
  "areas": [
    {
      "bounds": {
        "x": 0,
        "y": 0,
        "width": 833,
        "height": 843
      },
      "action": {
        "type": "uri",
        "label": "${WOFF_APP_LABEL_1}",
        "uri": "${WOFF_APP_URL_1}"
      }
    },
    {
      "bounds": {
        "x": 833,
        "y": 0,
        "width": 834,
        "height": 843
      },
      "action": {
        "type": "uri",
        "label": "${WOFF_APP_LABEL_2}",
        "uri": "${WOFF_APP_URL_2}"
      }
    },
    {
      "bounds": {
        "x": 1667,
        "y": 0,
        "width": 833,
        "height": 843
      },
      "action": {
        "type": "uri",
        "label": "${WOFF_APP_LABEL_3}",
        "uri": "${WOFF_APP_URL_3}"
      }
    }
  ],
  "size": {
    "width": 2500,
    "height": 843
  }
}
EOS`

# CREATE RICHMENU
RESP=`curl \
  -s \
  -w "\n%{response_code}" \
  -X POST "https://www.worksapis.com/v1.0/bots/${BOT_ID}/richmenus" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${RICHMENU}"`

BODY=`echo -n ${RESP} | sed "$ d"`
STATUS=`echo -n ${RESP} | tail -n 1`

# CREATE RICHMENU RESULT
if [ "${STATUS}" = "201" ]; then
  echo "API: SUCCESS"
  echo "${BODY}" >> richmenus.txt
  echo "RICHMENU SAVED"
else
  echo "API: ERROR(${STATUS})"
  echo "${BODY}"
fi
