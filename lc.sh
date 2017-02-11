#!/bin/sh
DOMAIN=$1
FULLCHAIN=$2
PRIVKEY=$3
STOREPASS=$4
OUTDIR=$5
KEYTOOL=/usr/local/jdk/bin/keytool

if [ "$#" -ne 5 ];
then
        echo `basename "$0"` domain.tld fullchain.pem privkey.pem password outdir
else
        rm -f $OUTDIR/$DOMAIN.jks
        $KEYTOOL -import -alias $DOMAIN -keystore $OUTDIR/$DOMAIN.jks -file $FULLCHAIN -storepass $STOREPASS -noprompt
        openssl pkcs12 -export -in $FULLCHAIN -inkey $PRIVKEY -password pass:$STOREPASS > $OUTDIR/$DOMAIN-server.p12
        $KEYTOOL -importkeystore -srckeystore $OUTDIR/$DOMAIN-server.p12 -destkeystore $OUTDIR/$DOMAIN.jks -srcstoretype pkcs12 -storepass $STOREPASS -srcstorepass $STOREPASS
        $KEYTOOL -list -keystore $OUTDIR/$DOMAIN.jks -storepass $STOREPASS
        rm $OUTDIR/$DOMAIN-server.p12
fi