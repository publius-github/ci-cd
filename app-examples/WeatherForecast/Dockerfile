FROM microsoft/dotnet:2.2-sdk as build

WORKDIR /build

COPY . /build

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \ 
	&& apt update \
	&& apt install -y nodejs

RUN dotnet restore app-examples/WeatherForecast/WeatherForecast/WeatherForecast.csproj
RUN dotnet build app-examples/WeatherForecast/WeatherForecast/WeatherForecast.csproj
RUN dotnet publish app-examples/WeatherForecast/WeatherForecast/WeatherForecast.csproj -c Release 

# -----------------

# FROM microsoft/aspnetcore:1.1.12
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2

COPY --from=build ./build/app-examples/WeatherForecast/WeatherForecast/bin/Release/netcoreapp2.2/publish /app

WORKDIR /app

EXPOSE 5001

CMD ["dotnet", "WeatherForecast.dll"]