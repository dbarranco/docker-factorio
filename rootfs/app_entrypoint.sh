#!/bin/bash
set -e
echo '   _____               __               .__       ' 
echo ' _/ ____\____    _____/  |_  ___________|__| ____ ' 
echo ' \   __\\__  \ _/ ___\   __\/  _ \_  __ \  |/  _ \' 
echo ' |  |   / __ \\  \___|  |  (  <_> )  | \/  (  <_> )'
echo ' |__|  (____  /\___  >__|   \____/|__|  |__|\____/' 
echo '            \/     \/'                             
#Vars
save_dir="/opt/factorio/saves"
mods_dir="/opt/factorio/mods"
SERVER_SETTINGS=/opt/factorio/server_config.json
FACTORIO_PORT=${FACTORIO_PORT:-34197}

# Setting initial command
factorio_command="/opt/factorio/bin/x64/factorio --server-settings /opt/factorio/server_config.json"

# Populate server_config.json
#jq  '.name = "Factorio Server v'$VERSION'" ' $SERVER_SETTINGS >> tmp.$$.json && mv tmp.$$.json $SERVER_SETTINGS

echo "###"
echo "# Server configuration:"
echo "###"
cat ${SERVER_SETTINGS}

factorio_command="$factorio_command --port ${FACTORIO_PORT}"
echo "###"
echo "# Game server port is '${FACTORIO_PORT}'"
echo "###"

if [ -z $FACTORIO_RCON_PORT ]
then
  factorio_command="$factorio_command --rcon-port ${FACTORIO_RCON_PORT:-27015}"
  echo "###"
  echo "# RCON port is '${FACTORIO_RCON_PORT}'"
  echo "###"
fi

if [ -z $FACTORIO_RCON_PASSWORD ]
then
  FACTORIO_RCON_PASSWORD=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c16)
  echo "###"
  echo "# RCON password is '${FACTORIO_RCON_PASSWORD}'"
  echo "###"
  factorio_command="${factorio_command} --rcon-password ${FACTORIO_RCON_PASSWORD}"
fi

# Factorio mod/save folders
mkdir $save_dir $mods_dir

# Handling save settings
if [ -z $FACTORIO_SAVE ]
then
  if [ "$(ls --hide=lost\+found ${save_dir})" ]
  then
    echo "###"
    echo "# Using saved data..."
    echo "###"
    ls -l --hide=lost\+found ${save_dir}
  else
    echo "###"
    echo "# Creating a new map [save.zip]"
    echo "###"
    /opt/factorio/bin/x64/factorio --create save.zip
  fi
  factorio_command="${factorio_command} --start-server-load-latest"
else
  factorio_command="${factorio_command} --start-server ${FACTORIO_SAVE}"
fi
echo "###"
echo "# Launching Game"
echo "###"
# Closing stdin
exec 0<&-
echo -n "Command is..."
echo $factorio_command
cat $SERVER_SETTINGS
#sleep 10m
exec ${factorio_command}


/opt/factorio/bin/x64/factorio --server-settings {/opt/factorio/server_config.json} --port 34197 --rcon-port 27015 --rcon-password 131cf12e80def07d --start-server-load-latest