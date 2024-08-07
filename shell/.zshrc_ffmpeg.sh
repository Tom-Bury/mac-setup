#!/usr/bin/env zsh

function 2gif() {
    input_file=$1

    if [ -z "$input_file" ]; then
        input_file=$(ls | fzf)
    fi

    while true; do
        echo "Enter scale value (e.g., 1.5 for 1.5 times the original size. Default 1):"
        read scale_value
        if [[ -z "$scale_value" ]]; then
            scale_value=1
            break
        elif [[ $scale_value =~ ^[0-9]+([.][0-9]+)?$ ]]; then
            break
        fi
    done

    while true; do
        echo "Limit colors? (y/n):"
        read limit_colors
        if [[ -z "$limit_colors" ]]; then
            limit_colors="y"
            break
        elif [[ $limit_colors == "y" || $limit_colors == "n" ]]; then
            break
        fi
    done

    while true; do
        echo "Enter frame rate (e.g. 16):"
        read frame_rate
        if [[ -z "$frame_rate" ]]; then
            frame_rate=16
            break
        elif [[ $frame_rate =~ ^[0-9]+$ ]]; then
            break
        fi
    done

    if [ "$limit_colors" = "y" ]; then
        palettegen_option="palettegen=max_colors=32"
    else
        palettegen_option="palettegen"
    fi

    output_file="${input_file%.*}.gif"

    ffmpeg -i $input_file \
        -vf "fps=${frame_rate},scale=iw*${scale_value}:ih*${scale_value}:flags=lanczos,split[s0][s1];[s0]${palettegen_option}[p];[s1][p]paletteuse" \
        -loop 0 $output_file

    echo "\n✅ Done!"
    echo "GIF size: $(du -k $output_file | awk '{print $1/1024 " MB"}')"
    echo "$output_file"
}