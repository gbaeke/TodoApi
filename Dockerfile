FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base

ARG BUILDCONFIG=RELEASE
ARG VERSION=1.0.0
WORKDIR /TodoApi

# dotnet restore
COPY ./TodoApi.csproj .
RUN dotnet restore TodoApi.csproj

# dotnet publish with trimming and single file
COPY . .
RUN dotnet publish TodoApi.csproj --self-contained --runtime linux-musl-x64 -c $BUILDCONFIG -o /out /p:Version=$VERSION -p:PublishTrimmed=true -p:PublishSingleFile=true

# final stage based on Alpine Linux
FROM mcr.microsoft.com/dotnet/runtime-deps:3.1-alpine
ENV COMPlus_EnableDiagnostics=0
WORKDIR /app

RUN addgroup -S todogroup && \     
    adduser --uid 10000 -S todouser

COPY --chown=todouser:todogroup --from=base /out .

USER 10000

ENTRYPOINT ["/app/TodoApi"]
