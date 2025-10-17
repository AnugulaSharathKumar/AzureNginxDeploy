**1. Step one**
Created the Deployment file.
deploy.sh

Given the Excute Permission for the file

Check the AzureCLI is installed or not?

 ```sh
@AnugulaSharathKumar ➜ /workspaces/AzureNginxDeploy (main) $ az login
bash: az: command not found
 ```

 Installation commands:

```sh
sudo apt-get update
sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

# Add the Microsoft signing key
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# Add the Azure CLI software repository
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
  sudo tee /etc/apt/sources.list.d/azure-cli.list

# Install the Azure CLI
sudo apt-get update
sudo apt-get install -y azure-cli
```
After Installation check with command

```sh
az version
```
