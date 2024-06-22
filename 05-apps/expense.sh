#!/bin/bash
# by default it give sudo access

dnf install ansible -y
cd /tmp
git clone https://github.com/Siva837453/Expense-Ansible-rule.git
cd Expense-Ansible-rule
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend