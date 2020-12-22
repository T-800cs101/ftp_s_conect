# encoding:utf-8

from ftplib import FTP
import os
import fileinput

ftp = FTP()
ftp.set_debuglevel(2)
ftp.connect('tourget ip name', 'port')#
ftp.login('username', 'password')

ftp.cwd('')


def ftp_upload(localfile, remotefile):
    fp = open(localfile, 'rb')
    ftp.storbinary('STOR %s' % os.path.basename(localfile), fp, 1024)
    fp.close()
    print
    "after upload " + localfile + " to " + remotefile


localdir = "path to the transferred file"
file_all = '*'
def upload_file(file):
    try:
        ftp_upload(localdir + "\\" + file, file)
    except:
        print(localdir + "\\" + file+" is not a file.")


lastlist = []

currentlist = os.listdir(localdir)

newfiles = list(set(currentlist) - set(lastlist))

if len(newfiles) == 0:
    print
    "No files need to upload"
else:
    for needupload in newfiles:
        print
        "uploading " + localdir + "\\*" + needupload
        upload_file(needupload)

ftp.quit()
