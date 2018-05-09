#!/bin/bash

blue="\033[1;34m"
green="\033[1;32m"
yellow="\033[1;33m"
normal="\033[1;0m"

border_line="${yellow}************${normal}    "
border_left="${yellow}*${normal}"
border_right="${yellow}*${normal}    "

current_x=0
current_y=4
current_r=0
current_t=0
next_t=0
points=0

declare -A board
board_x=19  # 0..19
board_y=9   # 0..9
play=1

function random {
    shuf -i 1-5 -n 1
}

function range {
    seq 0 $1
}

function make_brick {
    if [ $1 = 0 ]
    then
        brick=("1 1" 
               "1 1")
    elif [ $1 = 1 ]
    then
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
    elif [ $1 = 2 ]
    then
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
    elif [ $1 = 3 ]
    then
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
    elif [ $1 = 4 ]
    then
        r=$(($2 % 2))
        if [ ${r} = 0 ]
        then brick=("1 1 0" 
                    "0 1 1")
        elif [ ${r} = 1 ]
        then brick=("0 0 1" 
                    "0 1 1" 
                    "0 1 0")
        fi        
    elif [ $1 = 5 ]
    then
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
    elif [ $1 = 6 ]
    then
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
    update_brick 0
    
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
    
    
    update_brick 1  
}

function update_brick {
    for x in $(range ${board_x})
    do
        for y in $(range ${board_y})
        do
            if [ ${board[${x},${y}]} = 2 ]
            then
                board[${x},${y}]=$1
            fi
        done
    done
}


function update_rows {
    for x in $(range ${board_x})
    do
        sum=0
        for y in $(range ${board_y})
        do
            if [ ${board[${x},${y}]} = 1 ]
            then
                sum=$((sum + 1))
            fi
        done
        # echo "SUM:  ${sum}"
        if [ ${sum} = 10 ]  # todo
        then
            delete_row ${x}
            points=$((points + 10))
        fi
    done
}

function delete_row {
    for i in $(range $(($1 - 1)))
    do
        nx=$((board_x - i - 1))
        x=$((board_x - i)) 
        for y in $(range ${board_y})
        do
            board[${x},${y}]=${board[${nx},${y}]}
        done
    done
}

function check_left {
    ret=1
    for x in $(range ${board_x})
    do
        for y in $(range ${board_y})
        do
            if [ ${board[${x},${y}]} = 2 ]
            then
                ny=$((y - 1))
                if [ ${y} = 0 ] || [ ${board[${x},${ny}]} = 1 ]
                then
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
    for x in $(range ${board_x})
    do
        for y in $(range ${board_y})
        do
            if [ ${board[${x},${y}]} = 2 ]
            then
                ny=$((y + 1))
                if [ ${y} = ${board_y} ] || [ ${board[${x},${ny}]} = 1 ]
                then
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
    for y in $(range ${board_y})
    do
        for x in $(range ${board_x})
        do
            if [ ${board[${x},${y}]} = 2 ]
            then
                nx=$((x + 1))
                if [ ${x} = ${board_x} ] || [ ${board[${nx},${y}]} = 1 ]
                then
                    ret=0
                    break
                fi
            fi
        done
    done    
    echo "${ret}"
}

function move_left {
    current_y=$((current_y - 1))
    move
}

function move_right {
    current_y=$((current_y + 1))
    move
}

function move_down {
    current_x=$((current_x + 1))
    move    
}

function move {
    update_brick 0

    pos_x=${current_x}
    for x in ${!brick[*]}
    do
        pos_y=${current_y}
        for y in ${brick[x]}
        do
            if [ ${y} = 1 ]
            then
                if [ ${board[${pos_x},${pos_y}]} = 1 ]
                then
                    play=0
                fi
                board[${pos_x},${pos_y}]=2
            fi
            pos_y=$((pos_y + 1))
        done
        pos_x=$((pos_x + 1))
    done
}

function get_input {
    read -s -n 1 -t 1 input

    if [ -z ${input} ] || [ ${input} = "s" ] || [ ${input} = "S" ]
    then
        if [ $(check_down) = 1 ]
        then
           move_down  
        else
            update_brick 1
            update_rows            
            current_r=0            
            current_t=${next_t}
            next_t=$(random)
            make_brick ${current_t} ${current_r}
            current_x=0
            current_y=4
            move    
        fi
    elif [ ${input} = "a" ] ||  [ ${input} = "A" ]
    then
        if [ $(check_left) = 1 ]
        then
           move_left  
        fi
    elif [ ${input} = "d" ] || [ ${input} = "D" ]
    then
        if [ $(check_right) = 1 ]
        then
           move_right  
        fi
    elif [ ${input} = "w" ] || [ ${input} = "W" ]
    then
        rot_brick
    elif [ ${input} = $'\x1b' ]
    then
        play=0
    fi        
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
    # echo -e "${border_line}${border_line}"
    echo -e "${yellow}*****  *****${normal}    ${border_line}"

}

function draw_board {
    for x in $(range ${board_x})
    do
        line="${border_left}"
        for y in $(range ${board_y})
        do
            if [ ${board[${x},${y}]} = 1 ]
            then
                line="${line}X"
            elif [ ${board[${x},${y}]} = 2 ]
            then
                line="${line}${green}X${normal}"
            else
                line="${line} "
            fi
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

function start {
    clear
    echo -ne "\033[?25l"
}

function end {
    echo "Press any key to exit..."
    read -s -n 1 input
    clear
    echo -ne "\033[?25h"    
}

function main {
    start

    for x in $(range ${board_x})
    do
        for y in $(range ${board_y})
        do
            board[${x},${y}]=0
        done
    done


    # board[5,4]=1
    # board[10,4]=2
    # board[11,4]=2
    # board[10,5]=2
    # board[11,5]=2

    # current_t=1

    current_t=${next_t}
    next_t=$(random)
    make_brick ${current_t} ${current_r}
    # next_t=$(random)
    move

    # draw_clear
    # draw_info
    # draw_next
    # draw_board

    # result=$(check_left)
    # echo "check_left: ${result}"

    # result=$(check_right)
    # echo "check_right: ${result}"

    # result=$(check_down)
    # echo "check_down: ${result}"

    board[19,0]=1
    board[19,1]=1
    board[19,2]=1
    board[19,3]=1
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

    while [ ${play} = 1 ]
    do
        draw_clear
        draw_info
        draw_next
        draw_board
        draw_points
        

        get_input
        # check
    done    
    
    end
}

main