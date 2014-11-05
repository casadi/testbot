import requests
import json

timeout = 100

from testbotcredentials import TestBotCredentials

tbc = TestBotCredentials()



s = requests.Session()
s.auth = tbc.github
s.headers.update({'Accept': 'application/vnd.github.manifold-preview'})


def upload(filename):

  r = s.get('https://api.github.com/repos/jgillis/restricted/releases',timeout=timeout)
  l = filter(lambda x: x["name"]=="perpetual",r.json())
  release = l[0]

  assets = s.get('https://api.github.com/repos/repos/jgillis/releases/%d/assets' % release["id"],timeout=timeout)
  assert(assets.ok)
  time.sleep(1)

  for a in assets.json():
    if a["name"]==filename:
     print "Overwriting"
     r = s.delete(a["url"])
     assert r.ok, str(r)
     time.sleep(1)
        
    rs = s.post(release["upload_url"].replace("{?name}",""),params={"name": filename,"label": ""},data=file(filename,"r"),verify=False,headers={"Content-Type":"application/octet-stream"},timeout=timeout)
    assert rs.ok, str(rs.json())
    return rs
  
  
