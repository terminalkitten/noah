#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

noah_install()
{
    heading "Starting Installation..."

    # [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

    heading "Installing Configuration..."
    if [ -f "$directory_noah/noah.conf" ]; then
        info "Configuration already exists..."
    else
        cp "$directory_noah/noah.conf.example" "$directory_noah/noah.conf";
    fi
    success "Installation OK."

    heading "Installing visudo..."
    if [[ sudo -l | grep "(ALL) NOPASSWD: ALL" ]]; then
        info "visudo already exists..."
    else
        echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo &> /dev/null
    fi
    success "Installation OK."

    heading "Installing jq..."
    if sudo apt-get -qq install jq; then
        success "Installation OK."
    else
        error "Installation FAILED."
    fi

    heading "Installing pm2..."
    pm2=$(npm list -g | grep pm2)

    if [ -z "$pm2" ]; then
        npm install pm2 -g
    fi
    success "Installation OK."

    success "Installation complete!"
}
