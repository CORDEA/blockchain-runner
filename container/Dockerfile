FROM nim:0.17.2

MAINTAINER Yoshihiro Tanaka <contact@cordea.jp>


RUN \
        apk add --no-cache curl && \
        apk add --no-cache --virtual=.build-dependencies wget git && \
        nimble install -y "nimsha2" "websocket@#head" && \
        wget "https://github.com/CORDEA/blockchain/archive/master.tar.gz" -O - | tar xz && \
        cd "./blockchain-master/" && \
        nim c -d:ssl blockchain.nim && \
        apk del .build-dependencies

CMD ./blockchain-master/blockchain
