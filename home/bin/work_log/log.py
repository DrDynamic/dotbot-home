#!/usr/bin/python3

import sqlite3
import sys
from datetime import datetime

tag = sys.argv[1]

with open('/home/mweber/logins.txt', 'a+') as f:
    f.write(tag + "\t" + datetime.now().strftime("%d.%m.%Y %H:%M:%S") + "\n")

con = sqlite3.connect('/home/mweber/logins.db')
cursor = con.cursor()

cursor.execute('''CREATE TABLE IF NOT EXISTS systemd (
            id INTEGER PRIMARY KEY,
            tag TEXT,
            date DATE
            );''')

cursor.execute('''INSERT INTO systemd
                (tag, date) 
                VALUES (?, datetime('now', 'localtime'))
            ''', (tag,))

con.commit()
