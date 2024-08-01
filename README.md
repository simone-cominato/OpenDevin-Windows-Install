
2024/06/01

## How to install and run OpenDevin on Windows 11:

1. Install [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).
2. Install [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/).
3. Create a folder named "OpenDevin" (or a name of your choosing) and inside that folder create a folder named "workspace".
4. Inside the "OpenDevin" folder you just created, create a bash script with Unix-style line termination (LF) (do not use Microsoft Notepad...) and name it something like "run_opendevin.sh". The content of the bash script should be as follows:

    ```bash
    WORKSPACE_BASE=$(pwd)/workspace;
    SANDBOX_USER_ID=$(id -u)
    IMAGE_NAME="ghcr.io/opendevin/opendevin:0.8"
    CONTAINER_PORT=3000
    HOST_PORT=3000
    
    # Run the Docker container
    docker run -it \
        --pull=missing \
        -e SANDBOX_USER_ID=$SANDBOX_USER_ID \
        -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
        -v $WORKSPACE_BASE:/opt/workspace_base \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -p $HOST_PORT:$CONTAINER_PORT \
        --add-host host.docker.internal:host-gateway \
        --name opendevin-app-$(date +%Y%m%d%H%M%S) \
        $IMAGE_NAME
    ```

5. To check the Linux distributions installed in WSL, use the following command in a Windows Terminal. If you haven't installed any other distributions, you should see only `*docker-desktop` listed. The asterisk means it's the default distribution invoked by the `wsl` command if no `-d distro-name` is given.

    ```bash
    wsl -l -v
    ```

6. Install Debian with the following command in a Windows Terminal:

    ```bash
    wsl --install -d Debian
    ```

7. Make Debian the default distribution launched by the `wsl` command with the following:

    ```bash
    wsl -s Debian
    ```

8. Open Docker Desktop and click on the gear icon in the top right corner. Under Resources -> WSL integration, look for "Enable integration with additional distros:". Enable Debian by clicking on the button.
9. Now run the bash script created earlier. Assuming the script is named "run_opendevin.sh", type the following command in a Windows Terminal:

    ```bash
    wsl -e ./run_opendevin.sh
    ```

10. At this point, since it's the first time the script is run, the Docker image will be downloaded. Each subsequent invocation of the script will run the locally downloaded image.
11. Once the Docker image is running, the OpenDevin GUI can be accessed by pointing your web browser to: [http://localhost:3000](http://localhost:3000).

More documentation can be found here:
- [OpenDevin GitHub page](https://github.com/OpenDevin/OpenDevin)
- [OpenDevin documentation page](https://opendevin.github.io/OpenDevin/modules/usage/intro)
