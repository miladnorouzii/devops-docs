# without roles

```
ansible-playbook -i inventory/hosts.ini file1.yaml
```

# with roles

```
ansible-playbook -i inventory/hosts.ini main.yml  --become --become-method=sudo
```

