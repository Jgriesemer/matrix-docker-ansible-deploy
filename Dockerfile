
---
sudo: required
dist: docker

language: python
python: "2.7"

before_install:
  - sudo apt-get update -q

install:
  - docker pull ansiblecheck/ansiblecheck:debian-jessie
  - container_id=$(mktemp)
  - docker run --detach --volume="${PWD}":/etc/ansible/roles/role_under_test:ro --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro ansiblecheck/ansiblecheck:debian-jessie /lib/systemd/systemd > "${container_id}"
  - echo "${container_id}"
script:
  - docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml --syntax-check
  - docker exec "$(cat ${container_id})" ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml -v

    #  - ansible-lint tests/travis_test.yml
