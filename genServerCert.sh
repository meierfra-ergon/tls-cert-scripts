#https://stackoverflow.com/questions/6194236/openssl-certificate-version-3-with-subject-alternative-name

SERVER="${1:-localhost}"
CA="${2:-root}"

CORPORATION=Ergon
GROUP=Airlock
CITY=Zurich
STATE=Zurich
COUNTRY=CH

cd "$(dirname "$0")"

# create client private key (used to decrypt the cert we get from the CA)
openssl genrsa -out $SERVER.key

# create the CSR(Certitificate Signing Request)
openssl \
  req \
  -new \
  -nodes \
  -subj "/CN=$SERVER/OU=$GROUP/O=$CORPORATION/L=$CITY/ST=$STATE/C=$COUNTRY" \
  -sha256 \
  -extensions v3_req \
  -reqexts SAN \
  -key $SERVER.key \
  -out $SERVER.csr \
  -config <(cat ./openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:$SERVER"))

# sign the certificate with the certificate authority
openssl \
  x509 \
  -req \
  -days 36500 \
  -in $SERVER.csr \
  -CA $CA.ca.crt \
  -CAkey $CA.ca.key \
  -CAcreateserial \
  -out $SERVER.crt \
  -extfile <(cat ./openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:$SERVER")) \
  -extensions SAN

