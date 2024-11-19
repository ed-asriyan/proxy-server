# certbot
This role installs and configures Certbot, a tool to obtain and manage SSL/TLS certificates from the Let's Encrypt Certificate Authority. It sets up systemd services and timers to automate the certificate renewal process.

## Tasks
The following tasks are included in this role:

1. Install Certbot
2. Render systemd service and timer configurations
3. Reload the systemd daemon if configurations change
4. Enable the systemd timer service
5. Run Certbot once to obtain the initial certificate

## Mandatory and optional variables
Find them in [./defaults/main.yml](./defaults/main.yml). Empty variables in the file are mandatory, pre-filled variables are optional.
