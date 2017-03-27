# -*- coding: utf-8 -*-

from flask import Flask, request
import sqlite3
import json
from sqlite3 import OperationalError

app = Flask(__name__)
app_name = "/t-helper"

def get_daily_word_by_id(id):
    conn = sqlite3.connect("./t-helper.sqlite")
    cur = conn.cursor()
    try:
        cur.execute("select * from daily_words where id="+id)
        res = cur.fetchall()
        cur.close()
        print(res)
        return res
    except OperationalError as e:
        return {"error": str(e)}



@app.route(app_name+"/dayword", methods=["POST", "GET"])
def dayword():
    token = request.values.get("token")
    res = get_daily_word_by_id(token)
    if res == None or len(res) <= 0:
        res = get_daily_word_by_id("3")
    
    jsonObj = {"id": res[0][0], "title": res[0][1], "desc": res[0][2], "pic_url": res[0][3], "cover_pic_url": res[0][4], "english_title": res[0][5], "author": res[0][6]}
    
    return json.dumps(jsonObj)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8888, debug=True)

