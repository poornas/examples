#!/bin/sh

export VAULT_ADDR='http://127.0.0.1:1234'
export VAULT_TOKEN=myroot

SCHEME=http
SITE1_ENDPOINT=localhost:9001
SITE2_ENDPOINT=localhost:9004
SITE3_ENDPOINT=localhost:9006
SITE4_ENDPOINT=localhost:9008

SITE1_AK=$(curl -sS -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET ${VAULT_ADDR}/v1/kv/site1 | jq -r .data.accessKey)
SITE1_SK=$(curl -sS -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET ${VAULT_ADDR}/v1/kv/site1 | jq -r .data.secretKey)

SITE2_AK=$(curl -sS -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET ${VAULT_ADDR}/v1/kv/site2 | jq -r .data.accessKey)
SITE2_SK=$(curl -sS -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET ${VAULT_ADDR}/v1/kv/site2 | jq -r .data.secretKey)

SITE3_AK=$(curl -sS -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET ${VAULT_ADDR}/v1/kv/site3 | jq -r .data.accessKey)
SITE3_SK=$(curl -sS -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET ${VAULT_ADDR}/v1/kv/site3 | jq -r .data.secretKey)

SITE4_AK=$(curl -sS -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET ${VAULT_ADDR}/v1/kv/site4 | jq -r .data.accessKey)
SITE4_SK=$(curl -sS -H "X-Vault-Token: ${VAULT_TOKEN}" -X GET ${VAULT_ADDR}/v1/kv/site4 | jq -r .data.secretKey)

export MC_HOST_site1=${SCHEME}://${SITE1_AK}:${SITE1_SK}@${SITE1_ENDPOINT}
export MC_HOST_site2=${SCHEME}://${SITE2_AK}:${SITE2_SK}@${SITE2_ENDPOINT}
export MC_HOST_site3=${SCHEME}://${SITE3_AK}:${SITE3_SK}@${SITE3_ENDPOINT}
export MC_HOST_site4=${SCHEME}://${SITE4_AK}:${SITE4_SK}@${SITE4_ENDPOINT}

mc admin replicate add site1 site2 site3 site4
