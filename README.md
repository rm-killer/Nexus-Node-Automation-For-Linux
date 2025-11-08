# Nexus Automation for Linux

This script automates the process of running multiple Nexus nodes on a Linux environment.

---

## Prerequisites

Before you begin, you will need to have the following installed and configured:

1.  **Linux Environment:** A running Linux distribution (e.g., Ubuntu, Debian, CentOS).
2.  **Nexus Node:** You must have the Nexus node software installed and configured.

## How to Use

1.  **Add your node commands to the `commands.txt` file.** Open the `commands.txt` file and add your `nexus-network start` commands. Each line in this file represents a new Nexus node that will be launched in its own terminal tab.

    For example:
    ```
    nexus-network start --node-id "YOUR_NODE_ID_1"
    nexus-network start --node-id "YOUR_NODE_ID_2"
    ```
    Replace `"YOUR_NODE_ID_1"`, `"YOUR_NODE_ID_2"`, etc., with your actual Nexus node IDs.

2.  **Open a terminal** in the folder where you have the script.

3.  **Make the script executable:**
    ```bash
    chmod +x nexus_automation.sh
    ```

4.  **Run the script:**
    ```bash
    ./nexus_automation.sh
    ```
The script will then read the commands from `commands.txt` and open a new terminal tab for each command, executing the command in it.
