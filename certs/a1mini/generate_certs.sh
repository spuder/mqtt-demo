#!/bin/bash

# Variables
CA_KEY="ca.pem"
CA_CERT="ca.crt"
SERVER_KEY="server.pem"
SERVER_CERT="server.crt"
CERT_CHAIN="cert_chain.pem"
CA_DAYS_VALID=3650  # 10 years for CA
SERVER_DAYS_VALID=3650  # 10 years for the server cert
SERIAL=01

# Step 1: Generate CA private key and certificate
openssl genpkey -algorithm RSA -out $CA_KEY -pkeyopt rsa_keygen_bits:2048
openssl req -new -x509 -key $CA_KEY -sha256 -days $CA_DAYS_VALID -out $CA_CERT \
-subj "/C=CN/O=BBL Technologies Co., Ltd/CN=BBL CA" \
-sigopt rsa_padding_mode:pkcs1

# Step 2: Generate server private key
openssl genpkey -algorithm RSA -out $SERVER_KEY -pkeyopt rsa_keygen_bits:2048

# Step 3: Create the server certificate request (CSR)
openssl req -new -key $SERVER_KEY -out server.csr \
-subj "/CN=testprinter1"

# Step 4: Sign the server certificate with the CA using RSA-SHA256 (PKCS#1)
openssl x509 -req -in server.csr -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial \
-out $SERVER_CERT -days $SERVER_DAYS_VALID -sha256 -set_serial $SERIAL \
-sigopt rsa_padding_mode:pkcs1

# Step 5: Create the certificate chain
cat $SERVER_CERT $CA_CERT > $CERT_CHAIN

# Clean up the CSR as it is not needed anymore
rm server.csr

echo "Certificate chain generation complete!"
