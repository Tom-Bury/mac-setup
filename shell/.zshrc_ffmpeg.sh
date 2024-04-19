#!/usr/bin/env zsh

function 2gif() {
    ffmpeg -i $1 \
        -vf "fps=16,scale=-1:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
        -loop 0 output.gif
}