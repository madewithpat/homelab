# Homelab Infrastructure

I created this repository to manage my home infrastructure, and learn some Ansible in the process.

<br/>

# Getting Started
Currently there's a known issue with ansible configs living in a world-writable directory. While this is a great security practice, it's sort of a pain. What I've found as a quick workaround is setting the `ANSIBLE_CONFIG` environment variable as follows

```sh
# From the root of this repository
export ANSIBLE_CONFIG=./ansible.cfg
```

## Makefile

The above configuration workaround is currently in the makefile, along with some other small tasks that simplify interactions.

```sh

# This will set up the precommit hook, which prevents commiting an unencrypted ansible vault
make gitinit

# Some shorthand tasks for encrypting and decrypting
# `vault-password` is gitignored, and can be safely kept in the repo
# But be sure to back this up somewhere!
make decrypt
make encrypt

```

<br/>

---
<br/>

## References
<br/>

### Ansible
[Ansible 101](https://medium.com/@denot/ansible-101-d6dc9f86df0ahttps://medium.com/@denot/ansible-101-d6dc9f86df0a) - A quick intro to ansible. Instead of starting with localhost, I would recommend setting up a remote server (you'll need to set up ssh access)

[Secrets Management](https://blog.ktz.me/secret-management-with-docker-compose-and-ansible/) - Alex Katz is a legend, most of this repository was inspired by his contributions to the homelab community

<br/>

### Fan speed
[R710 Quieter](https://blog.lbdg.me/r710-quieter/?utm_source=pocket_mylist) - This was the basis for my fanspeed role

