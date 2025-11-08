#!/bin/bash

# =============================================================
# TMUX Node Runner
# This script runs commands from a text file, each in its own
# tmux "window" (tab), as a selected user.
# =============================================================

# Define colors for output
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

clear
echo -e "${CYAN}===============================================${RESET}"
echo -e "${CYAN}   TMUX Command Runner (Ubuntu Version)   ${RESET}"
echo -e "${CYAN}===============================================${RESET}\n"

# 1. Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo -e "${RED}Error: 'tmux' is not installed.${RESET}"
    echo -e "${YELLOW}Please install it by running:${RESET} sudo apt update && sudo apt install tmux"
    exit 1
fi

# 2. Get WSL Users
echo -e "${GREEN}Detecting users...${RESET}"
# We use the same 'awk' command that we fought for, which works perfectly here.
user_list=$(awk -F: '($3 >= 1000 || $3 == 0) && $1 != "nobody" {print $1}' /etc/passwd)
mapfile -t users <<< "$user_list" # Read the list into a bash array

if [ ${#users[@]} -eq 0 ]; then
    echo -e "${RED}Error: No valid users found.${RESET}"
    exit 1
fi

# 3. Select User
echo -e "\n${YELLOW}Available users found:${RESET}"
for i in "${!users[@]}"; do
    echo -e "  [${CYAN}$((i+1))${RESET}] ${users[$i]}"
done

while true; do
    read -p $'\nEnter the number of the user to run as: ' selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#users[@]}" ]; then
        selected_user="${users[$((selection-1))]}"
        break
    else
        echo -e "${RED}Invalid selection. Please try again.${RESET}"
    fi
done

echo -e "\nWill run commands as user: ${GREEN}${selected_user}${RESET}"

# 4. Get User Inputs (File and Delay)
read -p $'\nEnter the name of the command file (default: commands.txt): ' command_file
command_file="${command_file:-commands.txt}"

# Check if command file exists. If not, create it and exit.
if [ ! -f "$command_file" ]; then
    echo -e "\n${YELLOW}Warning: File '${command_file}' not found.${RESET}"
    echo -e "${GREEN}Creating an empty file named '${command_file}' for you...${RESET}"
    touch "$command_file"
    echo -e "${YELLOW}Please add your commands (one per line) to '${command_file}' and run this script again.${RESET}"
    exit 1
fi

while true; do
    read -p $'\nEnter the delay in seconds between commands (default: 3): ' delay
    delay="${delay:-3}"
    if [[ "$delay" =~ ^[0-9]+$ ]]; then
        break
    else
        echo -e "${RED}Invalid input. Please enter a non-negative number.${RESET}"
    fi
done

# 5. Read Commands
mapfile -t commands < "$command_file"
if [ ${#commands[@]} -eq 0 ]; then
    echo -e "${RED}Error: No commands found in ${command_file}.${RESET}"
    echo -e "${YELLOW}Please add commands to the file and run again.${RESET}"
    exit 1
fi

echo -e "\nFound ${CYAN}${!commands[@]}${RESET} command(s) to execute."
echo -e "Delay between commands: ${CYAN}${delay}${RESET} second(s)"
echo -e "\n${YELLOW}Starting execution in 3 seconds...${RESET}"
sleep 3

# 6. Execute Commands in TMUX
session_name="nexus_nodes" # Set static session name
i=0 # Initialize counter for node naming

# Check if the session already exists
tmux has-session -t "$session_name" 2>/dev/null
if [ $? -eq 0 ]; then
    # Session exists. All commands will be new windows.
    first_command=0
    echo -e "${YELLOW}Attaching to existing session '${session_name}' and adding new nodes...${RESET}\n"
    # Get the number of existing windows to start our counter
    i=$(tmux list-windows -t "$session_name" | wc -l)
else
    # Session does not exist. The first command will create it.
    first_command=1
    echo -e "${GREEN}Creating new session '${session_name}'...${RESET}\n"
fi

for command in "${commands[@]}"; do
    # *** THIS IS THE FIX ***
    # Strip the invisible Windows carriage return character (\r)
    command=$(echo "$command" | tr -d '\r')

    # Skip empty lines
    if [ -z "$command" ]; then
        continue
    fi
    
    i=$((i+1)) # Increment counter
    
    # We use 'bash -i -c "command; exec bash"'
    # This is the exact same logic as our Python script:
    # -i : Loads .bashrc to find the PATH (for 'nexus-network')
    # -c : Runs the command
    # exec bash: Keeps the "tab" open after the command finishes
    full_bash_command="bash -i -c '${command}; exec bash'"

    if [ $first_command -eq 1 ]; then
        echo -e "[${i}/${#commands[@]}] Launching: ${command}"
        # This is the user-selection fix. We run tmux as the selected user.
        sudo -u "${selected_user}" tmux new-session -d -s "${session_name}" -n "node_${i}" "${full_bash_command}"
        first_command=0 # All subsequent commands are new windows
    else
        echo -e "[${i}/${#commands[@]}] Launching: ${command}"
        # Only sleep *after* the first command (if it was just created)
        # or between all commands if we're attaching to an existing session.
        if [ $i -gt 1 ] || [ $first_command -eq 0 ]; then
            echo -e "    ... waiting ${delay} second(s)..."
            sleep "$delay"
        fi
        
        # Add a new "window" (tab) to the existing session
        sudo -u "${selected_user}" tmux new-window -t "${session_name}" -n "node_${i}" "${full_bash_command}"
    fi
done

echo -e "\n${GREEN}===============================================${RESET}"
echo -e "${GREEN}Execution complete!${RESET}"
echo -e "All commands are running in tmux session: ${CYAN}${session_name}${RESET}"
echo -e "\nTo view your nodes, attach to the session by running:"
echo -e "${YELLOW}tmux attach -t ${session_name}${RESET}"
echo -e "${GREEN}===============================================${RESET}"

