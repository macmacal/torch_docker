export DISPLAY=":99"
xvfb $DISPLAY -screen 0 640x480x8 -nolisten tcp &
xvfb-run -s "-screen 0 600x400x24" jupyter-lab
