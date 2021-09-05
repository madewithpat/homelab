config:
	export ANSIBLE_CONFIG=./ansible.cfg

fancontrol: config
	ansible-playbook -b main.yml --limit fancontrol

decrypt:
	ansible-vault decrypt vars/vault.yaml

encrypt:
	ansible-vault encrypt vars/vault.yaml

gitinit:
	@./git-init.sh
	@echo "precommit hook installed for ansible vault"
	@echo "don't forget to create a .vault-password too"
