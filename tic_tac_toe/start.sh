#!/bin/bash

blue="\033[34m"
green="\033[32m"
yellow="\033[33m"
normal="\033[0m"

player_one="${blue}Player One${normal}"
player_two="${green}Player Two${normal}"
border_line="${yellow}*****************************************${normal}"
border_left="${yellow}* ${normal}"
border_right="${yellow} *${normal}"

play=1
player=1
board=("0" "0" "0" "0" "0" "0" "0" "0" "0")


function draw_clear {
    clear
}

function draw_info {
    echo -e "${border_line}"
    echo -e "${border_left}Tic-Tac-Toe"
    echo -e "${border_left}"
    echo -e "${border_left}Keys:"
    echo -e "${border_left}    Q W E"
    echo -e "${border_left}    A S D"
    echo -e "${border_left}    Z X C"
    echo -e "${border_line}"
}

function draw_header {
    if  [ ${player} = 1 ]
    then
        header="${player_one}: "
    else
        header="${player_two}: "
    fi
    echo -e "${border_left}${header}"
}

function draw_board {
    echo -e  "${border_left}"
    row=("0 1 2" "3 4 5" "6 7 8")
    lines=("" "" "")
    for i in 0 1 2
    do
        lines[i]="${border_left}    "
        for idx in ${row[i]}
        do
            if [ ${board[${idx}]} = 0 ]
            then
                lines[i]="${lines[i]}. "
            elif [ ${board[${idx}]} = 1 ]
            then
                lines[i]="${lines[i]}${blue}X ${normal}"
            else
                lines[i]="${lines[i]}${green}O ${normal}"
            fi
        done
        echo -e "${lines[i]}"
    done
    echo -e  "${border_left}"
    echo -e  "${border_line}"
}

function get_input {
    check_input=1
    while [ ${check_input} = 1 ]
    do
        read  -s -n1 input
        case "${input}" in
            q) idx=0;;
            a) idx=3;;
            z) idx=6;;
            w) idx=1;;
            s) idx=4;;
            x) idx=7;;
            e) idx=2;;
            d) idx=5;;
            c) idx=8;;
        esac

        if [ ${board[${idx}]} = 0 ]
        then
            if [ ${player} = 1 ]
            then
                board[${idx}]=1
            else
                board[${idx}]=2
            fi
            check_input=0
        fi
    done
}

function check_row {
    if [ ${board[$1]} != "0" ] && [ ${board[$1]} == ${board[$2]} ] && [ ${board[$2]} == ${board[$3]} ]
    then
        if  [ ${player} = 1 ]
        then
            win="${player_one}: Win!"
        else
            win="${player_two}: Win!"
        fi
        play=0

        draw_clear
        draw_info
        draw_header
        draw_board
        echo
        echo -e ${win}
        echo
    fi
}

function check {
    check_row 0 1 2
    check_row 3 4 5
    check_row 6 7 8
    check_row 0 3 6
    check_row 1 4 7
    check_row 2 5 8
    check_row 0 4 8
    check_row 2 4 6

    if [ ${play} != 0 ]
    then
        draw=1
        echo    ${draw}
        for idx in ${board[@]}
        do
            echo    ${idx}
            if [ ${idx} = 0 ]
            then
                draw=0
                echo "asd ${draw}"
            fi
        done

        if [ ${draw} = 1 ]
        then
            play=0

            draw_clear
            draw_info
            draw_header
            draw_board
            echo
            echo -e "${yellow}Draw!${normal}"
            echo
        fi
    fi

    if  [ ${player} = 1 ]
    then
        player=2
    else
        player=1
    fi
}

while [ ${play} = 1 ]
do
    draw_clear
    draw_info
    draw_header
    draw_board
    get_input
    check
done

