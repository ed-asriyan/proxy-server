# Configuration files
This directory contains configuration files.

## How to edit
### If you use GitHub Actions
Create the following secrets:
* `FRONTMAN`: copy content of [frontman.example.yml](./frontman.example.yml) to the secret and fill out each variable
* `SERVERS`: copy content of [servers.example.yml](./servers.example.yml) to the secret and fill out each variable
* `HOSTS`: copy content of [hosts.example.yml](./hosts.example.yml) to the secret and fill out each variable
* `METRICS`: copy content of [metrics.example.yml](./metrics.example.yml) to the secret and fill out each variable
* `USERS`: copy content of [users.example.yml](./users.example.yml) to the secret and fill out each variable

### If you run Ansible local
1. Copy each file and remove `.example` from it's name. E.g `servers.example.yml` -> `servers.example.yml`
2. Fill out each variale in each file
