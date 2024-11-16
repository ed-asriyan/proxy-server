USERS_CSV_FILE = users.csv
PLAYBOOK_FILE_FRONTMAN = frontman.yml
PLAYBOOK_FILE_METRIX = metrics.yml
PLAYBOOK_FILE_PROXIES = proxies.yml
PLAYBOOK_FILE_USERS_CSV = users-csv.yml
HOSTS_FILE = inventory/hosts
VAULT_FILE = vault.txt

hosts_encrypt:
	ansible-vault encrypt --vault-password-file $(VAULT_FILE) $(HOSTS_FILE)

hosts_decrypt:
	ansible-vault decrypt --vault-password-file $(VAULT_FILE) $(HOSTS_FILE)

generate_users_csv:
	ansible-playbook --vault-password-file $(VAULT_FILE) $(PLAYBOOK_FILE_USERS_CSV)

deploy_frontman:
	ansible-playbook --vault-password-file $(VAULT_FILE) $(PLAYBOOK_FILE_FRONTMAN)

deploy_metrics:
	ansible-playbook --vault-password-file $(VAULT_FILE) $(PLAYBOOK_FILE_METRIX)

deploy_proxies:
	ansible-playbook --vault-password-file $(VAULT_FILE) $(PLAYBOOK_FILE_PROXIES)

generate_uuid:
	uuidgen | tr '[:upper:]' '[:lower:]'
