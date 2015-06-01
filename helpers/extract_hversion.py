for l in file('casadi_meta.cpp','r').readlines():
  if "CasadiMeta::version" in l:
    version = l.split('"')[1]
    if "+" not in version:
      break
  if "CasadiMeta::git_describe" in l:
    version = l.split('"')[1]

print version
