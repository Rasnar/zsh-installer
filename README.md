# Oh My ZSH installer

The purpose of this script is to install ZSH on a new machine. It will also install Oh My Zsh and a few plugins if you wish to.

To start the installation just run the following script ;

```bash
./install.sh
````

## Test it inside a docker

If you want to test the shell without installing everything, you can do it inside a docker.
First you will need to build the docker image:

```bash
docker build -t zsh_installer_tester .
```

Then you can run it and test out the installer:

```bash
docker run -it -v $(pwd):/data/ zsh_installer_tester /bin/bash
./install.sh
```

## Installing a font with icons

The theme powerlevel10k has icons for some things and you may want to use your custom font in your terminal.
You can install any font on Linux like that:

1. Download a [Nerd Font](https://www.nerdfonts.com/)
2. Unzip and copy to ~/.fonts
3. Run the command fc-cache -fv to manually rebuild the font cache
