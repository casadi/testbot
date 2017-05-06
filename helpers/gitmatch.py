import subprocess

import sys
import yaml
inf = float('Inf')

config = yaml.load(open(sys.argv[1],'r'))

def score(s):
  if s=="default": return 1e9
  print >>sys.stderr, "check if in ancestry", s
  p = subprocess.Popen(["git","fetch","--unshallow"],cwd=sys.argv[2])
  p.wait()
  p = subprocess.Popen(["git","merge-base","--is-ancestor",s, "HEAD"],cwd=sys.argv[2])
  p.wait()
  if p.returncode!=0:
    print >>sys.stderr,"not found"
    return inf
  print >>sys.stderr, "check score", s
  p = subprocess.Popen(["git","rev-list","--ancestry-path","%s..HEAD" % s, "--count"],stdout=subprocess.PIPE,stderr=subprocess.PIPE,cwd=sys.argv[2])
  out,err = p.communicate()
  print >>sys.stderr, out
  return int(out) if p.returncode==0 else inf

print(sorted([(k,v,score(k)) for k,v in config.items()],key=lambda x:x[2])[0][1])





