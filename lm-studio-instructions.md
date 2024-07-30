2024/07/30

## How to install and run OpenDevin on Windows 11:

1. Install [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).
   - open powershell
   - run `wsl`
   - after the wsl is ready you might need to re run `wsl`
   - run `wsl -i -d Ubuntu` or `wsl -i -d Debian`
   - restart windows
   - powershell will open and ask for username and password for wsl distro
   - wsl distro loads
   - run `sudo echo 'you have sudo'` to check password and sudo rights
   - run `sudo apt-get update && sudo apt-get upgrade -y`
   - if you see some packages not updated run:
   - `sudo apt-get install <and all the packages seperated with whitespace>` example `sudo apt-get install python3 ubuntu-pro`
   - put default user by running:
   -  `sudo nano /etc/wsl.conf` append:
     
     ```
     [user]
     default=<your-wsl-distro-username>
     ```

    - tips for nano:
          - ctrl+x closes the nano editor asking where to save and if you want to overide
          - simply press y and enter
     
    - should look like this:
      
      ```
      [boot]
      systemd=true
      [user]
      default=zen
      ```
   
2. Install [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/).
3. Create a folder named "OpenDevin" (or a name of your choosing)
4. Inside that folder create a folder named "workspace".
5. Either git clone this repo or Inside the "OpenDevin" folder you just created
6. create a bash script with Unix-style line termination (LF) (do not use Microsoft Notepad...)
7. and name it something like "run_opendevin.sh". The content of the bash script should be as follows:

    ```bash
    #!/usr/bin/env sh
    # Define variables
    WORKSPACE_BASE=$(pwd)/workspace;
    SANDBOX_USER_ID=$(id -u)
    PERSIST_SANDBOX="true"
    SSH_PASSWORD="sshpassword"
    IMAGE_NAME="ghcr.io/opendevin/opendevin"
    CONTAINER_PORT=3000
    HOST_PORT=3000 
    NAME=opendevin-app-$(date +%Y%m%d%H%M%S)
    echo "$NAME\n" >> "docker_container_names.txt"
    # Run the Docker container
    docker run -it \
        --pull=always \
        -e SANDBOX_USER_ID=$SANDBOX_USER_ID \
        -e LLM_MODEL="openai/<your-model-name-from-lm-studio>" \
        -e LLM_BASE_URL="http://host.docker.internal:1234/v1" \
        -e LLM_API_KEY="lm-studio" \
        -e CUSTOM_LLM_PROVIDER="openai" \
        -e PERSIST_SANDBOX=$PERSIST_SANDBOX \
        -e SSH_PASSWORD=$SSH_PASSWORD \
        -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
        -v $WORKSPACE_BASE:/opt/workspace_base \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -p $HOST_PORT:$CONTAINER_PORT \
        --add-host host.docker.internal:host-gateway \
        --name $NAME \
        $IMAGE_NAME
    ```
    - tips:
        - change the model name, it should be the string in the LM-Studio local server python code example (find the line model="some model name")
        - set the LM-Studio local server port to 1234
           
8. To check the Linux distributions installed in WSL, use the following command in a Windows Terminal. If you haven't installed any other distributions, you should see only `*docker-desktop` listed. The asterisk means it's the default distribution invoked by the `wsl` command if no `-d distro-name` is given.

    ```bash
    wsl -l -v
    ```

9. Make Debian the default distribution launched by the `wsl` command with the following:

    ```bash
    wsl -s Debian
    ```

10. in windows edit .wslconfig file in your user folder
11. append `networkingMode=mirrored`
    - should look like this:
      ```
      [wsl2]
      networkingMode=mirrored
      ```
13. in powershell run `wsl --shutdown`
14. docker will ask to restart press ok and restart
15. Open Docker Desktop
16. click on the gear icon in the top right corner.
17. Under Resources -> WSL integration:
18. look for "Enable integration with additional distros:".
19. Enable Debian by clicking on the slider.
20. Now run the bash script created earlier. Assuming the script is named "run_opendevin.sh"
21. run the following command in a Windows Terminal, cd to the folder that contains it:

    ```bash
    wsl -e ./run_opendevin.sh
    ```

22. At this point, since it's the first time the script is run, the Docker OpenDevin image will be downloaded
23. Each subsequent invocation of the script will run the locally downloaded image.
24. Once the Docker image is running, the OpenDevin GUI can be accessed by pointing your web browser to:
     - [http://localhost:3000](http://localhost:3000).

More documentation can be found here:
- [OpenDevin GitHub page](https://github.com/OpenDevin/OpenDevin)
- [Local LLM with Ollama | OpenDevin Docs](https://docs.all-hands.dev/modules/usage/llms/localLLMs)
