---
- name: Configure Servers
  hosts: all
  become: yes
  vars:
    server_hostname: "{{ inventory_hostname }}"
    static_ip: "{{ hostvars[inventory_hostname]['static_ip'] }}"
    netmask: "255.255.255.0"
    gateway: "192.168.1.1"
    dns_servers:
      - "8.8.8.8"
      - "8.8.4.4"
    users:
      - username: "user1"
        ssh_key: "ssh-rsa AAAAB3NzaC1yc..."
      - username: "user2"
        ssh_key: "ssh-rsa AAAAB3NzaC1yc..."

  tasks:
    - name: Change hostname
      hostname:
        name: "{{ server_hostname }}"

    - name: Set static IP address
      blockinfile:
        path: /etc/network/interfaces
        block: |
          auto eth0
          iface eth0 inet static
            address {{ static_ip }}
            netmask {{ netmask }}
            gateway {{ gateway }}
            dns-nameservers {{ dns_servers | join(' ') }}

    - name: Add hostname and IP to /etc/hosts
      lineinfile:
        path: /etc/hosts
        line: "{{ static_ip }} {{ server_hostname }}"
        state: present

    - name: Disable password authentication in SSH
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: "^PasswordAuthentication"
        line: "PasswordAuthentication no"
        state: present

    - name: Enable public key authentication in SSH
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: "^PubkeyAuthentication"
        line: "PubkeyAuthentication yes"
        state: present

    - name: Restart SSH service
      service:
        name: ssh
        state: restarted

    - name: Install and configure Fail2Ban
      apt:
        name: fail2ban
        state: present
      notify: Start Fail2Ban

    - name: Create users and add SSH keys
      user:
        name: "{{ item.username }}"
        state: present
        shell: /bin/bash
      loop: "{{ users }}"
      notify: Add SSH Key

    - name: Check for second disk and configure LVM
      block:
        - name: Identify second disk
          shell: lsblk -nd --output NAME | grep -v sda
          register: second_disk

        - name: Create LVM Physical Volume
          lvol:
            vg: data_vg
            lv: data_lv
            size: 100%FREE
          when: second_disk.stdout != ""

        - name: Format LVM Logical Volume
          filesystem:
            fstype: ext4
            dev: /dev/data_vg/data_lv
          when: second_disk.stdout != ""

        - name: Mount LVM Logical Volume
          mount:
            path: /mnt/data
            src: /dev/data_vg/data_lv
            fstype: ext4
            state: mounted
          when: second_disk.stdout != ""
      when: second_disk.stdout != ""

  handlers:
    - name: Start Fail2Ban
      service:
        name: fail2ban
        state: started
        enabled: yes

    - name: Add SSH Key
      authorized_key:
        user: "{{ item.username }}"
        key: "{{ item.ssh_key }}"
        state: present
      loop: "{{ users }}"


---
- name: Deploy GitLab Server
  hosts: gitlab_servers
  become: yes
  vars:
    gitlab_external_url: "http://gitlab.example.com"
    postgres_host: "db.example.com"
    postgres_user: "gitlab"
    postgres_password: "securepassword"
    postgres_db: "gitlabhq_production"

  tasks:
    - name: Install GitLab
      apt:
        name: gitlab-ce
        state: present
        update_cache: yes

    - name: Configure GitLab with external PostgreSQL
      lineinfile:
        path: /etc/gitlab/gitlab.rb
        regexp: "{{ item.regexp }}"
        line: "{{ item.line }}"
      loop:
        - { regexp: "^external_url", line: "external_url '{{ gitlab_external_url }}'" }
        - { regexp: "^postgresql\\['enable'\\]", line: "postgresql['enable'] = false" }
        - { regexp: "^gitlab_rails\\['db_adapter'\\]", line: "gitlab_rails['db_adapter'] = 'postgresql'" }
        - { regexp: "^gitlab_rails\\['db_host'\\]", line: "gitlab_rails['db_host'] = '{{ postgres_host }}'" }
        - { regexp: "^gitlab_rails\\['db_username'\\]", line: "gitlab_rails['db_username'] = '{{ postgres_user }}'" }
        - { regexp: "^gitlab_rails\\['db_password'\\]", line: "gitlab_rails['db_password'] = '{{ postgres_password }}'" }
        - { regexp: "^gitlab_rails\\['db_database'\\]", line: "gitlab_rails['db_database'] = '{{ postgres_db }}'" }

    - name: Reconfigure GitLab
      command: gitlab-ctl reconfigure

    - name: Install GitLab Runner
      apt:
        name: gitlab-runner
        state: present

    - name: Register GitLab Runner manually
      debug:
        msg: "Register the runner manually using the token from GitLab."


---
- name: Deploy Kubernetes Cluster
  hosts: k8s_masters[0]
  become: yes
  tasks:
    - name: Initialize Kubernetes Master
      shell: |
        kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint={{ control_plane_endpoint }}
      args:
        creates: /etc/kubernetes/admin.conf

    - name: Copy kubeconfig to home directory
      copy:
        src: /etc/kubernetes/admin.conf
        dest: ~/.kube/config
        remote_src: yes

    - name: Install Flannel Network Plugin
      shell: kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

- name: Join Additional Masters
  hosts: k8s_masters[1:]
  become: yes
  tasks:
    - name: Join Master Nodes
      shell: kubeadm join {{ control_plane_endpoint }} --token {{ join_token }} --discovery-token-ca-cert-hash {{ cert_hash }}

- name: Join Worker Nodes
  hosts: k8s_workers
  become: yes
  tasks:
    - name: Join Worker Nodes
      shell: kubeadm join {{ control_plane_endpoint }} --token {{ join_token }} --discovery-token-ca-cert-hash {{ cert_hash }}




helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx


helm repo add openebs https://openebs.github.io/charts
helm install openebs-zfs openebs/openebs-zfs


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack



FROM alpine:latest
RUN apk add --no-cache ansible kubectl helm
CMD ["ansible", "--version"]


docker build -t your-dockerhub-username/ansible-k8s-tools .
docker push your-dockerhub-username/ansible-k8s-tools


stages:
  - test
  - build
  - deploy

test:
  stage: test
  script:
    - pytest

build:
  stage: build
  script:
    - docker build -t your-app .
  only:
    - main

deploy:
  stage: deploy
  script:
    - kubectl apply -f k8s/deployment.yaml
  only:
    - tags



