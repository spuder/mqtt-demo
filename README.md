# MQTT-Demo

Spin up multiple mqtt servers on localhost using various TLS certs

Used to troubleshoot issue with esphome mqtt library not accepting certain TLS certs


| Port | TLS |
| --- | --- |
| 1883 | No TLS |
| 8883 | TLS (Generic) |
| 9993 | TLS (BambuLabs) |

The generic certs have a 
The BambuLabs certs only have `CN` as part of the Distinguished Name


```bash
Certificate chain
 0 s:C=US, ST=State, L=City, O=3DPrinters, CN=printer1
   i:C=US, ST=State, L=City, O=Example, CN=example.com
   a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
   v:NotBefore: Oct  4 21:10:34 2024 GMT; NotAfter: Oct  2 21:10:34 2034 GMT
```
```bash
Certificate chain
 0 s:CN=01P00A442000276
   i:C=CN, O=BBL Technologies Co., Ltd, CN=BBL CA
   a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
   v:NotBefore: Oct 11 16:44:40 2024 GMT; NotAfter: Oct  9 16:44:40 2034 GMT
```


## Usage

Start docker containers with docker compose or podman compose
```bash
podman compose up -d
nc -vz 127.0.0.1 1883
nc -vz 127.0.0.1 8883
nc -vz 127.0.0.1 9993
```

Connect with mqttx or other mqtt client to verify mqtt server is running


#### 1883 (No TLS)
```bash
mqttx conn -u bblp -P 12345678 --mqtt-version 3.1.1 -h 127.0.0.1 -p 1883 -l mqtt
```

#### 8883 (TLS)
```bash
IP="127.0.0.1"
PORT=8883
USER=bblp
PASS=12345678
openssl s_client -connect $IP:$PORT -showcerts < /dev/null 2>/dev/null 
mqttx conn -u $USER -P $PASS --mqtt-version 3.1.1 -h $IP -p $PORT -l mqtts --insecure
```

#### 8883 (BambuLabs TLS)
```bash
IP="127.0.0.1"
PORT=9993
USER=bblp
PASS=12345678
openssl s_client -connect $IP:$PORT -showcerts < /dev/null 2>/dev/null 
mqttx conn -u $USER -P $PASS --mqtt-version 3.1.1 -h $IP -p $PORT -l mqtts --insecure
```


### Passwords

The default username/password is `bblp` and `12345678`
To change the password

```bash
podman compose exec mqtt-broker /bin/sh 
mosquitto_passwd /etc/mosquitto/password_file bblp
Password: 
Reenter password: 
```
