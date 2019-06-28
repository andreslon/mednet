FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["Mednet.App/Mednet.App.csproj", "Mednet.App/"]
RUN dotnet restore "Mednet.App/Mednet.App.csproj"
COPY . .
WORKDIR "/src/Mednet.App"
RUN dotnet build "Mednet.App.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Mednet.App.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Mednet.App.dll"]
