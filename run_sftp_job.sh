#!/bin/bash
DIR=/out
filename=StageEDLMatchException.txt.pgp
rsync -va --force ubuntu@52.90.36.76:/var/sftp/uploads/$filename $DIR
ls -lath /out
python3 -u job/ec2_chk_ts_file_run_model.py
