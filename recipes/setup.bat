openssl aes-256-cbc -k "%keyA%" -in id_rsa_travis.enc -out id_rsa_travis -d
openssl aes-256-cbc -k "%keyA%" -in testbotcredentials.py.enc -out testbotcredentials.py -d
openssl aes-256-cbc -k "%keyA%" -in env.bat.enc -out env.bat -d
openssl aes-256-cbc -k "%keyA%" -in id_rsa_travis.pkk.enc -out id_rsa_travis.pkk -d
  
set PYTHONPATH=%PYTHONPATH%;%cd%

git clone "ext::ssh -i %cd%/id_rsa_travis git@github.com %%S jgillis/restricted.git" 

