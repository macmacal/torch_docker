#!/bin/bash

: ${X11_WINDOW_MANAGER:=ratpoison}

# Add window manager to X session.
$X11_WINDOW_MANAGER &

# Attach as client to session with VNC server.
x11vnc --usepw --forever &

# Start jupyter lab  inside an xterm in the session.
jupyter lab --no-browser
