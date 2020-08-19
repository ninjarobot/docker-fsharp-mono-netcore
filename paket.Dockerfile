FROM fsharp:10.6.0-netcore
LABEL maintainer="Dave Curylo <dave@curylo.org>"
RUN apt-get update \ 
    && apt-get --no-install-recommends install -y wget \ 
    && wget https://github.com/fsprojects/Paket/releases/download/6.0.0.alpha042/paket.exe \ 
    && rm -rf /var/lib/apt/lists/* \ 
    && chmod a+r paket.exe && mv paket.exe /usr/local/lib/ \ 
    && printf '#!/bin/sh\nexec /usr/bin/mono /usr/local/lib/paket.exe "$@"' >> /usr/local/bin/paket \ 
    && chmod u+x /usr/local/bin/paket
ENTRYPOINT ["paket"]