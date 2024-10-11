#!/bin/bash

# Variables
CA_KEY="ca-key.pem"
CA_CERT="ca-cert.crt"
PRINTER_KEY="printer1-key.pem"
PRINTER_CERT="printer1-cert.crt"
DAYS_VALID=3650

# Step 1: Generate CA private key
openssl genpkey -algorithm RSA -out $CA_KEY

# Step 2: Create CA certificate
openssl req -new -x509 -key $CA_KEY -sha256 -days $DAYS_VALID -out $CA_CERT \
    -subj "/C=US/ST=State/L=City/O=Example/CN=example.com"

# Step 3: Generate printer1 private key
openssl genpkey -algorithm RSA -out $PRINTER_KEY

# Step 4: Directly sign the printer1 key with the CA, creating a certificate
openssl req -new -key $PRINTER_KEY -out /dev/null -x509 -days $DAYS_VALID \
    -subj "/C=US/ST=State/L=City/O=3DPrinters/CN=printer1" \
    -set_serial 01 -CA $CA_CERT -CAkey $CA_KEY -out $PRINTER_CERT

echo "CA and Printer1 certificate generation complete!"
