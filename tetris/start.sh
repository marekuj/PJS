#!/bin/bash

blue="\033[1;34m"
green="\033[1;32m"
yellow="\033[1;33m"
normal="\033[1;0m"

border_line="${yellow}************${normal}    "
border_left="${yellow}*${normal}"
border_right="${yellow}*${normal}    "

board_x=19  # 0..19
board_y=9   # 0..9

declare -A board


function init {
    for x in $(range ${board_x}); do
        for y in $(range ${board_y}); do
            board[${x},${y}]=0
        done
    done    

    points=0
    play=1

    # begin test
    board[19,0]=1
    board[19,1]=1
    board[19,2]=1
    board[19,3]=1
    # board[19,4]=1
    board[19,6]=1
    board[19,7]=1
    board[19,8]=1
    board[19,9]=1

    board[18,0]=1
    board[18,1]=1
    board[18,2]=1
    board[18,3]=1
    # board[18,6]=1
    board[18,7]=1
    board[18,8]=1
    board[18,9]=1


    next_t=1
    # end test
    current_r=0
    current_t=${next_t}
    next_t=$(random)
    make_brick ${current_t} ${current_r}
    current_x=$(offset_x ${current_t})
    current_y=$(offset_y ${current_t})
    echo "$current_x"
    move
}

function random {
    shuf -i 1-6 -n 1
}

function range {
    seq 0 $1
}

function offset_x {
    ret=0;
    if [ $1 = 1 ]; then ret=-1
    elif [ $1 = 2 ]; then ret=-1
    elif [ $1 = 3 ]; then ret=-1
    elif [ $1 = 5 ]; then ret=-1
    elif [ $1 = 6 ]; then ret=-2; fi
    echo "${ret}"
}

function offset_y {
    ret=4;
    if [ $1 = 6 ]; then ret=3; fi
    echo "${ret}"
}

function make_brick {
    if [ $1 = 0 ]; then    
        brick=("1 1" 
               "1 1")
    elif [ $1 = 1 ]; then
        r=$(($2 % 4))
        if [ ${r} = 0 ]
        then brick=("0 0 0"
                    "1 1 1" 
                    "0 1 0")
        elif [ ${r} = 1 ]
        then brick=("0 1 0" 
                    "1 1 0" 
                    "0 1 0")
        elif [ ${r} = 2 ] 
        then brick=("0 1 0" 
                    "1 1 1"
                    "0 0 0")
        elif [ ${r} = 3 ] 
        then brick=("0 1 0" 
                    "0 1 1" 
                    "0 1 0")
        fi        
    elif [ $1 = 2 ]; then
        r=$(($2 % 4))
        if [ ${r} = 0 ]
        then brick=("0 0 0"
                    "1 1 1" 
                    "1 0 0")
        elif [ ${r} = 1 ]
        then brick=("1 1 0" 
                    "0 1 0" 
                    "0 1 0")
        elif [ ${r} = 2 ] 
        then brick=("0 0 1" 
                    "1 1 1"
                    "0 0 0")
        elif [ ${r} = 3 ] 
        then brick=("0 1 0" 
                    "0 1 0" 
                    "0 1 1")
        fi        
    elif [ $1 = 3 ]; then
        r=$(($2 % 4))
        if [ ${r} = 0 ]
        then brick=("0 0 0"
                    "1 1 1" 
                    "0 0 1")
        elif [ ${r} = 1 ]
        then brick=("0 1 0" 
                    "0 1 0" 
                    "1 1 0")
        elif [ ${r} = 2 ] 
        then brick=("1 0 0" 
                    "1 1 1"
                    "0 0 0")
        elif [ ${r} = 3 ] 
        then brick=("0 1 1" 
                    "0 1 0" 
                    "0 1 0")
        fi        
    elif [ $1 = 4 ]; then
        r=$(($2 % 2))
        if [ ${r} = 0 ]
        then brick=("1 1 0" 
                    "0 1 1")
        elif [ ${r} = 1 ]
        then brick=("0 0 1" 
                    "0 1 1" 
                    "0 1 0")
        fi        
    elif [ $1 = 5 ]; then
        r=$(($2 % 2))
        if [ ${r} = 0 ]
        then brick=("0 0 0"
                    "0 1 1" 
                    "1 1 0")
        elif [ ${r} = 1 ]
        then brick=("0 1 0" 
                    "0 1 1" 
                    "0 0 1")
        fi        
    elif [ $1 = 6 ]; then
        r=$(($2 % 2))
        if [ ${r} = 0 ]
        then brick=("0 0 0 0"
                    "0 0 0 0"
                    "1 1 1 1")
        elif [ ${r} = 1 ]
        then brick=("0 0 1" "0 0 1" "0 0 1" "0 0 1")
        fi        
    fi
}

function trim {
    echo $* | xargs
}

function rot_brick {    
    current_r=$((current_r + 1))
    
    make_brick ${current_t} ${current_r}
        
    # if [ ${current_r} ] 
    # declare -A test    
    # #x ${#brick[*]}
    # #y $((${#brick[0]} / 2 + 1 ))

    # buff=()

    # for x in ${!brick[*]}
    # do
    #     size=$((${#brick[x]} / 2 + 1 ))
    #     ny=0
    #     row=""
    #     for y in ${brick[x]}
    #     do 
    #         # size=$((size - 1))
    #         test[${ny},${x}]=${y}
    #         row="${row}${y} "
    #         ny=$((ny + 1))
    #         # echo "${x} | ${size} -> ${y}"
    #     done 
    #     buff+=("$(trim ${row})")
    #     # buff
    #     # echo "x: ${x} -> ${brick[x]} -> ${size}"
    #     # for x in ${!brick[*]}
    # done
    # # echo "buff:${!buff[*]} | ${buff[*]}"
    # # echo "brick:${!brick[*]} | ${brick[*]}"
    
    # # echo "brick1 : ${!brick[*]}"
    # # echo "brick1 : ${brick[*]}"

    # brick=()
    # for y in ${!buff[*]} 
    # do
    #     brick+=("${buff[$y]}")
    # done
    # # echo "brick2 : ${!brick[*]}"
    # # echo "brick2 : ${brick[*]}"


    # # echo "buff  : ${!buff[*]}"
    # # echo "brick : ${!brick[*]}"
    # # echo "brick1: ${!brick1[*]}"

    # # echo "Idx: [ ${a[0]} ]| value: ${!a[*]}"
    # # echo "Idx: ${#brick[0]} | $((${#brick[0]} / 2 + 1 )) | value: ${#brick[*]}"
    # # brick=()
    # # a="${test[0,0]} ${test[0,1]} ${test[0,2]}"
    # # b="${test[1,0]} ${test[1,1]} ${test[1,2]}"
    # # # brick=($a $b)
    # # brick+=("$a")
    # # brick+=("$b")
    # # echo "test: $a"
    # # echo "test: $b"
    # # echo "test: ${brick[*]}"

     
    # # for x in ${!brick[*]}
    # # do
    # #     echo "x: ${x} -> ${brick[x]}"
    # #     for y in ${brick[x]}
    # #     do
    # #         echo "x: ${y}"
    # #     done
    # # done

    # # for x in ${brick}
    # # do
    # #     for y in $(range ${board_y})
    # #     do
    # #         if [ ${board[${x},${y}]} = 2 ]
    # #         then
    # #             board[${x},${y}]=$1
    # #         fi
    # #     done
    # # done

    move
}

function update_brick {
    for x in $(range ${board_x}); do
        for y in $(range ${board_y}); do
            if [ ${board[${x},${y}]} = 2 ]; then
                board[${x},${y}]=$1
            fi
        done
    done
}

function update_rows {
    for x in $(range ${board_x}); do
        sum=0
        for y in $(range ${board_y}); do
            if [ ${board[${x},${y}]} = 1 ]; then sum=$((sum + 1)); fi
        done
        if [ ${sum} = $((${board_y} + 1)) ]; then
            delete_row ${x}
            points=$((points + 10))
        fi
    done
}

function delete_row {
    for i in $(range $(($1 - 1))); do
        x_to=$(($1 - i))
        x_from=$(($1 - i - 1))
        for y in $(range ${board_y}); do
            board[${x_to},${y}]=${board[${x_from},${y}]}
        done
    done

    for y in $(range ${board_y}); do 
        board[0,${y}]=0 
    done    
}

function check_left {
    ret=1
    for x in $(range ${board_x}); do
        for y in $(range ${board_y}); do
            if [ ${board[${x},${y}]} = 2 ]; then
                ny=$((y - 1))
                if [ ${y} = 0 ] || [ ${board[${x},${ny}]} = 1 ]; then
                    ret=0
                    break
                fi
            fi
        done
    done    
    echo "${ret}"
} 

function check_right {
    ret=1
    for x in $(range ${board_x}); do
        for y in $(range ${board_y}); do
            if [ ${board[${x},${y}]} = 2 ]; then
                ny=$((y + 1))
                if [ ${y} = ${board_y} ] || [ ${board[${x},${ny}]} = 1 ]; then
                    ret=0
                    break
                fi
            fi
        done
    done    
    echo "${ret}"
}

function check_down {
    ret=1
    for y in $(range ${board_y}); do
        for x in $(range ${board_x}); do
            if [ ${board[${x},${y}]} = 2 ]; then
                nx=$((x + 1))
                if [ ${x} = ${board_x} ] || [ ${board[${nx},${y}]} = 1 ]; then
                    ret=0
                    break
                fi
            fi
        done
    done    
    echo "${ret}"
}

function move_left {
    if [ $(check_left) = 1 ]; then
        current_y=$((current_y - 1));
        move;
    fi    
}

function move_right {
    if [ $(check_right) = 1 ]; then
        current_y=$((current_y + 1))
        move
    fi    
}

function move_down {
    if [ $(check_down) = 1 ]; then
        current_x=$((current_x + 1))
        move    
    else
        update_brick 1
        update_rows            
        current_r=0            
        current_t=${next_t}
        next_t=$(random)
        make_brick ${current_t} ${current_r}
        current_x=$(offset_x ${current_t})
        current_y=$(offset_y ${current_t})
        move    
    fi
}

function move {
    update_brick 0

    pos_x=${current_x}
    for x in ${!brick[*]}; do
        pos_y=${current_y}
        for y in ${brick[x]}; do
            if [ ${y} = 1 ]; then
                if [ ${board[${pos_x},${pos_y}]} = 1 ]; then play=0; fi
                board[${pos_x},${pos_y}]=2
            fi
            pos_y=$((pos_y + 1))
        done
        pos_x=$((pos_x + 1))
    done
}

function make_action {
    if [ -z $1 ]; then return
    elif [ $1 = "dwn" ]; then move_down  
    elif [ $1 = "lft" ]; then move_left  
    elif [ $1 = "rgt" ]; then move_right  
    elif [ $1 = "rot" ]; then rot_brick
    elif [ $1 = "ext" ]; then play=0; fi        
}

function begin {
    clear
    echo -ne "\033[?25l"
}

function end {
    echo "Press any key to exit..."
    read -s -n 1 input
    clear
    echo -ne "\033[?25h"    
}

function draw_clear {
    echo -e "       "
    echo -e '\033[;H'
}

function draw_info {
    echo -e "${border_line}"
    echo -e "${border_left}  Tetris  ${border_right}"
    echo -e "${border_line}${border_line}"
}

function draw_next {
    key1="${border_left} Keys:    ${border_right}"
    key2="${border_left} Rot:   ${green}W${normal} ${border_right}"
    key3="${border_left} Drop:  ${green}S${normal} ${border_right}"
    key4="${border_left} Left:  ${green}A${normal} ${border_right}"
    key5="${border_left} Right: ${green}D${normal} ${border_right}"
    key6="${border_left} Exit: ${green}ESC${normal}${border_right}"

    echo -e "${border_left}  Next:   ${border_right}${key1}"
    echo -e "${border_left}          ${border_right}${key2}"
    case "${next_t}" in
    0)
        echo -e "${border_left}${green}    XX    ${normal}${border_right}${key3}"
        echo -e "${border_left}${green}    XX    ${normal}${border_right}${key4}"
        ;;
    1)
        echo -e "${border_left}${green}    XXX   ${normal}${border_right}${key3}"
        echo -e "${border_left}${green}     X    ${normal}${border_right}${key4}"
        ;;
    2)
        echo -e "${border_left}${green}    XXX   ${normal}${border_right}${key3}"
        echo -e "${border_left}${green}    X     ${normal}${border_right}${key4}"
        ;;
    3)
        echo -e "${border_left}${green}    XXX   ${normal}${border_right}${key3}"
        echo -e "${border_left}${green}      X   ${normal}${border_right}${key4}"
        ;;
    4)
        echo -e "${border_left}${green}   XX     ${normal}${border_right}${key3}"
        echo -e "${border_left}${green}    XX    ${normal}${border_right}${key4}"
        ;;
    5)
        echo -e "${border_left}${green}    XX    ${normal}${border_right}${key3}"
        echo -e "${border_left}${green}   XX     ${normal}${border_right}${key4}"
        ;;
    6)
        echo -e "${border_left}          ${border_right}${key3}"
        echo -e "${border_left}${green}   XXXX   ${normal}${border_right}${key4}"
        ;;
    esac
    echo -e "${border_left}          ${border_right}${key5}"
    echo -e "${border_left}          ${border_right}${key6}"
    echo -e "${border_line}${border_line}"
    # echo -e "${yellow}*****  *****${normal}    ${border_line}"

}

function draw_board {
    for x in $(range ${board_x}); do
        line="${border_left}"
        for y in $(range ${board_y}); do
            if [ ${board[${x},${y}]} = 1 ]; then line="${line}X"
            elif [ ${board[${x},${y}]} = 2 ]; then line="${line}${green}X${normal}"
            else line="${line} "; fi
        done
        line="${line}${border_right}"
        echo -e "${line}"
    done
    echo -e "${border_line}"    
}

function draw_points {
    echo -e "${border_left} Points:  ${border_right}"
    printf "${border_left}${green} %8d ${normal}${border_right}\n" ${points}
    echo -e "${border_line}"
}


function draw {
    while [ ${play} = 1 ]; do
        read -s -n 4 action 
        
        make_action ${action}
        
        draw_clear
        draw_info
        draw_next
        draw_board
        draw_points
    done
}

function update_keys() {
    while [ ${play} = 1 ]; do
        read -s -n 1 input

        if [ -z ${input} ]; then return
        elif [ ${input} = "s" ] || [ ${input} = "S" ]; then echo "dwn"  
        elif [ ${input} = "a" ] || [ ${input} = "A" ]; then echo "lft"  
        elif [ ${input} = "d" ] || [ ${input} = "D" ]; then echo "rgt"  
        elif [ ${input} = "w" ] || [ ${input} = "W" ]; then echo "rot"
        elif [ ${input} = $'\x1b' ]; then echo "ext"; fi        
    done
}

function update_round() {
    echo "___" #first draw
    
    while [ ${play} = 1 ]; do
        sleep 1
        echo "dwn"
    done    
}

function main {
    begin
    init
    ( update_round & update_keys ) | ( draw )
    end
}

main