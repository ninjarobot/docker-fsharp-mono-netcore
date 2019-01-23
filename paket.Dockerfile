FROM dcurylo/fsharp-mono-netcore:2.1.503
LABEL maintainer="Dave Curylo <dave@curylo.org>"
RUN wget https://github.com/fsprojects/Paket/releases/download/5.195.7/paket.exe \ 
    && chmod a+r paket.exe && mv paket.exe /usr/local/lib/ \ 
    && printf '#!/bin/sh\nexec /usr/bin/mono /usr/local/lib/paket.exe "$@"' >> /usr/local/bin/paket \ 
    && chmod u+x /usr/local/bin/paket
ENTRYPOINT ["paket"]
