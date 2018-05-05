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
next_t=1
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
    if [ $1 = 1 ]
    then
        brick=("1 1" 
               "1 1")
    elif [ $1 = 2 ]
    then
        brick=("1 0" 
               "1 1"
               "1 0")
    elif [ $1 = 3 ]
    then
        brick=("1" 
               "1"
               "1"
               "1")
    elif [ $1 = 4 ]
    then
        brick=("1 0" 
               "1 0"
               "1 1")
    elif [ $1 = 5 ]
    then
        brick=("1 1 0" 
               "0 1 1")
    fi
    
    next_t=$(random)  
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
        nx=$((18 - i))
        x=$((19 - i)) 
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
                if [ ${y} = 9 ] || [ ${board[${x},${ny}]} = 1 ]
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
                if [ ${x} = 19 ] || [ ${board[${nx},${y}]} = 1 ]
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
                board[${pos_x},${pos_y}]=2
            fi
            pos_y=$((pos_y + 1))
        done
        pos_x=$((pos_x + 1))
    done
}

function get_input {
    read -s -n1 -t1 input

    if [ -z ${input} ] || [ ${input} = "s" ]
    then
        if [ $(check_down) = 1 ]
        then
           move_down  
        else
            update_brick 1
            update_rows
            
            make_brick ${next_t}
            current_x=0
            current_y=4
            move    
        fi
    elif [ ${input} = "a" ]
    then
        if [ $(check_left) = 1 ]
        then
           move_left  
        fi
    elif [ ${input} = "d" ]
    then
        if [ $(check_right) = 1 ]
        then
           move_right  
        fi
    elif [ ${input} = "w" ]
    then
        if [ $(check_down) = 1 ]
        then
           move_down  
        fi
    # elif [ ${input} = "s" ]
    # then
    #     if [ $(check_down) = 1 ]
    #     then
    #        move_down  
    #     fi
    elif [ ${input} = $'\x1b' ]
    then
        play=0
    fi    

    # while [ ${check_input} = 1 ]
    # do
    #     read  -s -n1 -t1 input 
    #     echo -e  "${input}"
        # case "${input}" in
        #     q) idx=0;;
        #     a) idx=3;;
        #     z) idx=6;;
        #     w) idx=1;;
        #     s) idx=4;;
        #     x) idx=7;;
        #     e) idx=2;;
        #     d) idx=5;;
        #     c) idx=8;;
        # esac

        # if [ ${idx} != 10 ] && [ ${board[${idx}]} = 0 ]
        # then
        #     if [ ${player} = 1 ]
        #     then
        #         board[${idx}]=1
        #     else
        #         board[${idx}]=2
        #     fi
        #     check_input=0
        # fi
    # done
}

# function check_row {
#     if [ ${board[$1]} != "0" ] && [ ${board[$1]} == ${board[$2]} ] && [ ${board[$2]} == ${board[$3]} ]
#     then
#         if  [ ${player} = 1 ]
#         then
#             win="${player_one}: Win!"
#         else
#             win="${player_two}: Win!"
#         fi
#         play=0

#         draw_clear
#         draw_info
#         draw_header
#         draw_board
#         echo
#         echo -e ${win}
#         echo
#     fi
# }

# function check {
#     check_row 0 1 2
#     check_row 3 4 5
#     check_row 6 7 8
#     check_row 0 3 6
#     check_row 1 4 7
#     check_row 2 5 8
#     check_row 0 4 8
#     check_row 2 4 6

#     if [ ${play} != 0 ]
#     then
#         draw=1
#         echo    ${draw}
#         for idx in ${board[@]}
#         do
#             echo    ${idx}
#             if [ ${idx} = 0 ]
#             then
#                 draw=0
#                 echo "asd ${draw}"
#             fi
#         done

#         if [ ${draw} = 1 ]
#         then
#             play=0

#             draw_clear
#             draw_info
#             draw_header
#             draw_board
#             echo
#             echo -e "${yellow}Draw!${normal}"
#             echo
#         fi
#     fi

#     if  [ ${player} = 1 ]
#     then
#         player=2
#     else
#         player=1
#     fi
# }


function draw_clear {
    echo -e "       "
    echo -e '\033[;H'
}

function draw_info {
    echo -e "${border_line}"
    echo -e "${border_left}  Tetris  ${border_right}"
    echo -e "${border_line}"
}

function draw_next {
    echo -e "${border_left}  Next:   ${border_right}"
    echo -e "${border_left}          ${border_right}"
    case "${next_t}" in
    1)
        echo -e "${border_left}${green}    XX    ${normal}${border_right}"
        echo -e "${border_left}${green}    XX    ${normal}${border_right}"
        echo -e "${border_left}          ${border_right}"
        ;;
    2)
        echo -e "${border_left}${green}    XXX   ${normal}${border_right}"
        echo -e "${border_left}${green}     X    ${normal}${border_right}"
        echo -e "${border_left}          ${border_right}"
        ;;
    3)
        echo -e "${border_left}          ${border_right}"
        echo -e "${border_left}${green}   XXXX   ${normal}${border_right}"
        echo -e "${border_left}          ${border_right}"
        ;;
    4)
        echo -e "${border_left}${green}    X     ${normal}${border_right}"
        echo -e "${border_left}${green}    X     ${normal}${border_right}"
        echo -e "${border_left}${green}    XX    ${normal}${border_right}"
        ;;
    5)
        echo -e "${border_left}${green}   XX     ${normal}${border_right}"
        echo -e "${border_left}${green}    XX    ${normal}${border_right}"
        echo -e "${border_left}          ${border_right}"
        ;;
    esac
    echo -e "${border_left}          ${border_right}"
    echo -e "${border_line}"
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
    read -s -n1 input
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

    next_t=1

    # board[10,6]=1
    # board[10,4]=2
    # board[11,4]=2
    # board[10,5]=2
    # board[11,5]=2

    make_brick ${next_t}
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