
PART1: 

Setup RSA Token, so you don't have to enter your password to login to the Linux server:

ssh-keygen -t rsa -b 4096 -f %USERPROFILE%/.ssh/debian_rsa

scp -P 2222 %USERPROFILE%/.ssh/debian_rsa.pub atoz@192.168.0.106:~/key.pub

ssh -p 2222 atoz@192.168.0.106

cat ~/key.pub >> ~/.ssh/authroized_keys

chmod 600 ~/.ssh/authroized_keys

rm ~/key.pub

exit

Now test login in without password:

ssh -i  %USERPROFILE%/.ssh/debian_rsa -p 2222 atoz@192.168.0.106

Now config vscode remote-ssh (see below)

------------------------

PART2:

Manually setup Remote-SSH offline:
1. download remote-SSH from vscode marketplace and install it
2. Goto your linux server home directory and follow the instruction to extract the vscode-server from below
3. goto your vscode on windows and setup remote-SSH config
4. now execture remote-ssh from vscode
5. done



First get commit id
Download vscode server from url: https://update.code.visualstudio.com/commit:${commit_id}/server-linux-x64/stable
Upload the vscode-server-linux-x64.tar.gz to server
Unzip the downloaded vscode-server-linux-x64.tar.gz to ~/.vscode-server/bin/${commit_id} without vscode-server-linux-x64 dir
Create 0 file under ~/.vscode-server/bin/${commit_id}

e.g
commit_id=f06011ac164ae4dc8e753a3fe7f9549844d15e35

# Download url is: https://update.code.visualstudio.com/commit:${commit_id}/server-linux-x64/stable
curl -sSL "https://update.code.visualstudio.com/commit:${commit_id}/server-linux-x64/stable" -o vscode-server-linux-x64.tar.gz

mkdir -p ~/.vscode-server/bin/${commit_id}
# assume that you upload vscode-server-linux-x64.tar.gz to /tmp dir
tar zxvf /tmp/vscode-server-linux-x64.tar.gz -C ~/.vscode-server/bin/${commit_id} --strip 1
touch ~/.vscode-server/bin/${commit_id}/0

Plugins:
run in powershell
xml to json
json to csv
json tree view
convert yaml to json (vice versa)
