FROM microsoft/dotnet:2.0.4-sdk-2.1.3-jessie
LABEL maintainer "Dave Curylo <dave@curylo.org>"
ENV MONO_THREADS_PER_CPU 50
RUN MONO_VERSION=5.4.1.6 && \
    FSHARP_VERSION=4.1.29 && \
    FSHARP_PREFIX=/usr && \
    FSHARP_GACDIR=/usr/lib/mono/gac && \
    FSHARP_BASENAME=fsharp-$FSHARP_VERSION && \
    FSHARP_ARCHIVE=$FSHARP_VERSION.tar.gz && \
    FSHARP_ARCHIVE_URL=https://github.com/fsharp/fsharp/archive/$FSHARP_VERSION.tar.gz && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list && \
    apt-get update -y && \
    apt-get --no-install-recommends install -y autoconf libtool pkg-config make automake nuget mono-devel msbuild ca-certificates-mono && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    printf "namespace a { class b { public static void Main(string[] args) { new System.Net.WebClient().DownloadFile(\"%s\", \"%s\");}}}" $FSHARP_ARCHIVE_URL $FSHARP_ARCHIVE > download-fsharp.cs && \
    mcs download-fsharp.cs && mono download-fsharp.exe && rm download-fsharp.exe download-fsharp.cs && \
    tar xf $FSHARP_ARCHIVE && \
    cd $FSHARP_BASENAME && \
    ./autogen.sh --prefix=$FSHARP_PREFIX --with-gacdir=$FSHARP_GACDIR && \
    make && \
    make install && \
    cd ~ && \
    rm -rf /tmp/src /tmp/NuGetScratch ~/.nuget ~/.config ~/.local && \
    apt-get purge -y autoconf libtool make automake && \
    apt-get clean
    
RUN apt-get update \
  && apt-get install -y locales \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen
    
WORKDIR /root
ENV FrameworkPathOverride /usr/lib/mono/4.5/
CMD ["fsharpi"]
