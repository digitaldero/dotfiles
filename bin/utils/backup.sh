#!/usr/bin/env bash

# TODO: read variable names from config file in htdocs/backup
#if [ $# -eq 0 ]; then
#  echo "Usage: $(basename $0) htdocs_parent mysql_database msmtp_account gdrive_parent_id"
#  exit 1
#fi
#echo $1 $2 $3

day=$(date -d "1 day ago" +%A)
mail_to="chrisherberte@gmail.com"
mail_body=""
mail_subject="Backup Completed for ${day}"
site_shortname="test" # must be the same as msmtp account name
mysql_database="test_backup"
htdocs_parent="/var/www/backup.dev.xweb.com.au"
htdocs_gz="${day}_${site_shortname}_htdocs.tar.gz"
sqldmp_gz="${day}_${site_shortname}.sql.gz"
gdrive_folder="1yKKLrnNB1fJASdKq471xfx2rqOlpKphB"

tar zcf "${htdocs_parent}/backup/${htdocs_gz}" "${htdocs_parent}/htdocs/"
#mysqldump "${mysql_database} -udrupal -pdrup41" | gzip >"${htdocs_parent}/backup/${sqldmp_gz}"
mysqldump ${mysql_database} -udrupal -pdrup41 | gzip >"${htdocs_parent}/backup/${sqldmp_gz}"

htdocs_id="$(drive list --noheader --max 1 --title ${htdocs_gz} | awk '{print $1}')"
sqldmp_id="$(drive list --noheader --max 1 --title ${sqldmp_gz} | awk '{print $1}')"

if [ -n "${htdocs_id}" ]; then
  drive delete --id ${htdocs_id}
fi

if [ -n "${sqldmp_id}" ]; then
  drive delete --id ${sqldmp_id}
fi

echo -e "Subject: ${mail_subject}\n" >${htdocs_parent}/backup/mail.txt
drive upload -f "${htdocs_parent}/backup/${htdocs_gz}" -p ${gdrive_folder} >>${htdocs_parent}/backup/mail.txt
drive upload -f "${htdocs_parent}/backup/${sqldmp_gz}" -p ${gdrive_folder} >>${htdocs_parent}/backup/mail.txt
cat "${htdocs_parent}/backup/mail.txt" | msmtp ${mail_to} -a ${site_shortname}

#gitlab copy
#git add . -A
#git commit -am "Backup `date`"
#git push origin master
