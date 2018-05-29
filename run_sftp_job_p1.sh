#!/bin/bash
DIR=/out
java -cp scripts/hive-connector-prod-jar-with-dependencies.jar SaveInsightsToFile
ls -lath /out
gpg --yes --always-trust -r schenks@AscensionHealth.org --encrypt $DIR/output_csinsights_results.txt
sftp ubuntu@52.90.36.76:/var/sftp/uploads <<< $'put /out/output_csinsights_results.txt.gpg'
date
date >> $DIR/time_sftp.txt