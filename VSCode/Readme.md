"
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
"
