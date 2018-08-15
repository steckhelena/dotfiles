#!/bin/bash

i3-msg 'workspace "9"; append_layout ~/.config/i3/workspaces/9.json'
pavucontrol
xfce4-terminal --hide-menubar --role="htop-terminal" -e htop
