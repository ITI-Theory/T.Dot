#!/data/data/com.termux/files/usr/bin/bash
# start-desktop.sh — fully remote startup for tablet X11 + XFCE4 + Barrier
# Usage: bash ~/start-desktop.sh Tablet1   (or Tablet2 / Tablet3)
# Run from P14s: ssh -p 8022 USER@IP "bash ~/start-desktop.sh TabletN"
#
# Source: T.Dot/provisioning/tablets/start-desktop.sh

T=/data/data/com.termux/files/usr/tmp
SOCK=$T/tmux.sock
NAME=${1:-Tablet1}
BARRIER=10.133.134.136

echo "[start-desktop] $NAME — $(date)"

# Acquire wakelock so Android does not suspend Termux
termux-wake-lock && echo "[ok] wakelock" || echo "[warn] wakelock failed (not fatal)"

# Kill stale processes
pkill -f xfce4-session 2>/dev/null
pkill -f barrierc 2>/dev/null
pkill -f termux-x11 2>/dev/null
tmux -S "$SOCK" kill-server 2>/dev/null
sleep 1

# Launch Termux:X11 APK and create X socket
am start -n com.termux.x11/.MainActivity
sleep 1
TMPDIR=$T termux-x11 :0 &
sleep 3

# Verify socket
ls "$T/.X11-unix/" 2>/dev/null && echo "[ok] X11 socket" || { echo "[error] X11 socket missing — is Termux:X11 APK installed?"; exit 1; }

# Start XFCE4 inside proot Debian (in tmux, survives SSH disconnect)
tmux -S "$SOCK" new-session -d -s xfce \
  "TMPDIR=$T proot-distro login debian \
     --bind ~/:/termux-home \
     --bind $T/.X11-unix:/tmp/.X11-unix -- \
     bash -c 'DISPLAY=:0 dbus-run-session -- xfce4-session'"
sleep 4
echo "[ok] xfce tmux session"

# Start Barrier client loop inside proot Debian (auto-reconnects every 3s)
tmux -S "$SOCK" new-session -d -s barrier \
  "TMPDIR=$T proot-distro login debian \
     --bind ~/:/termux-home \
     --bind $T/.X11-unix:/tmp/.X11-unix -- \
     bash -c 'while true; do \
       DISPLAY=:0 barrierc --no-tray --disable-crypto \
         --name $NAME --display :0 $BARRIER; \
       sleep 3; \
     done'"
sleep 2
echo "[ok] barrier tmux session"

echo "--- Sessions ---"
tmux -S "$SOCK" list-sessions
echo "[done]"
