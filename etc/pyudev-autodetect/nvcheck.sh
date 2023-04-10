#!/bin/sh

nvgpu=$(lspci | grep -i nvidia | grep -i vga | cut -d ":" -f 3)
nvkernmod=$(lspci -v | grep -i 'kernel driver' | grep -i nvidia)

if [[ $nvgpu ]]; then
    if [[ -z $nvkernmod ]]; then
      zenity --info\
        --title="Nvidia GPU Hardware Detected" \
        --width=600 \
        --text="`printf "The following Nvidia hardware has been found on your system:\n\n\
                $nvgpu\n\n\
This hardware requires 3rd party Nvidia drivers to be installed in order to function correctly.\n\n\
By pressing OK, you will be prompted for your password in order to install these drivers.\n\n\
After the driver installation completes the system will be rebooted.\n\n"`"
      PASSWD="$(zenity --password)\n"
      (
        echo "# Installing Nvidia drivers"
        echo "10"; sleep 1
        echo "# Installing Nvidia drivers"
        echo "50"; sleep 1
        echo "# Installing Nvidia drivers"
        echo -e $PASSWD | sudo -S dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
        echo "75"; sleep 1
        echo "# Nvidia driver installation complete! The system will now reboot."
        echo "100"; sleep 1
      ) | zenity --title "Nvidia GPU Hardware Detected" --progress --width=600 --no-cancel --percentage=0
      reboot
    fi
fi


