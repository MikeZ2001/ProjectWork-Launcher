#!/bin/bash

# Set script to exit immediately if a command exits with a non-zero status
set -e

# Define colors for better readability
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Define the App BE and FE
API_DIR="../ProjectWork-BE"
FRONTEND_DIR="../ProjectWork-FE"

# Display header
display_header() {
    echo "================================================"
    echo "       🚀  App Stack Launcher 🚀         "
    echo "================================================"
    echo
}

# Check if Docker is running
check_docker() {
    echo "Checking if Docker is running..."
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ Docker is running.${NC}"
        echo
    fi
}

# Function to display help
show_help() {
    echo -e "Usage: $0 [OPTION]"
    echo -e "Launch and manage the App stack."
    echo
    echo -e "Options:"
    echo -e "  ${GREEN}start${NC}       Start the entire stack"
    echo -e "  ${GREEN}stop${NC}        Stop the entire stack"
    echo -e "  ${GREEN}restart${NC}     Restart the entire stack"
    echo -e "  ${GREEN}logs${NC}        View logs from all services"
    echo -e "  ${GREEN}status${NC}      Check status of all containers"
    echo -e "  ${GREEN}clean${NC}       Remove all containers, networks, and volumes"
    echo -e "  ${GREEN}setup${NC}       Perform initial setup (migrations, seeders, etc.)"
    echo -e "  ${GREEN}help${NC}        Display this help message"
    echo
    echo -e "Examples:"
    echo -e "  $0 start     # Start the App stack"
    echo -e "  $0 logs      # View logs from all services"
    echo
}

# Function to start the stack
start_stack() {
    echo -e "${YELLOW}Starting the App stack...${NC}"
    docker compose up -d
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ App stack is now running!${NC}"
        echo
        show_access_info
    else
        echo -e "${RED}❌ Failed to start App stack.${NC}"
        exit 1
    fi
}

# Function to stop the stack
stop_stack() {
    echo -e "${YELLOW}Stopping the App stack...${NC}"
    docker compose down
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ App stack has been stopped.${NC}"
    else
        echo -e "${RED}❌ Failed to stop App stack.${NC}"
        exit 1
    fi
}

# Function to restart the stack
restart_stack() {
    echo -e "${YELLOW}Restarting the App stack...${NC}"
    docker compose down
    docker compose up -d
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ App stack has been restarted!${NC}"
        echo
        show_access_info
    else
        echo -e "${RED}❌ Failed to restart App stack.${NC}"
        exit 1
    fi
}

# Function to view logs
view_logs() {
    echo -e "${YELLOW}Viewing logs from all services...${NC}"
    echo -e "${YELLOW}Press Ctrl+C to exit logs.${NC}"
    echo
    
    # Check if a specific service was specified
    if [ -z "$1" ]; then
        docker compose logs -f
    else
        docker compose logs -f "$1"
    fi
}

# Function to show stack status
show_status() {
    echo -e "${YELLOW}Checking status of App stack...${NC}"
    docker compose ps
}

# Function to clean everything
clean_stack() {
    echo -e "${YELLOW}This will remove all containers, networks, and volumes associated with the App stack.${NC}"
    echo -e "${RED}Warning: All data will be lost!${NC}"
    read -p "Are you sure you want to continue? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cleaning up App stack...${NC}"
        docker compose down -v
        echo -e "${GREEN}✅ Finance App stack has been completely cleaned.${NC}"
    else
        echo -e "${BLUE}Operation canceled.${NC}"
    fi
}

# Function to setup the stack
setup_stack() {
    echo -e "${GREEN}Setting up the App stack...${NC}"
    
    echo -e "${YELLOW}Waiting for database to be ready...${NC}"
    sleep 10
    
    echo -e "${YELLOW}Installing Laravel dependencies...${NC}"
    docker exec -it ProjectWork-BE composer install
    
    echo -e "${YELLOW}Generating application key...${NC}"
    docker exec -it ProjectWork-BE php artisan key:generate
    
    echo -e "${YELLOW}Running database migrations...${NC}"
    docker exec -it ProjectWork-BE php artisan migrate:fresh
    
    echo -e "${YELLOW}Creating Passport clients...${NC}"
    docker exec -it ProjectWork-BE php artisan passport:client --personal --name="App Personal Access Client"
    docker exec -it ProjectWork-BE php artisan passport:client --password --name="App Password Grant Client" --provider=users
    
    echo -e "${YELLOW}Seeding database...${NC}"
    docker exec -it ProjectWork-BE php artisan db:seed
    
    echo -e "${GREEN}✅ App stack has been set up!${NC}"
    echo
    show_access_info
}

# Function to show access information
show_access_info() {
    echo -e "${YELLOW}=== Access Information ===${NC}"
    echo -e "Frontend: http://localhost:3000"
    echo -e "Backend API: http://localhost:8000/api"
    echo -e "Sample user for testing:"
    echo -e "  - Email: john.doe@example.com"
    echo -e "  - Password: password"
    echo
}

# Main execution
display_header
check_docker

# Parse command line arguments
case "$1" in
    start)
        start_stack
        ;;
    stop)
        stop_stack
        ;;
    restart)
        restart_stack
        ;;
    logs)
        if [ -n "$2" ]; then
            view_logs "$2"
        else
            view_logs
        fi
        ;;
    status)
        show_status
        ;;
    clean)
        clean_stack
        ;;
    setup)
        setup_stack
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        if [ -z "$1" ]; then
            echo -e "${YELLOW}No option specified. Starting the stack...${NC}"
            echo
            start_stack
        else
            echo -e "${RED}Invalid option: $1${NC}"
            echo
            show_help
            exit 1
        fi
        ;;
esac

exit 0 