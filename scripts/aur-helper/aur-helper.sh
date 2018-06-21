#!/bin/bash

# SHOW QUICK HELP
if [ "$1" == "" ]
then
    cat .usage.txt
    exit 1

# SHOW MANPAGE
elif [ \( "$1" == "help" \) -o \( "$1" == "h" \) ]
then
    man ./.aur_helper.sh.8

# INSTALL OR UPDATE AN AUR HELPER
elif [ \( "$1" == "install" \) -o \( "$1" == "i" \) ] 
then

## INSTALL OR UPDATE TRIZEN 
    if [ "$2" == "trizen" ]
    then
        {
            RELEASE_TRIZEN=$(git ls-remote --tags git@github.com:trizen/trizen.git | awk '{print $2}' | grep -v '{}' | awk -F"/" '{print $3}' | tail -n 1)
            
            wget -q https://github.com/trizen/trizen/archive/"$RELEASE_TRIZEN".tar.gz -O /tmp/trizen.tar.gz
            cd /tmp
            tar xf trizen.tar.gz
            cd trizen-"$RELEASE_TRIZEN"/archlinux
            
            makepkg -si
            
            rm -rf /tmp/trizen.tar.gz /tmp/trizen-"$RELEASE_TRIZEN"
        } &> /dev/null

        echo "Installation completed!"

## INSTALL OR UPDATE AURA
    elif [ "$2" == "aura" ]
    then
        {
            RELEASE_AURA=$(git ls-remote --tags git@github.com:aurapm/aura.git | awk '{print $2}' | grep -v '{}' | awk -F"/" '{print $3}' | tail -n 1)
            RELEASE_AURA=${RELEASE_AURA//v}

            wget -q https://github.com/aurapm/aura/releases/download/v"$RELEASE_AURA"/aura-"$RELEASE_AURA"-x86_64.tar.gz -O /tmp/aura.tar.gz
            cd /tmp
            mkdir aura
            tar xf aura.tar.gz -C aura
            cd aura

            sudo cp aura /usr/bin

            if [ "$SHELL" == "/bin/bash" ]
            then
                sudo cp bashcompletion.sh /usr/share/bash-completion/completions/aura
            elif [ "$SHELL" == "/bin/zsh" ]
            then
                sudo cp _aura /usr/share/zsh/site-functions/_aura
            fi

            sudo cp aura.8 /usr/share/man/man8/aura.8.gz

            rm -rf /tmp/aura.tar.gz /tmp/aura
        } &> /dev/null

        echo "Installation completed!"

## INSTALL OR UPDATE YAY
    elif [ "$2" == "yay" ]
    then
        {
            RELEASE_YAY=$(git ls-remote --tags git@github.com:Jguer/yay.git | awk '{print $2}' | grep -v '{}' | awk -F"/" '{print $3}' | tail -n 1)
            RELEASE_YAY=${RELEASE_YAY//v}
            
            wget -q https://github.com/Jguer/yay/releases/download/v"$RELEASE_YAY"/yay_"$RELEASE_YAY"_x86_64.tar.gz -O /tmp/yay.tar.gz
            cd /tmp
            tar xf yay.tar.gz
            cd yay_"$RELEASE_YAY"_x86_64
            
            sudo cp yay /usr/bin
            
            if [ "$SHELL" == "/bin/bash" ]
            then
                sudo cp bash /usr/share/bash-completion/completions/yay
            elif [ "$SHELL" == "/bin/zsh" ]
            then
                sudo cp zsh /usr/share/zsh/site-functions/_yay
            elif [ "$SHELL" == "/bin/fish" ]
            then
                sudo cp fish /usr/share/fish/vendor_completions.d/yay.fish
            fi

            sudo cp yay.8 /usr/share/man/man8/yay.8.gz

            rm -rf /tmp/yay.tar.gz /tmp/yay_"$RELEASE_YAY"_x86_64
        } &> /dev/null

        echo "Installation completed!"
    fi

# UNINSTALL AN AUR HELPER
elif [ \( "$1" == "uninstall" \) -o \( "$1" == "u" \) ]
then

## UNINSTALL TRIZEN
    if [ "$2" == "trizen" ]
    then
        {
            TRIZEN_PACKAGE=$(pacman -Qi trizen)
            TRIZEN_PACKAGE=$?
            
                if [ "$TRIZEN_PACKAGE" == "0" ]
                then
                    sudo pacman -Rns --noconfirm trizen
                else
                    sudo pacman -Rns --noconfirm trizen-git
                fi
        } &> /dev/null

        echo "Uninstallation completed."

## UINSTALL AURA
    elif [ "$2" == "aura" ] 
    then
        {
            sudo rm /usr/bin/aura
        
            if [ "$SHELL" == "/bin/bash" ]
            then
                sudo rm /usr/share/bash-completion/completions/aura
            elif [ "$SHELL" == "/bin/zsh" ]
            then
                sudo rm /usr/share/zsh/site-functions/_aura
            fi

            sudo rm /usr/share/man/man8/aura.8.gz
        } &> /dev/null

        echo "Uninstallation completed."

## UNINSTALL YAY    
    elif [ "$2" == "yay" ]
    then
        {
            sudo rm /usr/bin/yay
            
            if [ "$SHELL" == "/bin/bash" ]
            then
                sudo rm /usr/share/bash-completion/completions/yay
            elif [ "$SHELL" == "/bin/zsh" ]
            then
                sudo rm /usr/share/zsh/site-functions/_yay    
            elif [ "$SHELL" == "/bin/fish" ]
            then
                sudo rm /usr/share/fish/vendor_completions.d/yay.fish
            fi
            
            sudo rm /usr/share/man/man8/yay.8.gz
        } &> /dev/null

        echo "Uninstallation completed."
    fi
fi
