# Proxy [![CI | pre-commit](https://github.com/ed-asriyan/proxy-server/actions/workflows/CI-pre-commit.yml/badge.svg)](https://github.com/ed-asriyan/proxy-server/actions/workflows/CI-pre-commit.yml) [![CD | Production](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml/badge.svg)](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml)
This is deployment for my personal server with [outline](http://getoutline.org)/[shadowsocks](http://shadowsocks.org) on board for me and my friends to bypass internet censorship.

## Shadowsocks clients that work with this setup
https://getoutline.org/get-started/#step-3

# Architecture
![digram](./diagram.svg)

There are two types of hosts: **frontman** and **proxy**. Frontman should be deployed as a single instance (sharding
under single DNS record and/or IP address is allowed). Proxies could be deployed as many instances as needed, each instance
should have dedicated IP address and DNS record (if exists). All hosts should be Debian hosts with public IPs.

## Frontman
It is a single linux host with the following tools installed and configured:
* [nginx](https://nginx.org) (role: `frontmen`) serving static content over HTTPS:
   * static html pages with installation instructions. The user is provided with a private instruction link with a personal ShadowSocks configuration, which the user uses once to install the ShadowSocks configuration
   * personal dynamic ShadowSocks configuration json files ([SIP008](https://shadowsocks.org/doc/sip008.html)) for each client, which is used by ShadowSocks client each time before connecting to a ShadowSocks server
* [prometheus](https://prometheus.io) (role: `prometheus`): monitoring to detect traffic abuse
* [certbot](https://certbot.eff.org) (role: `certbot`) for automatic and free renewal of HTTPS certificates used by nginx

Playbook: [frontman.yml](./frontman.yml)

## Proxy
As many proxy hosts as needed could be deployed but each one should have its own IP address and/or DNS record.
Proxy(ies) is/are linux host(s) with installed
* [outline-ss-server](https://github.com/Jigsaw-Code/outline-ss-server) (role: `shadowsocks`): Shadowsocks implementation made by
https://jigsaw.google.com that supports multiple access keys
* [node-exporter](https://github.com/prometheus/node_exporter) (role: `node-exporter`): Prometheus exporter for hardware and OS metrics
* [nginx](https://nginx.org) (role: `shadowsocks-gateway`) that proxies traffic:
  * port 443:
    * if connection is recognized as TLS, request is handled as HTTPS connection
    * otherwise; connection is proxied to ShadoSocks server
  * port `server.prometheus_metrics.port`: to outline-ss-server and node-exporter metrics endpoints

Playbook: [proxies.yml](./proxies.yml)

# Development
This part requires [Ansible](https://www.ansible.com) knowledge. The deployment is tested on and implemented for Debian
only.

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
  user1_name: user1_uuid
  user2_name: user2_uuid
  user3_name: user3_uuid
```

To create a new user, you should:
1. Decrypt the file with users:
   ```commandline
   make users_encrypt
   ```
2. Add/update users and secrets to the file: you should add/modify/delete usernames and their uuid (generated randomly by yourself) to the file
3. Encrypt the file back:
   ```commandline
   make users_decrypt
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
      make hosts_decrypt
      ```
    2. Add/update servers in the file
    3. Encrypt hosts file:
      ```commandline
      make hosts_encrypt
      ```
4. Generate new self-signed SSL cert & key for prometheus metrics endpoints and put the in new directory in `[files](inventory/files):
   ```commandline
   openssl req -x509 -addext="subjectAltName = DNS:*.example.com" -sha256 -days 356 -nodes -newkey rsa:2048 -subj "/CN=*.example.com/C=US L=Earth"            -keyout key.pem -out certificate.pem
   ```
5. Update inventory variables
   1. Update list of servers in [vars.yml](inventory/group_vars/all/vars.yml)
   2. Create a new directory in [group_vars](inventory/group_vars) and provide variable specific to the particular server
   3. Add server to `proxies` group in [hosts](inventory/hosts) (the file should be decrypted first)

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

Successful workflow generates an encrypted `users.csv` you can download to repository root and run the following command
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

### Generate user list table
```commandline
make users_csv_generate
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
