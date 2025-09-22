#!/bin/zsh

# ./create-server-cert.sh wps-psc.dmp.monespacesante.fr www.x.org

set -euo pipefail

if (( $# < 1 )); then
echo "Usage: $0 domain1 [domain2 ... domainN]"
echo "Génère cert.pem et key.pem avec CN www.fenyo.net et SANs correspondant aux domaines fournis."
exit 1
fi

DOMAINS=("$@")

VALID_DAYS=${VALID_DAYS:-365}  # durée de validité en jours (par défaut 365)

WORKDIR=/tmp/create-server-cert
mkdir -p $WORKDIR
KEY_FILE="$WORKDIR/key.pem"
CSR_FILE="$WORKDIR/csr.pem"
CERT_FILE="$WORKDIR/cert.pem"
OPENSSL_CONFIG="$WORKDIR/openssl.cnf"

ALTNAMES=""
idx=1
for d in "${DOMAINS[@]}"; do
if [[ -n "$d" ]]; then
ALTNAMES+="DNS.$idx = $d"$'\n'
((idx++))
fi
done

cat > "$OPENSSL_CONFIG" <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = req_dn
req_extensions = v3_req

[ req_dn ]
CN = www.fenyo.net

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
$ALTNAMES
EOF

openssl genrsa -out "$KEY_FILE" 2048

openssl req -new -key "$KEY_FILE" -out "$CSR_FILE" -config "$OPENSSL_CONFIG"

openssl x509 -req -in "$CSR_FILE" -signkey "$KEY_FILE" -out "$CERT_FILE" -days "$VALID_DAYS" -extfile "$OPENSSL_CONFIG" -extensions v3_req

OUTPUT_CERT="$(pwd)/certs/server-cert.pem"
OUTPUT_KEY="$(pwd)/certs/server-key.pem"

cp "$CERT_FILE" "$OUTPUT_CERT"
cp "$KEY_FILE" "$OUTPUT_KEY"

rm -rf "$WORKDIR"

echo "Certificat écrit : $OUTPUT_CERT"
echo "Clé privée écrite : $OUTPUT_KEY"
echo "CN utilisé : www.fenyo.net"
echo "SAN: ${DOMAINS[*]}"

