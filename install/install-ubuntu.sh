#!/bin/bash

# Install script for repository: https://github.com/TauferLab/NASMo-TiAM
# This installs R, R libraries, pip, Python libraries
# INSTRUCTIONS:
# Execute this script with: ./install-ubuntu.sh

# Add CRAN repository for more up-to-date r and r packages
# https://vitux.com/how-to-install-and-use-the-r-programming-language-in-ubuntu-18-04-lts/
sudo apt install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt update
sudo apt upgrade

# Get libraries for R usage
sudo apt -y install r-base-core
sudo apt -y install libgdal-dev
sudo apt -y install libudunits2-dev
sudo apt -y install libssl-dev

# Install R libraries
sudo Rscript R-dependencies.R

# Install Python libraries
sudo python3 -m pip install -r Python-dependencies.txt
