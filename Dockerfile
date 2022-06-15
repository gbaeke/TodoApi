FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base

ARG BUILDCONFIG=RELEASE
ARG VERSION=1.0.0



WORKDIR /TodoApi

# copy csproj
COPY ./TodoApi.csproj .

RUN dotnet restore TodoApi.csproj

# copy the rest and build
COPY . .

# publish with trimming
RUN dotnet publish TodoApi.csproj --self-contained --runtime linux-x64 -c $BUILDCONFIG -o /out /p:Version=$VERSION -p:PublishTrimmed=true

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-bullseye-slim
ENV COMPlus_EnableDiagnostics=0
WORKDIR /app
COPY --from=base /out .

ENTRYPOINT ["/app/TodoApi"]
