#!/bin/zsh
##
# リッチメニュー画像のアップロード
# @see https://developers.worksmobile.com/jp/docs/bot-attachment-create
# @see https://developers.worksmobile.com/jp/docs/file-upload
##

source .env
source .credential

RICHMENU_IMAGE=richmenu.png

# DEFINE ATTACHMENT
ATTACHMENT=`cat <<EOS
{
  "fileName": "${RICHMENU_IMAGE}"
}
EOS`

# CREATE ATTACHMENT
RESP=`curl \
  -s \
  -w "\n%{response_code}" \
  -X POST "https://www.worksapis.com/v1.0/bots/${BOT_ID}/attachments" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${ATTACHMENT}"`

BODY=`echo -n ${RESP} | sed "$ d"`
STATUS=`echo -n ${RESP} | tail -n 1`

# CREATE ATTACHMENT RESULT
if [ "${STATUS}" = "200" ]; then
  echo "API: SUCCESS"
else
  echo "API: ERROR(${STATUS})"
  echo "${BODY}"
  exit 1
fi

FILE_ID=`echo -n ${BODY} | jq -r '.fileId'`
UPLOAD_URL=`echo -n ${BODY} | jq -r '.uploadUrl'`

# UPLOAD RICHMENU IMAGE
RESP=`curl \
  -s \
  -w "\n%{response_code}" \
  -X POST "${UPLOAD_URL}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: multipart/form-data" \
  -F "resourceName=${RICHMENU_IMAGE}" \
  -F "FileData=@${RICHMENU_IMAGE}"`

BODY=`echo -n ${RESP} | sed "$ d"`
STATUS=`echo -n ${RESP} | tail -n 1`

# UPLOAD RICHMENU IMAGE RESULT
##
# [WORKAROUND]
#   公式ドキュメントの Response Example では '201 Created' が返却されると記載されているが、実際は '200 OK' が返却される
#   @see https://developers.worksmobile.com/jp/docs/file-upload#file-content-upload
##
if [ "${STATUS}" = "200" ]; then
  echo "API: SUCCESS"
  echo "${BODY}" >> uploaded.txt
  echo "UPLOAD RESULT SAVED"
else
  echo "API: ERROR(${STATUS})"
  echo "${BODY}"
fi
