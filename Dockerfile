FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["dotnet-webapi.csproj", "./"]
RUN dotnet restore "dotnet-webapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dotnet-webapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet-webapi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-webapi.dll"]
