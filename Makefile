users_file = roles/outline/vars/users.yml
uris_file = URIs.txt

encrypt_users:
	ansible-vault encrypt --vault-password-file vault.txt $(users_file)

decrypt_users:
	ansible-vault decrypt --vault-password-file vault.txt $(users_file)

encrypt_uris:
	ansible-vault encrypt --vault-password-file vault.txt $(uris_file)

decrypt_uris:
	ansible-vault decrypt --vault-password-file vault.txt $(uris_file)
