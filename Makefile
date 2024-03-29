USERS_FILE = inventory/group_vars/all/users.yml
URIS_FILE = URIs.txt
PLAYBOOK_FILE_FRONTMAN = frontman.yml
PLAYBOOK_FILE_PROXIES = proxies.yml
HOSTS_FILE = inventory/hosts
VAULT_FILE = vault.txt

encrypt_hosts:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(HOSTS_FILE)

decrypt_hosts:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(HOSTS_FILE)

encrypt_users:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(USERS_FILE)

decrypt_users:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(USERS_FILE)

encrypt_uris:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(URIS_FILE)

decrypt_uris:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(URIS_FILE)

deploy_frontman:
	ansible-playbook --vault-password-file $(VAULT_FILE) $(PLAYBOOK_FILE_FRONTMAN)

deploy_proxies:
	ansible-playbook --vault-password-file $(VAULT_FILE) $(PLAYBOOK_FILE_PROXIES)

generate_user:
	echo "    - uuid: $$(uuidgen | tr '[:upper:]' '[:lower:]')\n      secret: $$(openssl rand -base64 15)"
