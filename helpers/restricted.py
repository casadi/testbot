import requests
import json
import time
import sys

timeout = 100

from testbotcredentials import TestBotCredentials

tbc = TestBotCredentials()



s = requests.Session()
s.auth = tbc.github
s.headers.update({'Accept': 'application/vnd.github.manifold-preview'})


def upload(filename):

  r = s.get('https://api.github.com/repos/jgillis/restricted/releases',timeout=timeout)
  assert r.ok, str(r)
  print r.json()
  l = filter(lambda x: x["name"]=="Perpetual",r.json())
  release = l[0]

  assets = s.get(release["assets_url"],timeout=timeout)
  assert(assets.ok), str(assets)
  time.sleep(1)

  for a in assets.json():
    if a["name"]==filename:
     print "Overwriting"
     r = s.delete(a["url"])
     assert r.ok, str(r)
     time.sleep(1)
        

  rs = s.post(release["upload_url"].replace("{?name}",""),params={"name": filename,"label": ""},data=file(filename,"r"),verify=False,headers={"Content-Type":"application/gzip"},timeout=timeout)
  assert rs.ok, str(rs.json())
  return rs
    
def download(filename):
  r = s.get('https://api.github.com/repos/jgillis/restricted/releases',timeout=timeout)
  assert r.ok, str(r)
  print r.json()
  l = filter(lambda x: x["name"]=="Perpetual",r.json())
  release = l[0]

  assets = s.get(release["assets_url"],timeout=timeout)
  assert(assets.ok), str(assets)
  time.sleep(1)

  for a in assets.json():
    if a["name"]==filename:
      rs = s.get(a["url"], stream=True,verify=False,headers={"Accept":"application/octet-stream"},timeout=timeout)
      rs = requests.get(rs.history[0].headers["location"])
      assert rs.ok, str(rs)
      i = 0
      with open(filename, 'wb') as f:
          for chunk in rs.iter_content():
              if i % 100000 == 0:
                print '...'
              i+= 1
              f.write(chunk)
  
