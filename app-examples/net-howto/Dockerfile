FROM microsoft/dotnet:2.2-sdk as build

WORKDIR /build

COPY . /build

RUN dotnet publish TODO/HOWTO.csproj -c Release 

# -----------------

FROM microsoft/dotnet:2.2-aspnetcore-runtime

COPY --from=build --chown=nobody:nogroup ./build/TODO/bin/Release/netcoreapp1.1/publish ./app

USER nobody

WORKDIR /app

EXPOSE 49929

CMD ["dotnet", "HOWTO.dll"]