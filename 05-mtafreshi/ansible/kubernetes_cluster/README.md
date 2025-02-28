## Requirment:

### Please Configure 'DNS (for IRAN)' for Configure Kubernetes-Cluster!~ .
```
inventory/group_vars/all.yaml 
```
### Please Configure hosts.ini for Hosts and Domain
```
inventory/hosts.ini
```

### Recommended
```
You must Use Ubuntu 24.04~Noble for this Ansible
```

## Run Ansible:
```
ansible-playbook -i inventory/hosts.ini main.yaml --become --become-method=sudo
```

Good Lock!~ .