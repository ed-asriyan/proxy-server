USERS_FILE = inventory/group_vars/all/users.yml
URIS_FILE = URIs.txt
PLAYBOOK_FILE_FRONTMAN = frontman.yml
PLAYBOOK_FILE_PROXIES = proxies.yml
HOSTS_FILE = inventory/hosts
VAULT_FILE = vault.txt

hosts_encrypt:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(HOSTS_FILE)

hosts_decrypt:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(HOSTS_FILE)

users_encrypt:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(USERS_FILE)

users_decrypt:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(USERS_FILE)

uris_encrypt:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(URIS_FILE)

uris_decrypt:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(URIS_FILE)

deploy_frontman:
	ansible-playbook --vault-password-file $(VAULT_FILE) $(PLAYBOOK_FILE_FRONTMAN)

deploy_proxies:
	ansible-playbook --vault-password-file $(VAULT_FILE) $(PLAYBOOK_FILE_PROXIES)

generate_user:
	echo "  user_name: $$(uuidgen | tr '[:upper:]' '[:lower:]')"
