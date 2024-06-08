#https://stackoverflow.com/questions/6194236/openssl-certificate-version-3-with-subject-alternative-name

CA="${1:-root}"

CORPORATION=Ergon
GROUP=Airlock
CITY=Zurich
STATE=Zurich
COUNTRY=CH

cd "$(dirname "$0")"

openssl genrsa -out $CA.ca.key

# create the certificate authority
openssl \
  req \
  -config ./openssl.cnf \
  -subj "/CN=$CA.ca/OU=$GROUP/O=$CORPORATION/L=$CITY/ST=$STATE/C=$COUNTRY" \
  -new \
  -x509 \
  -key $CA.ca.key \
  -out $CA.ca.crt \
  -extensions v3_ca \
  -days 36500

