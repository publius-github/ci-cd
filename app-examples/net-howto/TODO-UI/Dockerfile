FROM microsoft/dotnet:2.2-sdk as build

WORKDIR /build

COPY . /build

RUN dotnet restore app-examples/net-howto/TODO-UI/HOWTO-UI.csproj
RUN dotnet build app-examples/net-howto/TODO-UI/HOWTO-UI.csproj
RUN dotnet publish app-examples/net-howto/TODO-UI/HOWTO-UI.csproj -c Release 

# -----------------

FROM microsoft/aspnetcore:1.1.12

COPY --from=build ./build/app-examples/net-howto/TODO-UI/bin/Release/netcoreapp1.1/publish /app

WORKDIR /app

EXPOSE 80

CMD ["dotnet", "HOWTO-UI.dll"]