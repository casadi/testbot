import re
import subprocess
p = subprocess.Popen(['sftp','casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi'],stdin=subprocess.PIPE,stdout=subprocess.PIPE)

out,_ = p.communicate('cd tested\nls')

files = filter(lambda x: x.startswith('casadi'), map(lambda x: x.rstrip(),out.split('\n')))


result = {}
for f in files:
  m = re.match('casadi[-_]([\d\.]+)\+(\d+)\.[a-f0-9]+(.*)',f)
  if m:
    result.setdefault(m.group(3)+m.group(1),[]).append((int(m.group(2)),f))

print "result:", result
  
remove = []
  
for v in result.values():
  v.sort()
  remove += map(lambda x: x[1],v[:-1])

print "remove:", remove
  
removecmd = ''
for i in remove:
  removecmd+= 'rm '+i+'\n'
  
p = subprocess.Popen(['sftp','casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi'],stdin=subprocess.PIPE,stdout=subprocess.PIPE)

out,_ = p.communicate('cd tested\n'+removecmd)

