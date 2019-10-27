#!/bin/sh

Xvfb $DISPLAY -screen 0 1366x800x24 &
fluxbox &
x11vnc -display $DISPLAY -bg -forever -nopw -quiet -listen localhost -xkb
