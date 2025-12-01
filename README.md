# Flutter Development Environment Docker

A Docker-based development environment for Flutter applications. This setup provides a consistent, reproducible development environment across different machines.

## Features

- **Flutter SDK**: Pre-installed Flutter SDK (stable channel by default)
- **Web Development**: Ready for Flutter web development
- **Linux Desktop**: Support for building Flutter Linux desktop applications
- **Non-root User**: Runs as a non-root user for better security
- **Volume Persistence**: Pub cache is persisted for faster dependency resolution

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/) (optional, but recommended)

## Quick Start

### Using Docker Compose (Recommended)

1. Clone this repository:
   ```bash
   git clone https://github.com/rrjorgegz/flutter-dev-environment-docker.git
   cd flutter-dev-environment-docker
   ```

2. Create an `app` directory for your Flutter project:
   ```bash
   mkdir -p app
   ```

3. Build and start the container:
   ```bash
   docker-compose up -d --build
   ```

4. Access the container:
   ```bash
   docker-compose exec flutter bash
   ```

5. Inside the container, create a new Flutter project or work with an existing one:
   ```bash
   flutter create my_app
   cd my_app
   flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
   ```

### Using Docker Directly

1. Build the image:
   ```bash
   docker build -t flutter-dev-environment .
   ```

2. Run a container:
   ```bash
   docker run -it --rm \
     -v $(pwd)/app:/app \
     -p 8080:8080 \
     -p 9100:9100 \
     flutter-dev-environment bash
   ```

## Configuration

### Build Arguments

You can customize the build using build arguments:

| Argument | Default | Description |
|----------|---------|-------------|
| `FLUTTER_VERSION` | `stable` | Flutter SDK version - can be a channel (stable, beta, master) or a specific version tag (e.g., 3.16.0) |
| `USER_ID` | `1000` | User ID for the non-root user |
| `GROUP_ID` | `1000` | Group ID for the non-root user |

Example with a specific Flutter version:
```bash
docker build --build-arg FLUTTER_VERSION=3.16.0 -t flutter-dev-environment .
```

Example with beta channel:
```bash
docker build --build-arg FLUTTER_VERSION=beta -t flutter-dev-environment .
```

### Environment Variables for Docker Compose

You can set the following environment variables before running docker-compose:

```bash
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
docker-compose up -d --build
```

## Usage Examples

### Create a New Flutter Project

```bash
docker-compose exec flutter bash
flutter create my_app
cd my_app
```

### Run Flutter Web Application

```bash
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

Then access your app at `http://localhost:8080`

### Run Flutter Doctor

```bash
docker-compose exec flutter flutter doctor
```

### Build Flutter Web Application

```bash
flutter build web
```

### Run Tests

```bash
flutter test
```

## Port Mappings

| Port | Description |
|------|-------------|
| 8080 | Flutter web server |
| 9100 | Flutter DevTools |

## File Structure

```
flutter-dev-environment-docker/
├── Dockerfile           # Docker image definition
├── docker-compose.yml   # Docker Compose configuration
├── app/                 # Mount point for Flutter projects (create this)
├── README.md            # This file
├── LICENSE              # GPL v3 License
└── .gitignore           # Git ignore patterns
```

## Troubleshooting

### Permission Issues

If you encounter permission issues with mounted volumes, make sure to set the correct USER_ID and GROUP_ID:

```bash
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
docker-compose up -d --build
```

### Flutter Doctor Issues

Run `flutter doctor` inside the container to diagnose issues:

```bash
docker-compose exec flutter flutter doctor -v
```

### Clear Pub Cache

If you have dependency issues, try clearing the pub cache:

```bash
docker-compose exec flutter flutter pub cache clean
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
