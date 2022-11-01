# Introduction to Hashicorp Vault
### Change all references of ```<HOSTNAME>``` in docker-compose.yml and config/config.hcl
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
