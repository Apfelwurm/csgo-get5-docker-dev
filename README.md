<h1 align="center">
    <img src=".readme/csgo.png" height=50px align="absmiddle">
    <img src=".readme/docker.png" height=50px align="absmiddle">
</h1>
<h1 align="center">
    csgo-get5-docker-dev
</h1>
<p align="center">
    <em>
        Development container for get5
    </em>
</p>
<p align="center">
    <a href="https://github.com/Apfelwurm/csgo-get5-docker-dev/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/Apfelwurm/csgo-get5-docker-dev">
    </a>
    <a href="https://github.com/Apfelwurm/csgo-get5-docker-dev/actions/workflows/check-latest-csgo-version.yml">
        <img src="https://github.com/Apfelwurm/csgo-get5-docker-dev/actions/workflows/check-latest-csgo-version.yml/badge.svg">
    </a>    
    <a href="https://github.com/Apfelwurm/csgo-get5-docker-dev/actions/workflows/update.yml">
        <img src="https://github.com/Apfelwurm/csgo-get5-docker-dev/actions/workflows/update.yml/badge.svg">
    </a>
    <a href="https://github.com/Apfelwurm/csgo-get5-docker-dev/actions/workflows/build.yml">
        <img src="https://github.com/Apfelwurm/csgo-get5-docker-dev/actions/workflows/build.yml/badge.svg">
    </a>
</p>

## 1. Introduction

This image aims to provide a CS:GO server to develop and test [get5](https://github.com/splewis/get5). 

Do not use this in production to run your matches!

Everything that can be changed about the server can be **set using environment variables** passed to Docker on container
creation.

If you want to use your local build you have to build it first using [this instructions](https://splewis.github.io/get5/dev/developers/#build)

For further information please read [the docs](https://splewis.github.io/get5/dev/). 

## 2. Using the image

### 2.1 Quickstart

1. Download the image from [Docker hub](https://hub.docker.com/r/apfelwurm/csgo-get5-docker-dev):
```
docker pull apfelwurm/csgo-get5-docker-dev:latest
```

2. Launch a container:
```
docker run --rm -it --network=host apfelwurm/csgo-get5-docker-dev:latest
```

### 2.2 Recommended Docker launch arguments

At minimum, you'll probably want to launch the container with the following environment variables set:

* `-it`: run the container interactive. There will be problems if you don't run it interactiveley.

* `--network=host`: use the host machine's ports and IP address, rather than running within an isolated Docker 
  network that's not visible to the outside world.

* `-e RCON_PASSWORD=<some other password>`: set the RCON (admin) password.

If you want to start the server with a loaded config, set:

* `-e MATCH_CONFIG=<your match config>`: start the server with the given JSON config loaded with Get5.

### 2.3 Examples

#### 2.3.1 Starting a server with no match config with your local get5 development build

Start a server with:
- The host machine's IP address 
- The specified port, GOTV port, password, RCON password, GOTV password

```
docker run --rm -it --network=host \
 -e GOTV_ENABLE=1 \
 -e PORT=1234 \
 -e GOTV_PORT=1235 \
 -e GOTV_DELAY=15 \
 -e PASSWORD=mypass \
 -e RCON_PASSWORD=adminpass \
 -e GOTV_PASSWORD=gotvpass \
 -e GET5_VER=LOCAL\
 -v $PWD/builds/get5:/localmounts/get5 \
 apfelwurm/csgo-get5-docker-dev:latest
```

#### 2.3.2 Starting a server with a match config

Start a server with:
- The host machine's IP address 
- The specified port, GOTV port, password, RCON password, GOTV password
- The given Get5 config loaded

```
docker run --rm -it --network=host \
 -e GOTV_ENABLE=1 \
 -e PASSWORD=mypass \
 -e RCON_PASSWORD=adminpass \
 -e GOTV_PASSWORD=gotvpass \
 -e GOTV_DELAY=15 \
 -e MATCH_CONFIG="{'matchid': '81a99ef9a2844c278c2bda2f5a77a793', \
                   'num_maps': 3, \
                   'maplist': ['de_dust2', 'de_inferno', 'de_mirage', 'de_nuke', 'de_overpass', 'de_train', 'de_vertigo'], \
                   'skip_veto': False, \
                   'team1': {'name': 'Astralis', \
                             'tag': 'AST', \
                             'players': {698652696634933762: 'gla1ve', \
                                         234783204182937471: 'Magisk', \
                                         389371614622221912: 'dev1ce', \
                                         951311418417028314: 'dupreeh', \
                                         369417162788295143: 'Xyp9x'}}, \
                   'team2': {'name': 'Natus Vincere', \
                             'tag': 'NAVI', \
                             'players': {875407653610178066: 's1mple', \
                                         979550479724346962: 'Boombl4', \
                                         186841562108230104: 'electronic', \
                                         726408891643982724: 'Perfecto', \
                                         512316566954794515: 'flamie'}}}" \
 apfelwurm/csgo-get5-docker-dev:latest
```

## 3. Environment variables

Setting environment variables when starting a container allows you to manipulate the launch options of the server.

For example, `docker run -it -e PASSWORD=1234 apfelwurm/csgo-get5-docker-dev:latest` will start a new server with password `1234` 
by launching the server with `+sv_password 1234`. 

All possible environment variables are displayed in the table below.

| Variable name            | Launch option               | Description                                                                            
| :----------------------- | :-------------------------- | :-------------------------------
| STEAMWORKS_VER           |                             | This determinates which [steamworks](https://github.com/KyleSanderson/SteamWorks/) version will be installed on the startup. This can either be a version (like `1.2.3c` ) or a url to a tgz file (like `https://github.com/KyleSanderson/SteamWorks/releases/download/1.2.3c/package-lin.tgz`) or `LOCAL`. If you set it to `LOCAL`, you can use the corresponding mountpoint ( see [below](#4-mountpoints) ) to mount an extracted version. (for current default, look into the dockerfile)
| METAMOD_VER              |                             | This determinates which [metamod](http://www.metamodsource.net/) version will be installed on the startup. This can either be a version (like `1.12` ) or a url to a tar.gz file (like `https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1148-linux.tar.gz`) or `LOCAL`. If you set it to `LOCAL`, you can use the corresponding mountpoint ( see [below](#4-mountpoints) ) to mount an extracted version. (for current default, look into the dockerfile)
| SOURCEMOD_VER            |                             | This determinates which [sourcemod](https://www.sourcemod.net/) version will be installed on the startup. This can either be a version (like `1.11` ) or a url to a tar.gz file (like `https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6915-linux.tar.gz`) or `LOCAL`. If you set it to `LOCAL`, you can use the corresponding mountpoint ( see [below](#4-mountpoints) ) to mount an extracted version. (for current default, look into the dockerfile)
| GET5_VER                 |                             | This determinates which [get5](https://github.com/splewis/get5) version will be installed on the startup. This can either be a version (like `0.10.5` ) or a url to a tar.gz file (like `https://github.com/splewis/get5/releases/download/v0.10.5/get5-v0.10.5.tar.gz`) or `LATEST` for the latest stable version, `LATEST-PRE` for the latest nightly or `LOCAL`. If you set it to `LOCAL`, you can use the corresponding mountpoint ( see [below](#4-mountpoints) ) to mount an extracted version. (for current default, look into the dockerfile)
| GET5_APISTATS            |                             | This determinates which apistats plugin should be activated on the startup. you can set this to `get5_apistats` or `get5_mysqlstats` or your own plugins name (must be contained in the local / downloaded get5 folder). Alternativeley you can set it to `LOCAL`, you can use the corresponding mountpoint ( see [below](#4-mountpoints) ) to mount an extracted version (default: false)
| SERVER_TOKEN             | `+sv_setsteamaccount`       | The Steam Game Server Login Token for this instance, required for the server to be accessible to non-LAN connections. Generate one [here](https://steamcommunity.com/dev/managegameservers) (default: not set, ie LAN connections only).
| PASSWORD                 | `+sv_password`              | Password required to connect to the server (default: not set)
| RCON_PASSWORD            | `+rcon_password`            | Password required to establish an RCON (remote console) connection to the server (default: not set)
| PORT                     | `-port`                     | Server port (default: 27015)
| GOTV_ENABLE              | `+tv_enable`                | GOTV Enable (default: 0)
| GOTV_PORT                | `+tv_port`                  | GOTV port (default: 27020)
| GOTV_PASSWORD            | `+tv_password`              | GOTV password (default: not set)
| GOTV_DELAY               | `+tv_delay`                 | GOTV delay (default: 15)
| GOTV_SNAPSHOTRATE        | `+tv_snapshotrate`          | GOTV Snapshot rate (default: 32)
| TICKRATE                 | `-tickrate`                 | Server tick rate (64 or 128; default: 128)
| MAXPLAYERS               | `-maxplayers_override`      | Limit how many players the server can contain (default: 30)
| GAMETYPE                 | `+game_type`                | Use GAMETYPE and GAMEMODE to set what game mode is played (default: GAMETYPE=0, GAMEMODE=1, which sets game mode to competitive). Note this will be overriden by Get5.
| GAMEMODE                 | `+game_mode`                | See above.
| MAPGROUP                 | `+mapgroup`                 | The map group to cycle through. Given this will be overridden by Get5, probably leave it as default (default: mg_active).
| MAP                      | `+map`                      | The map that the server starts on. Must be a valid CSGO map, e.g. `de_mirage`. 
| HOST_WORKSHOP_COLLECTION | `+host_workshop_collection` | Set the maps in specified workshop collection as the server's map list (default: not set)
| WORKSHOP_START_MAP       | `+workshop_start_map`       | Get the latest version of the workshop map with the specified ID and set it as the starting map (default: not set)
| WORKSHOP_AUTHKEY         | `-authkey`                  | Set a Steam Web API authkey, required to download maps from the workshop. Generate one [here](https://steamcommunity.com/dev/apikey) (default: not set).
| AUTOEXEC                 | `+exec`                     | A `.cfg` file to be executed on startup. Note anything you set here will probably be overwritten by Get5 when a match is loaded, so it's fairly useless (default: not set).
| UPDATE_ON_LAUNCH         | `-autoupdate`               | 1: Check for CS:GO updates on container launch, 0: do not check for updates. (default: 1)
| CUSTOM_ARGS              |                             | A string containing any additional launch options to pass to the dedicated server (default: not set)
| MATCH_CONFIG             |                             | If set to a valid JSON match config, the server starts with the config loaded. (#using-get5-for-match-creation) for more on using Get5. (Default: not set.)


Launch options are appended to the following set of basic launch options that are passed as arguments to `srcds`, the 
dedicated server program:
```
-game csgo -console -usercon -steam_dir $STEAMCMD_DIR -steamcmd_script $STEAMCMD_DIR/steamcmd.sh -ip 0.0.0.0
```
## 4. Mountpoints

| Mountpoint path               | Description                                                                            
| :-----------------------      | :-------------------------- 
| /localmounts/servercfg        | If something is in here, the whole content will be copied recursive to the `cfg` folder of the srcds csgo folder and overwrites what is there right before the server starts.
| /localmounts/get5cfg          | If something is in here, the whole content will be copied recursive to the `addons/sourcemod/configs/get5` folder of the srcds csgo folder and overwrites what is there.
| /localmounts/steamworks       | If setting `STEAMWORKS_VER` to `LOCAL` the contents of the here mounted subfolder `addons` is copied to the corresponding srcds csgo folder
| /localmounts/metamod          | If setting `METAMOD_VER` to `LOCAL` the contents of the here mounted folder content is copied to the corresponding srcds csgo folders
| /localmounts/sourcemod        | If setting `SOURCEMOD_VER` to `LOCAL` the contents of the here mounted folder content is copied to the corresponding srcds csgo folders
| /localmounts/get5             | If setting `GET5_VER` to `LOCAL` the contents of the here mounted subfolders `addons` and `cfg` are copied to the corresponding srcds csgo folder
| /localmounts/get5_apistats    | If setting `GET5_APISTATS` to `LOCAL` the contents of the here mounted subfolders `addons` and `cfg` are copied to the corresponding srcds csgo folder



## 5. Keeping the image up to date

### 5.1 Updates on launch

By default, when a container is started from the image, it checks for CS:GO updates and installs them. Note that this 
will not modify your local copy of the image, so future containers will also have to download the update.
To disable checking for updates on launch, set the environment variable `UPDATE_ON_LAUNCH` to be `0`.

### 5.2 Scheduled and manual updates

For ensuring that an image contains the latest CS:GO version, two scripts are provided, one for local images and one for
the image in the DockerHub repo.
These can be run manually or at scheduled intervals. They run the following steps:
1. Check the version of CS:GO installed on the image 
2. If the version differs from the latest version of CS:GO according the Steam Web API, then a container is spawned 
   running `server-scripts/server-update.sh`, which installs CS:GO updates
3. The changes to the container are committed to the image and the image label updated to show the version of CS:GO 
   installed 
5. The image is pushed to the registry (`image_update/update-image-remote.sh` only)

The image updater scripts use `jq` to parse JSON objects from the Steam Web API. Install it using `sudo apt install jq`.

#### 5.2.1 Local version

To keep your local image up to date, you can schedule a `cron` job to run `updated-local-image.sh` at given intervals.
For example:

1. Run `crontab -e` to edit the crontab for the current user 
2. Add the following line to the opened file: 
```bash
10 * * * * /home/myuser/csgo-get5-docker-dev/update-local-image.sh > /home/myuser/csgo-get5-docker-dev/cron.log
```
This will run the script `/home/myuser/csgo-get5-docker-dev/update-local-image.sh ` at 10 minutes past the hour every hour, and 
log the output to `/home/myuser/csgo-get5-docker-dev/cron.log`.

#### 5.2.2 Version on DockerHub

The workflow ["Uses latest CS:GO version"](https://github.com/Apfelwurm/csgo-get5-docker-dev/actions/workflows/check-csgo-version.yml)
checks that the version of CSGO on the image in the DockerHub registry matches the latest CS:GO patch released on Steam. If the versions missmatch, a issue is created here.

I run the `image_update/update-image-remote.sh` locally if nessecary and as soon as the docker hub is updated, i'll close the corresponding issue.

So if the image is already updated (which should happen soon after the release), you can simply run docker pull `apfelwurm/csgo-get5-docker-dev:latest` again to update.