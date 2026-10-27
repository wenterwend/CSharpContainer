# Stage 1: Base runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Install curl in the base image so Docker Compose health checks can execute
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
USER $APP_UID

# Stage 2: SDK build environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DemoApi.csproj", "./"]
RUN dotnet restore "./DemoApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./DemoApi.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Stage 3: Publish application
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./DemoApi.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Stage 4: Final production container
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DemoApi.dll"]
