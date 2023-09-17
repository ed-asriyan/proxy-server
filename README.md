# Proxy [![CI | pre-commit](https://github.com/ed-asriyan/proxy-server/actions/workflows/CI-pre-commit.yml/badge.svg)](https://github.com/ed-asriyan/proxy-server/actions/workflows/CI-pre-commit.yml) [![CD | Production](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml/badge.svg)](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml)
This is deployment for my personal server with [outline](http://getoutline.org)/[shadowsocks](http://shadowsocks.org) on board for me and my friends to bypass internet censorship.

It includes:
* [outline-ss-server](https://github.com/Jigsaw-Code/outline-ss-server): shadowsocks implementation made by https://jigsaw.google.com that supports multiple access keys
* [prometheus](https://prometheus.io): monitoring to detect traffic abuse

## Shadowsocks clients that work with this setup:
https://getoutline.org/get-started/#step-3

# Editing the configuration
At the very beginning:
1. Initialize pre-commit hook to prevent secrets from being leaked:
   1. Install [pre-commit](https://pre-commit.com/#install)
   2. Initialize pre-commit hook:
      ```commandline
      pre-commit install
      ```
2. Create `vault.txt` file in the repository root. Put your vault password file in it. **Make sure that only you have
permissions to read/write it: `chmod 600 vault.txt`!**

## Update shadowsocks users
Users are stored in [encrypted users.yml file](roles/outline/vars/users.yml) with the following structure:
```yaml
users:
  user1_name:
    - user1_secret1
    - user1_secret2
  user2_name:
    - user2_secret1
    - user2_secret2
    - user2_secret3
  user3_name:
    - user3_secret1
```

To create a new user, you need to:
1. Decrypt file:
   ```commandline
   make decrypt_users
   ```
2. Add new users and secrets to the file
3. Encrypt the file back:
   ```commandline
   make encrypt_users
   ```

## Update servers
* List if servers: [encrypted hosts](inventory/hosts).
* Common DNS record of the servers: [inventory/group_vars/all/vars.yml](inventory/group_vars/all/vars.yml)
* SSL certificate & private key of the domain used for prometheus web panel:
  * [roles/prometheus/files/certificate.crt](roles/prometheus/files/certificate.crt)
  * [roles/prometheus/files/private.key](roles/prometheus/files/private.key)

To add a new server, you need:
1. Add a new host to [inventory/hosts](inventory/hosts), give it a name
2. Add a new host name to [master.yml](master.yml)
3. Copy an existing directory in [inventory/](inventory/), rename it within the given name and adjust variables in it

## Deploy updates
Just push to master branch. GitHub Actions will automatically apply updates to the servers.

# Development
## CD
The following GitHub secrets are required for CD:
* `KNOWN_HOSTS`: list of known hosts as in `.ssh/known_hosts`
* `VAULT_PASSWORD`: vault password

Successful workflow generates an encrypted `URIs.txt` you can download to repository root and run the following command
to decrypt the file:
```commandline
make decrypt_uris
```
It can be useful for sharing SS URIs with users.

## Local
### Deploy on production
```commandline
make deploy
```

### Decrypt string
```commandline
ansible-vault decrypt --vault-password-file vault.txt
```

### Encrypt string
```commandline
ansible-vault encrypt --vault-password-file vault.txt
```

### Decrypt file
```commandline
ansible-vault encrypt --vault-password-file vault.txt <file_path>
```

### Encrypt file
```commandline
ansible-vault decrypt --vault-password-file vault.txt <file_path>
```
