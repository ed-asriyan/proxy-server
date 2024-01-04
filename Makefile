USERS_FILE = inventory/group_vars/all/users.yml
URIS_FILE = URIs.txt
PLAYBOOK_FILE = master.yml
VAULT_FILE = vault.txt
HOSTS_FILE = inventory/hosts
KNOWN_HOSTS_FILE=~/.ssh/known_hosts

encrypt_users:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(USERS_FILE)

decrypt_users:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(USERS_FILE)

encrypt_uris:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(URIS_FILE)

decrypt_uris:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(URIS_FILE)

deploy:
	ansible-playbook --vault-password-file $(VAULT_FILE) -i $(HOSTS_FILE) --ssh-extra-args="-o FingerprintHash=sha256 -o UserKnownHostsFile=$(KNOWN_HOSTS_FILE)" $(PLAYBOOK_FILE)

generate_user:
	echo "    - uuid: $$(uuidgen | tr '[:upper:]' '[:lower:]')\n      secret: $$(openssl rand -base64 15)"
