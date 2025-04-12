# Project Work App Stack Launcher

This repository contains a Docker Compose setup for running the App stack, which includes:

- Laravel API Backend
- React Frontend
- MySQL Database

## Requirements

- Docker and Docker Compose (if not installed: https://medium.com/@piyushkashyap045/comprehensive-guide-installing-docker-and-docker-compose-on-windows-linux-and-macos-a022cf82ac0b)
- Git
- Bash shell (included in macOS and Linux, use Git Bash on Windows)

## Getting Started

### 1. Clone the necessary repositories

```bash
# Create a directory for the projects
mkdir ProjectWork
cd ProjectWork

# Clone the launcher
git clone https://github.com/MikeZ2001/ProjectWork-Launcher.git

# Clone the BE and FE components
git clone https://github.com/MikeZ2001/ProjectWork-FE.git
git clone https://github.com/MikeZ2001/ProjectWork-BE.git
```

Your directory structure should look like this:
```
ProjectWork/
├── ProjectWork-Launcher/  # Docker setup and scripts
├── ProjectWork-BE/       # Laravel backend
└── ProjectWork-FE/       # React frontend
```

### 2. Make the launcher script executable

```bash
cd ProjectWork-Launcher
chmod +x launcher.sh
```

### 3. Start the stack

```bash
./launcher.sh start
```

### 4. Set up the application

```bash
./launcher.sh setup
```

This will:
- Install dependencies
- Run database migrations
- Create Passport clients for authentication
- Seed the database with sample data

### 5. Access the application

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000/api

## Usage

The launcher script provides several commands:

- `./launcher.sh start` - Start the App stack
- `./launcher.sh stop` - Stop the App stack
- `./launcher.sh restart` - Restart the App stack
- `./launcher.sh logs` - View logs from all services
- `./launcher.sh logs api|frontend|db` - View logs from a specific service (api, frontend, db)
- `./launcher.sh status` - Show status of App stack
- `./launcher.sh clean` - Remove all containers, networks, and volumes (WARNING: Data will be lost)
- `./launcher.sh setup` - Set up the App stack (run migrations, seeders, etc.)
- `./launcher.sh help` - Display help message

## Sample User

A sample user is created during setup that you can use to log in:

- Email: john.doe@example.com
- Password: password

Other sample users:
- Email: admin@example.com / Password: password (admin role)
- Email: operator@example.com / Password: password (operator role)

## License

MIT 