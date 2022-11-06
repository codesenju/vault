#storage "raft" {
#  path    = "/vault/data"
#  node_id = "node1"
#}

storage "postgresql" {
  connection_url = "postgres://vault:vault123@vault-db:5432/vault?sslmode=disable"
}

 
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_cert_file = "/vault/userconfig/vault-server-tls/vault-crt.pem"
  tls_key_file  = "/vault/userconfig/vault-server-tls/vault-key.pem"
  tls_disable = 0
  #tls_skip_verify = 1 # Disable verification of TLS certificates. 
                         # Using this option is highly discouraged 
                         # as it decreases the security of data 
                         # transmissions to and from the Vault server. 
}
 
disable_mlock = true

api_addr = "https://0.0.0.0:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true