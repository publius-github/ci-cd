FROM microsoft/dotnet:2.2-sdk as build

WORKDIR /build

COPY . /build

RUN dotnet restore TODO/HOWTO.csproj
RUN dotnet build TODO/HOWTO.csproj
RUN dotnet publish TODO/HOWTO.csproj -c Release 

# -----------------

FROM microsoft/aspnetcore:1.1.12

COPY --from=build --chown=nobody:nogroup ./build/TODO/bin/Release/netcoreapp1.1/publish ./app

USER nobody

WORKDIR /app

EXPOSE 5000

CMD ["dotnet", "HOWTO.dll"]