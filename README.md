# docker-fsharp-mono-netcore
Docker image for F# with mono and .NET Core toolchains

## Basic use

To simply get an F# interactive prompt run:
```
docker run dcurylo/fsharp-mono-netcore
```

To use the SDK rather than launching F# interactive, append `bash` at the end of the command to start the shell instead.

To mount the current directory within the container so that build artifacts remain after exit:
```
docker run -v `pwd`:/root/src --rm -it dcurylo/fsharp-mono-netcore bash
```

When run as shown above, a new project generated within the container's `/src` directory will exist in the host.
```
cd src
dotnet new console -lang F# -n hello
cd hello
dotnet build
exit
```
After running the above commands and exiting, the newly generated project and build output remains in the working directory on the host.

## Targeting multiple frameworks

Creating a new project and targeting multiple frameworks can be done since the `FrameworkPathOverride` environment variable is set in this image.  This makes the mono framework available to the .NET Core build toolchain.

```
# Generate the project
dotnet new console -lang F# -n hello
cd hello
# Modify the target framework element for multitargeting
sed -i 's#<TargetFramework>netcoreapp2.0</TargetFramework>#<TargetFrameworks>netcoreapp2.0;net462</TargetFrameworks>#g' hello.fsproj
# build for both frameworks
dotnet build
```

Output
```
  hello -> /root/src/hello/bin/Debug/net462/hello.exe
  hello -> /root/src/hello/bin/Debug/netcoreapp2.0/hello.dll
```

## Using the paket image

Given a project directory already exists in a "hello" directory under the current working directory, you can initialize that project with `paket` within the paket image. 
```
docker run -v `pwd`/hello:/root/src/hello dcurylo/paket init
```

Any typical paket options can be passed to the container directly, since `paket` is the entrypoint for this image.
