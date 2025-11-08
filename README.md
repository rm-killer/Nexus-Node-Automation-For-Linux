# Nexus Automation for Linux

This script automates the process of running multiple Nexus nodes on a Linux environment, using `tmux` to create a new session with a window for each node. This provides an organized and efficient way to manage multiple nodes.

---

## Prerequisites

Before you begin, you will need to have the following installed and configured:

1.  **Linux Environment:** A running Linux distribution (e.g., Ubuntu, Debian, CentOS).
    *   **Guide:** [WSL/Ubuntu Installation Guide](https://github.com/rm-killer/WSL-Ubuntu-Installation-Guide)

2.  **Nexus Node:** You must have the Nexus node software installed and configured.
    *   **Guide:** [Nexus Node installation guide](https://github.com/rm-killer/Nexus-Node-installation-guide)

3.  **tmux:** This script requires `tmux` to be installed. You can install it on Debian-based distributions (like Ubuntu) with the following command:
    ```bash
    sudo apt update && sudo apt install tmux
    ```

## How to Download

1.  Go to the main page of this repository on GitHub.
2.  Click the green `<> Code` button.
3.  Click **Download ZIP**.
4.  Extract the ZIP file to a location of your choice on your computer.

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
The script will then read the commands from `commands.txt` and open a new `tmux` session, with each command running in a separate window (tab).

### How the Script Works

The script is designed to be interactive and user-friendly. Here's a breakdown of what it does:

1.  **Tmux Detection:** It first checks if `tmux` is installed on your system. If not, it will provide you with the command to install it.

2.  **User Selection:** To enhance security, the script doesn't just run as the current user. Instead, it scans for all valid user accounts on the system and asks you to choose which user you'd like to run the Nexus nodes as.

3.  **Command File:** It will ask you for the name of the file containing your Nexus commands. By default, it looks for `commands.txt`. If this file doesn't exist, the script will create it for you and then exit, allowing you to add your commands before running it again.

4.  **Execution Delay:** You will be prompted to enter a delay (in seconds) that the script will wait between launching each node. This can be helpful to prevent all nodes from starting at the exact same time. The default is 3 seconds.

5.  **Tmux Session Management:** The script creates a `tmux` session named `nexus_nodes`. If a session with this name is already running, the script will attach to it and add the new nodes as new windows. This allows you to stop and start the script without losing your running nodes.

6.  **Command Execution:** For each command in your file, the script does the following:
    *   It cleans the command to remove any hidden Windows characters, which prevents errors if you edit the file on a Windows machine.
    *   It opens a new `tmux` window (like a tab) named `node_1`, `node_2`, and so on.
    *   It runs your command inside an interactive shell, which ensures that your user's `.bashrc` file is loaded correctly. This is important so that the `nexus-network` command can be found.
    *   The `exec bash` command keeps the window open after your Nexus node command finishes, so you can see any output or errors.

7.  **Attach Instructions:** Once all commands have been launched, the script will print a final message telling you exactly how to attach to your `tmux` session to view and interact with your running nodes.

## Using Tmux

`tmux` uses a prefix key combination, which is `Ctrl+B` by default. To issue a command, you press the prefix and then the command key.

Here are some essential shortcuts to get you started:

*   `Ctrl+B` `d`: Detach from the current session (the nodes will keep running in the background).
*   `tmux attach`: Re-attach to the last session.
*   `Ctrl+B` `c`: Create a new window (tab).
*   `Ctrl+B` `n`: Move to the next window.
*   `Ctrl+B` `p`: Move to the previous window.
*   `Ctrl+B` `&`: Close the current window.
*   `Ctrl+B` `?`: View all keybindings.
