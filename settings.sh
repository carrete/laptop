#!/usr/bin/env bash
# -*- mode: sh; coding: utf-8; tab-width: 4; indent-tabs-mode: nil -*-
set -euo pipefail
IFS=$'\n\t'
readonly script="$(readlink -f "$0")"

function on_exit {
    exit 0
}

trap on_exit EXIT

function on_error {
    readonly errcode=$1
    readonly linenum=$2
    echo "[ERROR] script: $script errcode: $errcode linenum: $linenum"
    exit $errcode
}

trap 'on_error $? $LINENO' ERR

# dconf watch /

gsettings set com.canonical.Unity integrated-menus false
gsettings set com.canonical.Unity.Launcher favorites "['application://org.gnome.Nautilus.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
gsettings set com.canonical.Unity.Lenses remote-content-search none

gsettings set com.canonical.indicator.datetime show-date true
gsettings set com.canonical.indicator.datetime time-format 24-hour

gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ top-edge-action 0
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ alt-tab-bias-viewport false
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-hide-mode 1 
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ show-launcher "'Enabled'"

gsettings set org.gnome.desktop.background color-shading-type solid
gsettings set org.gnome.desktop.background picture-options none
gsettings set org.gnome.desktop.background picture-uri "''"
gsettings set org.gnome.desktop.background primary-color "'#2e2e34343636'"
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swapcaps']"
gsettings set org.gnome.desktop.interface gtk-theme Radiance
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.session idle-delay 1800

# bash <(curl -s https://raw.githubusercontent.com/aaron-williamson/base16-gnome-terminal/master/color-scripts/base16-tomorrow-night.sh)

# gsettings set org.gnome.terminal.legacy.profiles:/:83f9d147-d5b7-45b3-a481-eaf62185f5b2/audible-bell false
# gsettings set org.gnome.terminal.legacy.profiles:/:83f9d147-d5b7-45b3-a481-eaf62185f5b2/font 'Terminus 12'
# gsettings set org.gnome.terminal.legacy.profiles:/:83f9d147-d5b7-45b3-a481-eaf62185f5b2/use-system-font false
