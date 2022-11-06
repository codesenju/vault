# Introduction to Hashicorp Vault
### 1. Change all references of ```<HOSTNAME>``` in docker-compose.yml and config/config.hcl
### 2.0 
```
docker-compose up -d vault-db
```
### 2.1 
```
CREATE TABLE vault_kv_store (
  parent_path TEXT COLLATE "C" NOT NULL,
  path        TEXT COLLATE "C",
  key         TEXT COLLATE "C",
  value       BYTEA,
  CONSTRAINT pkey PRIMARY KEY (path, key)
);

CREATE INDEX parent_path_idx ON vault_kv_store (parent_path);
```
### 2.2
```
CREATE TABLE vault_ha_locks (
  ha_key                                      TEXT COLLATE "C" NOT NULL,
  ha_identity                                 TEXT COLLATE "C" NOT NULL,
  ha_value                                    TEXT COLLATE "C",
  valid_until                                 TIMESTAMP WITH TIME ZONE NOT NULL,
  CONSTRAINT ha_key PRIMARY KEY (ha_key)
);
```
3.0
```
docker-compose up -d
```

4.0
```
sudo echo 127.0.0.1 vault.example.com >> vault.example.com
docker exec -ti vault-tls /bin/sh
vault operator init
```
4.1

- Enter keys to unseal vault
- Go to https://vault.example.com and login using the root token
  
## How to's
- [Using Keycloak as the OpenIDC Identity Provider (to Login) to Hashicorp Vault]([www.google.com](https://number1.co.za/using-keycloak-as-the-identifyprovider-to-login-to-hashicorp-vault/))
- [Vault - OIDC Auth Method](https://developer.hashicorp.com/vault/tutorials/auth-methods/oidc-auth)
## References
- https://ahelpme.com/software/hashicorpvault/starting-hashicorp-vault-in-server-mode-under-docker-container/
- https://developer.hashicorp.com/vault/docs/platform/k8s/helm/examples/standalone-tls
- https://developer.hashicorp.com/vault/tutorials/db-credentials/database-secrets?in=vault%2Fdb-credentials
- https://github.com/hashicorp/hello-vault-spring/tree/main/quick-start

# Notes
```
######################################
Using roles
######################################
vault write auth/oidc/role/kv-mgr \
      bound_audiences="vault" \
      allowed_redirect_uris="https://<HOSTNAME>:8200/ui/vault/auth/oidc/oidc/callback" \
      allowed_redirect_uris="https://<HOSTNAME>:8250/oidc/callback" \
      user_claim="sub" \
      policies="manager" \
      groups_claim="/resource_access/vault/roles"
	  
vault write identity/group name="manager" type="external" \
         policies="manager" \
         metadata=responsibility="Manage K/V Secrets"
		 
export GROUP_ID=$(vault read -field=id identity/group/name/manager) \
export OIDC_AUTH_ACCESSOR=$(vault auth list -format=json  | /tmp/jq -r '."oidc/".accessor')

vault write identity/group-alias name="kv-mgr" \
         mount_accessor="$OIDC_AUTH_ACCESSOR" \
         canonical_id="$GROUP_ID"
```

```
######################################
Generate SSL
######################################
openssl req -new -key certs/vault-key.pem \
    -subj "/CN=vault.example.com" \
    -addext "subjectAltName = DNS:vault.example.com" \
    -out certs/vault-crt.pem \
    -config certs/vault_config.txt
```
```
######################################
Generate SSL for MACOS
######################################
openssl req -newkey rsa:2048 -days 365 -nodes -x509 \
    -subj "/CN=vault.example.com" \
    -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf \
            <(printf "[SAN]\nsubjectAltName='DNS:vault.example.com'")) \
    -keyout certs/vault-key.pem -out certs/vault-crt.pem
```