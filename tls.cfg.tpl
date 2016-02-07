[server:default]
method = TLSv1
verify_certificate = ${TLS_VERIFY_CERTIFICATE}
require_certificate = ${TLS_REQUIRE_CERTIFICATE}
private_key = ${TLS_PRIVATE_KEY_PATH}
certificate = ${TLS_CERTIFICATE_PATH}
ca_list = ${TLS_CA_CHAIN_PATH}
#crl = ./modules/tls/crl.pem
#verify_depth = 3

[client:default]
verify_certificate = ${TLS_VERIFY_CERTIFICATE}
require_certificate = ${TLS_REQUIRE_CERTIFICATE}
