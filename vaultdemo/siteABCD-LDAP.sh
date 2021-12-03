#!/usr/bin/env bash

trap 'catch' ERR

catch() {
    echo "Cleaning up instances of MinIO"
    killall minio
    rm -rf /tmp/multisitea
    rm -rf /tmp/multisiteb
    rm -rf /tmp/multisitec
    rm -rf /tmp/multisited
}

catch

set -e
# go install -v
export MINIO_BROWSER=off
export MINIO_PROMETHEUS_AUTH_TYPE=public

export MINIO_IDENTITY_LDAP_SERVER_ADDR=localhost:389
export MINIO_IDENTITY_LDAP_SERVER_INSECURE=on
export MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN=cn=admin,dc=min,dc=io
export MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD=admin
export MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN=dc=min,dc=io
export MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER="(uid=%s)"
export MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN=ou=swengg,dc=min,dc=io
export MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER="(&(objectclass=groupOfNames)(member=%d))"

export MINIO_ROOT_USER="minio1"
export MINIO_ROOT_PASSWORD="minio123"

$minio server --address :9001 "http://localhost:9001/tmp/multisitea/data/disterasure/xl{1...4}" \
      "http://localhost:9002/tmp/multisitea/data/disterasure/xl{5...8}" >/tmp/sitea_1.log 2>&1 &
$minio server --address :9002 "http://localhost:9001/tmp/multisitea/data/disterasure/xl{1...4}" \
      "http://localhost:9002/tmp/multisitea/data/disterasure/xl{5...8}" >/tmp/sitea_2.log 2>&1 &


export MINIO_ROOT_USER="minio2"
export MINIO_ROOT_PASSWORD="minio123"
$minio server --address :9003 "http://localhost:9003/tmp/multisiteb/data/disterasure/xl{1...4}" \
      "http://localhost:9004/tmp/multisiteb/data/disterasure/xl{5...8}" >/tmp/siteb_1.log 2>&1 &
$minio server --address :9004 "http://localhost:9003/tmp/multisiteb/data/disterasure/xl{1...4}" \
      "http://localhost:9004/tmp/multisiteb/data/disterasure/xl{5...8}" >/tmp/siteb_2.log 2>&1 &

export MINIO_ROOT_USER="minio3"
export MINIO_ROOT_PASSWORD="minio123"
 $minio server --address :9005 "http://localhost:9005/tmp/multisitec/data/disterasure/xl{1...4}" \
       "http://localhost:9006/tmp/multisitec/data/disterasure/xl{5...8}" >/tmp/sitec_1.log 2>&1 &
 $minio server --address :9006 "http://localhost:9005/tmp/multisitec/data/disterasure/xl{1...4}" \
       "http://localhost:9006/tmp/multisitec/data/disterasure/xl{5...8}" >/tmp/sitec_2.log 2>&1 &

export MINIO_ROOT_USER="minio4"
export MINIO_ROOT_PASSWORD="minio123"
 $minio server --address :9007 "http://localhost:9007/tmp/multisited/data/disterasure/xl{1...4}" \
       "http://localhost:9008/tmp/multisited/data/disterasure/xl{5...8}" >/tmp/sited_1.log 2>&1 &
 $minio server --address :9008 "http://localhost:9007/tmp/multisited/data/disterasure/xl{1...4}" \
       "http://localhost:9008/tmp/multisited/data/disterasure/xl{5...8}" >/tmp/sited_2.log 2>&1 &

sleep 30
