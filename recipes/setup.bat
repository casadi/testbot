openssl aes-256-cbc -k "%keyA%" -in testbot/id_rsa_travis.enc -out id_rsa_travis -d
openssl aes-256-cbc -k "%keyA%" -in testbot/testbotcredentials.py.enc -out testbotcredentials.py -d

git clone "ext::ssh -i $(%cd%/id_rsa_travis  git@github.com %S jgillis/restricted.git" 
