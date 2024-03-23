# Proxy [![CI | pre-commit](https://github.com/ed-asriyan/proxy-server/actions/workflows/CI-pre-commit.yml/badge.svg)](https://github.com/ed-asriyan/proxy-server/actions/workflows/CI-pre-commit.yml) [![CD | Production](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml/badge.svg)](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml)
This is deployment for my personal server with [outline](http://getoutline.org)/[shadowsocks](http://shadowsocks.org) on board for me and my friends to bypass internet censorship.

## Shadowsocks clients that work with this setup
https://getoutline.org/get-started/#step-3

# Architecture diagram
![digram](./diagram.svg)

**Frontman** is linux host seith static server serving via HTTPS
* Static html pages with installation instructions
* Dynamic ShadowSocks configuration ([SIP008](https://shadowsocks.org/doc/sip008.html))

**Proxy 1..N** are linux hosts with installed
* [outline-ss-server](https://github.com/Jigsaw-Code/outline-ss-server): shadowsocks implementation made by https://jigsaw.google.com that supports multiple access keys
* [prometheus](https://prometheus.io): monitoring to detect traffic abuse

# Setup
This part requires [Ansible](https://www.ansible.com) knowledge.

## At the very beginning
1. Initialize pre-commit hook to prevent secrets from being leaked:
   1. Install [pre-commit](https://pre-commit.com/#install)
   2. Initialize pre-commit hook:
      ```commandline
      pre-commit install
      ```
2. Create `vault.txt` file in the repository root. Put your vault password file in it. **Make sure that only you have
permissions to read/write it: `chmod 600 vault.txt`!**
3. If servers are not configured yet, skip this step and go to "New server setup" section. Otherwise if server is already configured, add SSH private key to `id_rsa` file in the root of the local repository. **Make sure that only you have
permissions to read/write it: `chmod 600 id_rsa`!**

## How to update list of SS users
Users are stored in [encrypted users.yml file](inventory/group_vars/all/users.yml) with the following schema:
```yaml
users:
  user1_name:
    - uuid: user1_uuid1
      secret: user1_secret1
    - uuid: user1_uuid2
      secret: user1_secret2
  user2_name:
    - uuid: user2_uuid1
      secret: user2_secret1
    - uuid: user2_uuid2
      secret: user2_secret2
    - uuid: user2_uuid1
      secret: user2_secret3
  user3_name:
    - uuid: user3_uuid1
      secret: user3_secret1
```

To create a new user, you should:
1. Decrypt the file with users:
   ```commandline
   make decrypt_users
   ```
2. Add/update users and secrets to the file
3. Encrypt the file back:
   ```commandline
   make encrypt_users
   ```

## New server setup
1. Generate new SSH key and store it in `id_rsa` file in the root of the local repository:
   ```commandline
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
   If you have already generated keys, skip this step.
2. Add content of `is_rsa.pub` file (is also a result of previous command) to `/root/.ssh/authorized_keys` file on a new server. **Make sure that proper access rights are granted: `chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys`!**
3. Update [hosts file](inventory/hosts)
   1. Decrypt hosts file:
      ```commandline
      make decrypt_hosts
      ```
    2. Add/update servers in the file
    3. Encrypt hosts file:
      ```commandline
      make encrypt_hosts
      ```
4. Update inventory variables
   1. Create a new directory in [group_vars](inventory/group_vars) and provide variable specific to the particular server
   2. Update list of servers in [vars.yml](inventory/group_vars/all/vars.yml)
5. Update list of hosts in [proxies.yml](proxies.yml)

## How to do smth else
Read code and find out

## How to apply changes to production
Just push to master branch. GitHub Actions will automatically apply updates to the servers.

# Development
## CD
The following GitHub secrets are required for CD:
* `KNOWN_HOSTS`: list of known hosts as in `.ssh/known_hosts`
* `SSH_PRIVATE_KEY`: SSH private key to access servers
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
make deploy_frontman deploy_proxies
```

### Generate user client
```commandline
make generate_user
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
