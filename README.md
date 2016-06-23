# Openshift
A repository for openshift configuration files

## Getting Started

* Starting the VM and connecting via SSH
```
$ vagrant up
$ vagrant ssh
```
* Logging in to Openshift Command Line
```bash
$ oc login
```

Specify: admin/admin as username and password, respectively.

## Extracting Auth Token
curl -vv -k -D - -u admin:admin  -H 'X-CSRF-Token: 1' 'https://10.2.2.2:8443/oauth/authorize?client_id=openshift-challenging-client&response_type=token' 2>&1 | egrep "access_token=(.*)"| head -n 1 | cut -d# -f2 | sed 's/^.*=\(.*\)\&.*\&.*$/\1/'
l35yd7pIssa41J9EF2rvTHeFn3p-OlrTPVL1ic6Bk-0
