# nginx
This role installs and configures the NGINX web server.

## Tasks
The following tasks are included in this role:

1. Install nginx and required libraries
2. Set CAP_NET_BIND_SERVICE capability for nginx executable so it listen any port regardless what user executes the executable
3. Ensures that the default nginx systemd service is not running

## Mandatory and optional variables
No
