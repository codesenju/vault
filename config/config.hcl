storage "raft" {
  path    = "/vault/data"
  node_id = "node1"
}
 
listener "tcp" {
  address     = "0.0.0.0:5001"
  tls_cert_file = "/vault/userconfig/vault-server-tls/<HOSTNAME>-crt.pem"
  tls_key_file  = "/vault/userconfig/vault-server-tls/<HOSTNAME>-key.pem"
  # tls_client_ca_file = "/vault/userconfig/vault-server-tls/vault.ca"
  tls_disable = 0
  tls_skip_verify = true # Disable verification of TLS certificates. 
                         # Using this option is highly discouraged 
                         # as it decreases the security of data 
                         # transmissions to and from the Vault server. 
}
 
disable_mlock = true
 
api_addr = "https://0.0.0.0:5001"
cluster_addr = "https://127.0.0.1:5002"
ui = true


C:\Program Files\Java\jdk1.8.0_333\jre\lib\security\cacerts

keytool -import -alias vault -file C:\Users\F5367204\DevOps\Certs\fas-rbglint04-crt.pem -keystore C:\Program Files\Java\jdk1.8.0_333\jre\lib\security\cacerts

vault123