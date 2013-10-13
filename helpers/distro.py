import requests
import json
import re
import os

import sys


sys.path.append('/home/casadibot')
sys.path.append('C:\\Users\\casadibot')

from testbotcredentials import TestBotCredentials

tbc = TestBotCredentials()

def scrapeVersion():
  version = None
  git_describe = None
  for l in file('../symbolic/casadi_meta.cpp','r'):
    m = re.search("version = \"(.*)\"",l)
    if m:
      version = m.group(1)
    m = re.search("git_describe = \"(.*)\"",l)
    if m:
      git_describe = m.group(1)
  if "+" in version and git_describe!="":
    return git_describe
  else:
    return version

s = requests.Session()
s.auth = tbc.github
s.headers.update({'Accept': 'application/vnd.github.manifold-preview'})

def guessMimeType(a):
  if a.endswith('.deb'):
    return "application/x-deb"
  elif a.endswith('.zip'):
    return ""
  elif a.endswith('.gz'):
    return "application/gzip"
  elif a.endswith('.pdf'):
    return "application/pdf"

def getHash(short):
  return s.get('https://api.github.com/repos/casadi/casadi/commits/%s' % short).json()["sha"]

def getRelease(name):
  """
   Get release id for release with this name.
   If there is no such release, create it 
  """
  if "+" in name:
    m = re.search("\+(\d+)\.(.*)$",name)
    target_commit = m.group(2)
    id = filter(lambda x: x["name"]=="tested",s.get('https://api.github.com/repos/casadi/casadi/releases').json())[0]["id"]
    r = s.patch('https://api.github.com/repos/casadi/casadi/releases/%d' % id,data=json.dumps({"tag_name": "tested","target_commitish": getHash(target_commit),"body": "CasADi bleeding edge: "+name,"draft": False,"prerelease": True}))
    assert(r)
    return r
  if name.startswith('v'):
    name = name[1:]
  r=s.get('https://api.github.com/repos/casadi/casadi/releases')
  assert(r.ok)
  l = filter(lambda x: x["name"]==name,r.json())
  if len(l)==0: # no release yet
    # Note: tag may not exist, but this matters only when you make it public
    r=s.post('https://api.github.com/repos/casadi/casadi/releases',data=json.dumps({"tag_name": name,"name": name,"body": "CasADi release v"+name,"draft": True,
      "prerelease": True}))
    assert(r.ok)
    #r=s.get('https://api.github.com/repos/casadi/casadi/tags').json()
    #l = filter(lambda x: x["name"]==name)
    #if len(l)==0: # no release tag yet
    #  r=s.post('https://api.github.com/repos/casadi/casadi/releases',data=json.dumps({"tag_name": +name,"name": name,"body": "CasADi release v"+name,"draft": True,
    #  "prerelease": True}))
    #else:
    #  r=s.post('https://api.github.com/repos/casadi/casadi/releases',data=json.dumps({"tag_name": name,"name": name,"body": "CasADi release v"+name,"draft": True,
    #  "prerelease": True}))
    return r
  else:
    return l[0]
    
def putFile(release,filename,alias=None,label=""):
  if alias is None:
    alias = os.path.basename(filename)
    
  assets = s.get('https://api.github.com/repos/casadi/casadi/releases/%d/assets' % release["id"])
  assert(assets.ok)
  
  for a in assets.json():
    if a["name"]==alias:
      s.delete(a["url"])
      
  rs = s.post(release["upload_url"].replace("{?name}",""),params={"name": alias,"label": label},data=file(filename,"r"),verify=False,headers={"Content-Type":guessMimeType(alias)})
  assert(rs.ok)
  return rs
  
def releaseFile(version,filename,alias=None,label=""):
  r = getRelease(version)
  rs = putFile(r.json(),filename,label=label,alias=alias)
