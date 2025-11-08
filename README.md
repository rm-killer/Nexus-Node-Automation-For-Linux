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
