#!/usr/bin/python
import MySQLdb, os, htpasswd
try:
    import cPickle as pickle
except ImportError:
    import pickle

username = "10002"
#connect database
db = MySQLdb.connect("host","user","pass","db")
cursor = db.cursor()
# sql command
sql = "SELECT * FROM members WHERE username = %s" % (username)
try:
    cursor.execute(sql)
    results = cursor.fetchall()
    for row in results:
        passwd = row[2]
        enable = row[6]
except:
    print "ERROR"
    db.close()
    exit()
db.close()

#got a value?

try:
    passwd
except:
    print "no value"
    exit()


#save passwd into file
try:
    f=open('/home/lazypt/pw.save', 'rb')
    oldpw=pickle.load(f)
    f.close()
except:
    f=open('/home/lazypt/pw.save','wb')
    pickle.dump(passwd,f)
    f.close()
    oldpw='nopassword'
#check password    
if passwd!=oldpw:
    with htpasswd.Basic("/home/ptuser/config/web/.htpasswd") as userdb:
        try:
            userdb.change_password(username, passwd)
        except htpasswd.basic.UserNotExists, e:
            print e
    f=open('/home/lazypt/pw.save', 'wb')
    pickle.dump(passwd, f)
    f.close()

#check enable
if enable == 0:
    os.system("docker stop lazypt")
    os.system("rm /home/ptuser/config/rtorrent/rtorrent-sess/*")
    os.system("rm -rf /home/ptuser/downloads/incoming/*")
    os.system("rm -rf /home/ptuser/downloads/completed/*")
    os.system("rm -rf /home/ptuser/downloads/watched/*")
    print "Stop service"
else:
    os.system("docker start lazypt")
    print "start service"

#finished
print "%s, %s" %(passwd, enable)
