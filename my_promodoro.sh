#!/usr/bin/env bash

#################################
#  Easy little pomodoro time mgmt
#  program to help you not waste time.
#  This runs in a terminal, so you can use it 
#  with a tiling window manager if desired.
#  Requires 'play' is installed (from sox)
#################################

##  Initial variables
short_break=5
long_break=20
pomodoro=25
completed_pomodoros=""
start_sound=./sounds/Ship_Bell-Mike_Koenig-1911209136.wav
end_sound=./sounds/foghorn-daniel_simon.wav
((durationinmins=${pomodoro}*3600/60))


##  Set the start time in seconds
start_time=$(date +%s)

## make sure 'play' is installed...
play_sound(){
    file=${1}
    play -q $file
}

## Play the start sound
play_sound $start_sound

## Computes seconds elapsed from after 1st argument
## Expects argument in seconds
compute(){
   start_secs=${1}
   now_time=$(date +%s)
   elapsed=$( expr $now_time - $start_secs )
   printf "%d " "${elapsed}"
}

## Converts seconds to hours, minutes, seconds
## Just displays minutes and seconds
convertsecs(){
    ((h=${1}/3600))
    ((m=(${1}%3600)/60))
    ((s=${1}%60))
    #printf "%02d:%02d:%02d" $h $m $s
    printf "%02d:%02d" $m $s
}

## Computes minutes and seconds remaining from start time
## and now time,  Expects now_seconds then start_time
remainingsecs(){
    ((m=${2}-1-${1}%3600/60))
    ((s=(60-${1}%60)))
    [ $m -eq -1 ] && m=0
    printf "%02d:%02d" $m $s
}

## For showing a list of asterisks and completed Pomodoros
completed(){
    echo '*' 
}

##  Runs a break, either a short one or long one
##  Expects an argument in minutes
run_break(){
    play_sound $end_sound
    start=$(date +%s)
    now=$(date +%s)
    length=${1}
    elapsed_secs=$(expr $now - $start)
    minutes=$((elapsed_secs/60))



    while [ $minutes -le $length ]; do
        now=$(date +%s)
        pomo=$(compute $start)
        minutes=$((elapsed_secs/60))

        ## exit and start a new Pomodoro when break is spent
        if (($minutes >= $length)) ; then 
            return 0
        fi

        elapsed_secs=$(expr $now - $start)
        remaining=$(remainingsecs $elapsed_secs $length)
        elapsed=$(convertsecs $pomo)
        if [ $length -ne $short_break ]; then
            break_type="Long Break"
        else
            break_type="Short Break"
        fi

        clear

cat <<EOBreak


        //////////////////////   BREAK TIME  //////////////////////////////

        Break: ${break_type}    Elapsed: ${elapsed}   Remaining:  ${remaining}

EOBreak

        sleep 1
    done
}

show_bar(){
    count=0
    period=${1}
    length=${2}
    start=$(date +%s)
    spinner=('\' '|' '/' '—' '\' '|' '/' '—')


    while true; do
        [ ${elapsedsecs} -gt $((length*60)) ] && return
        pomo=$(compute $start)
        elapsedsecs=$(compute $start)
        elapsed=$(convertsecs $pomo)
        remaining=$(remainingsecs $pomo $length)
        clear
cat <<EOBar
${period} >>>  ${spinner[$count]} ${remaining}s remaining    ${completed_pomodoros}
EOBar
        sleep 1
        if [ $count -lt 7 ]; then
            ((count++))
        else
            count=0
        fi
        
    done

}

##  This is the main pomodoro screen
show_pom(){
    period=${1}
    length=${2}
    start=$(date +%s)

    while true; do
        pomo=$(compute $start)
        elapsedsecs=$(compute $start)
        [ ${elapsedsecs} -gt $((length*60)) ] && return
        elapsed=$(convertsecs $pomo)
        remaining=$(remainingsecs $pomo $length)

    clear

cat <<EOF


                    Welcome to MyPomodoro!

        ///////////////  Work Time  ///////////////////////

        Short break: ${short_break}     Elapsed: ${elapsed}

        Long break: ${long_break}     Remaining: ${remaining}

        Goal: ********     Completed: ${completed_pomodoros}
EOF
    sleep 1
    done
}
    

##  This is the main loop
while true; do
    [ "$1" == '-b' ] && show_bar "Work" ${pomodoro} || show_pom "Work" ${pomodoro}

    if  [[  $(( ${#completed_pomodoros} % 4 )) == 0 ]] && [[ ${#completed_pomodoros} -ne 0 ]]; then
        run_break ${long_break}
    else
        run_break ${short_break}
    fi
    completed_pomodoros+=$(completed)
    start_time=$(date +%s)
    play_sound $start_sound
done




