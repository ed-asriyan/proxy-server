# Proxy [![CI | pre-commit](https://github.com/ed-asriyan/proxy-server/actions/workflows/CI-pre-commit.yml/badge.svg)](https://github.com/ed-asriyan/proxy-server/actions/workflows/CI-pre-commit.yml) [![CD | Production](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml/badge.svg)](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml)
This is deployment for my personal server with [outline](http://getoutline.org)/[shadowsocks](http://shadowsocks.org) on board for me and my friends to bypass internet censorship.

## Shadowsocks clients that work with this setup
https://getoutline.org/get-started/#step-3

# Architecture
![digram](./diagram.svg)

There are 3 types of hosts: **frontman**, **metrics** and **proxy**. Frontman should be deployed as a single instance (sharding
under single DNS record and/or IP address is allowed). Metrics should be deployed as a single instance (sharding is not allowed).
Proxies could be deployed as many instances as needed, each instance should have dedicated IP address and DNS record (if exists).
All hosts should be Debian hosts with public IPs.

## Frontman
It is a single linux host with the following tools installed and configured:
* [nginx](https://nginx.org) (role: `frontmen`) serving static content over HTTPS:
   * static html pages with installation instructions. The user is provided with a private instruction link with a personal ShadowSocks configuration, which the user uses once to install the ShadowSocks configuration
   * personal dynamic ShadowSocks configuration json files ([SIP008](https://shadowsocks.org/doc/sip008.html)) for each client, which is used by ShadowSocks client each time before connecting to a ShadowSocks server
* [certbot](https://certbot.eff.org) (role: `certbot`) for automatic and free renewal of HTTPS certificates used by nginx

Playbook: [frontman.yml](./frontman.yml)

## Metrics
It is a single linux host with the prometheus installed. Users do not access this host. Host may have no domain name.
* [prometheus](https://prometheus.io) (role: `prometheus`): monitoring to detect traffic abuse

## Proxy
As many proxy hosts as needed could be deployed but each one should have its own IP address and/or DNS record.
Proxy(ies) is/are linux host(s) with installed
* [outline-ss-server](https://github.com/Jigsaw-Code/outline-ss-server) (role: `shadowsocks`): Shadowsocks implementation made by
https://jigsaw.google.com that supports multiple access keys
* [node-exporter](https://github.com/prometheus/node_exporter) (role: `node-exporter`): Prometheus exporter for hardware and OS metrics
* [nginx](https://nginx.org) (role: `shadowsocks-gateway`) that proxies traffic:
  * port `config_servers[uuid].port`:
    * if connection is recognized as TLS, request is handled as HTTPS connection
    * otherwise; connection is proxied to ShadoSocks server
  * port `config_servers[uuid].prometheus_metrics.port`: to outline-ss-server and node-exporter metrics endpoints

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
3. If servers are not configured yet, skip this step and go to "New server setup" section. Otherwise if server is already configured, add SSH private key to `id_rsa` file in the root of the local repository. **Make sure that only you have
permissions to read/write it: `chmod 600 id_rsa`!**

## Initial setup
1. Go to [config](./config) and setup config files or GitHub Secrets.
2. Add yout public key (pair of one you created in root of the local repo) to all servers' root user
3. Run Deploy

## How to update list of SS users
1. Update config in [config](./config) or update GitHub Secrets.
2. Run Deploy

## How to add anew
1. Update config in [config](./config) or update GitHub Secrets.
2. Add yout public key (pair of one you created in root of the local repo) to the new server's root user
3. Run Deploy

## How to do smth else
Read code and find out

## How to apply changes to production
* If you changed deploy code: just push to master branch. GitHub Actions will automatically apply updates to the servers.
* If you changed list of users: manually trigger [CD | Production](https://github.com/ed-asriyan/proxy-server/actions/workflows/CD-production.yml)

# Development
## CD
The following GitHub secrets are required for CD:
* `KNOWN_HOSTS`: list of known hosts as in `.ssh/known_hosts`
* `SSH_PRIVATE_KEY`: SSH private key to access servers
* secrets described in [config](./config)

## Local
### Deploy on production
```commandline
make deploy_frontman deploy_proxies deploy_metrics
```

### Generate user list table
```commandline
make generate_users_csv
```

### Generate UUID for a new user
```commandline
make generate_uuid
```
