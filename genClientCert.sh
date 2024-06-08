# https://www.golinuxcloud.com/openssl-create-client-server-certificate/

CLIENT="${1:-client}"
SERVER="${2:-localhost}"
CA="${3:-root}"

CORPORATION=Ergon
GROUP=Airlock
CITY=Zurich
STATE=Zurich
COUNTRY=CH

cd "$(dirname "$0")"

# create client private key (used to decrypt the cert we get from the CA)
openssl genrsa -out $CLIENT.key

# create the CSR(Certitificate Signing Request)
openssl \
  req \
  -new \
  -nodes \
  -subj "/CN=$CLIENT/OU=$GROUP/O=$CORPORATION/L=$CITY/ST=$STATE/C=$COUNTRY/emailAddress=$CLIENT@$SERVER" \
  -sha256 \
  -config ./openssl.cnf \
  -extensions v3_client \
  -key $CLIENT.key \
  -out $CLIENT.csr \

# sign the certificate with the certificate authority
openssl \
  x509 \
  -req \
  -days 36500 \
  -in $CLIENT.csr \
  -CA $CA.ca.crt \
  -CAkey $CA.ca.key \
  -CAcreateserial \
  -out $CLIENT.crt \
  -extfile ./openssl.cnf \
  -extensions v3_client

