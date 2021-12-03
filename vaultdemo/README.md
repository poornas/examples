## Setting up site replciation with credentials from Vault

### Start docker LDAP
docker run \
  -p 389:389 -p 636:636 --name minio-ldap-server \
  --env LDAP_ORGANISATION="MinIO Inc" \
  --env LDAP_DOMAIN="min.io" \
  --env LDAP_ADMIN_PASSWORD="admin" \
        --volume $PWD/bootstrap.ldif:/container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif \
  --hostname minio-ldap-server \
        osixia/openldap:1.4.0 --copy-service
### Start minio clusters
./siteABCD-LDAP.sh

### Starting vault
docker exec -it $(docker run -d --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:1234' --net=host -p 1234:1234 vault) /bin/sh

### Enable secrets engine
export VAULT_ADDR='http://127.0.0.1:1234'
export VAULT_TOKEN=myroot
vault secrets enable -version=1 kv

### Save site creds in vault
vault kv put kv/site1 accessKey=minio1 secretKey=minio123
vault kv put kv/site2 accessKey=minio2 secretKey=minio123
vault kv put kv/site3 accessKey=minio3 secretKey=minio123
vault kv put kv/site4 accessKey=minio4 secretKey=minio123


### Get site creds 
#vault kv get kv/site1

### Set up site replication
./vault.sh
