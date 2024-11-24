USERS_CSV_FILE = users.csv
PLAYBOOK_FILE_METRIX = metrics.yml
PLAYBOOK_FILE_PROXIES = proxies.yml
PLAYBOOK_FILE_USERS_CSV = users-csv.yml
PLAYBOOK_FILE_USERS_CONFIGS = users-configs.yml
HOSTS_FILE = inventory/hosts

hosts_encrypt:
	ansible-vault encrypt $(HOSTS_FILE)

hosts_decrypt:
	ansible-vault decrypt $(HOSTS_FILE)

render_users_csv:
	ansible-playbook $(PLAYBOOK_FILE_USERS_CSV)

render_users_configs:
	ansible-playbook $(PLAYBOOK_FILE_USERS_CONFIGS)

deploy_frontman:
	ansible-playbook $(PLAYBOOK_FILE_FRONTMAN)

deploy_metrics:
	ansible-playbook $(PLAYBOOK_FILE_METRIX)

deploy_proxies:
	ansible-playbook $(PLAYBOOK_FILE_PROXIES)

generate_uuid:
	uuidgen | tr '[:upper:]' '[:lower:]'
