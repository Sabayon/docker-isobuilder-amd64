# ISO Builder Image

Docker Image for build Sabayon ISO images that use [iso_build.sh](https://github.com/Sabayon/molecules.git).

Image has two mode:

  * SystemD Mode: when SABAYON_MOLECULES_SYSTEMD_MODE is equal to 1 container is
    started with SytemdD service and a Docker in Docker service and use internal
    Docker service for retrieve Spinbase image to use for create ISO images.
    This mode require mount of /sys/fs/cgroup volume.


  * Normal Mode: when SABAYON_MOLECULES_SYSTEMD_MODE is equal to 0 container
    use Docker Host service. This require volume


## Usage

Example of SystemD Mode:

```

$#. docker run --init --device /dev/fuse --tmpfs /run --tmpfs /tmp \
      -v /bigdisk/molecules-chroots:/chroots \
      -v /bigdisk/molecules-sources:/sources \
      -v /sabayon/iso:/iso \
      -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
      --rm   --name build-sab-iso \
      --cap-add=SYS_PTRACE --cap-add=SYS_ADMIN --cap-add=NET_ADMIN --cap-add=MKNOD \
      --device=/dev/loop-control:/dev/loop-control \
      --device=/dev/loop0:/dev/loop0 \
      --device=/dev/loop1:/dev/loop1 \
      -e COLUMNS=200 -e LINES=400 \
      -e SABAYON_MOLECULES_CHROOTS=/chroots \
      -e SABAYON_MOLECULES_SOURCES=/sources \
      -e SABAYON_MOLECULES_ISO=/iso \
      sabayon/isobuilder-amd64

```

On example it is overrided default chroots and sources directory for use disk with more
space.

ISOs will be available on /sabayon/iso host directory.


| Env Variable | Default | Description |
| SABAYON_MOLECULES_GITURL | https://github.com/Sabayon/molecules.git | Git Repository of Sabayon Molecules configurations. |
| SABAYON_MOLECULES_GIT_OPTS | - | Permit to define additional git clone options, like use a specific branch. |
| SABAYON_MOLECULES_DIR | /sabayon | Molecule work directory |
| SABAYON_MOLECULES_CHROOTS | - | If present permit to mount in binding path to molecules chroots directory |
| SABAYON_MOLECULES_SOURCES | - | If present permit to mount in binding selected path to molecules sources directory. |
| SABAYON_MOLECULES_ISO | - | If present permit to mount in binding selected path to molecules iso directory |
| SABAYON_MOLECULES_ENVFILE | $(pwd)/confs/iso_build.env | Optional file to sources for override environment variables. |
| SABAYON_MOLECULES_SYSTEMD_MODE | 0 | Enable SystemD Mode (1) or not (0).
| SABAYON_MOLECULES_POSTSCRIPT | - | Define post script to execute. |

