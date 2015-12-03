import requests
import json
import time
import sys

import os


timeout = 100

from testbotcredentials import TestBotCredentials

tbc = TestBotCredentials()

s = requests.Session()
s.auth = tbc.github
s.headers.update({'Accept': 'application/vnd.github.manifold-preview'})

myparams = {"per_page": 100}

def upload(filename):

  r = s.get('https://api.github.com/repos/jgillis/restricted/releases',timeout=timeout)
  assert r.ok, str(r)
  print r.json()
  l = filter(lambda x: x["name"]=="Perpetual",r.json())
  release = l[0]

  assets = s.get(release["assets_url"],timeout=timeout,params=myparams)
  assert(assets.ok), str(assets)
  time.sleep(1)

  for a in assets.json():
    if a["name"]==filename:
     print "Overwriting"
     r = s.delete(a["url"])
     assert r.ok, str(r)
     time.sleep(1)
        

  rs = s.post(release["upload_url"].replace("{?name,label}",""),params={"name": filename,"label": ""},data=file(filename,"rb"),verify=False,headers={"Content-Type":"application/gzip"},timeout=timeout)
  assert rs.ok, str(rs.json())
  return rs

def download(filename):
  r = s.get('https://api.github.com/repos/jgillis/restricted/releases',timeout=timeout)
  assert r.ok, str(r)
  l = filter(lambda x: x["name"]=="Perpetual",r.json())
  release = l[0]

  assets = s.get(release["assets_url"],timeout=timeout,params=myparams)
  assert(assets.ok), str(assets)
  time.sleep(1)

  for a in assets.json():
    if a["name"]==filename:
      rs = s.get(a["url"], stream=True,verify=False,headers={"Accept":"application/octet-stream"},timeout=timeout)
      rs = requests.get(rs.history[0].headers["location"],stream = True)
      assert rs.ok, str(rs)
      i = 0
      with open(filename, 'wb') as f:
          for chunk in rs.iter_content(chunk_size=1024*1024):
              if i % 10 == 0:
                print i, ' MB'
              i+= 1
              f.write(chunk)
  
