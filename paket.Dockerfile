FROM dcurylo/fsharp-mono-netcore-sdk:1.0.1
LABEL maintainer "Dave Curylo <dave@curylo.org>"
RUN wget https://github.com/fsprojects/Paket/releases/download/5.124.0/paket.exe \ 
    && chmod a+r paket.exe && mv paket.exe /usr/local/lib/ \ 
    && printf '#!/bin/sh\nexec /usr/bin/mono /usr/local/lib/paket.exe "$@"' >> /usr/local/bin/paket \ 
    && chmod u+x /usr/local/bin/paket
ENTRYPOINT ["paket"]