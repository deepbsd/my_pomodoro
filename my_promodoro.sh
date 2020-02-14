#!/usr/bin/env bash

short_break=5
long_break=20
pomodoro=5
completed_pomodoros=""
((durationinsecs=${pomodoro}*3600/60))


start_time=$(date +%s)

compute(){
   start_secs=${1}
   now_time=$(date +%s)
   elapsed=$( expr $now_time - $start_secs )
   printf "%d " "${elapsed}"
}


convertsecs(){
    ((h=${1}/3600))
    ((m=(${1}%3600)/60))
    ((s=${1}%60))
    #printf "%02d:%02d:%02d" $h $m $s
    printf "%02d:%02d" $m $s
}

remainingsecs(){
    ((m=${2}-1-${1}%3600/60))
    ((s=(60-${1}%60)))
    printf "%02d:%02d" $m $s
}

completed(){
    completed_pomodoros+=$(echo "*")
}

run_break(){
    start=$(date +%s)
    #now=$(date +%s)
    length=${1}
    elapsed_secs=$(expr $now - $start)
    minutes=$((elapsed_secs/60))



    while [ $minutes -lt $length ]; do
    if $minutes -ge $length ; then
        break
    fi

    now=$(date +%s)
    pomo=$(compute $start)
    minutes=$((elapsed_secs/60))
    elapsed_secs=$(expr $now - $start)
    remaining=$(remainingsecs $elapsed_secs $length)
    elapsed=$(convertsecs $pomo)
    if [ $length -gt 5 ]; then
        break_type="Long Break"
    else
        break_type="Short Break"
    fi

    clear

cat <<EOBreak


        elapsed_secs: ${elapsed_secs}    minutes: ${minutes}     length: ${length}

        Break: ${break_type}     Remaining:  ${remaining}
                               Elapsed: ${elapsed}



EOBreak
    sleep 1
    done
}

show_pom(){

clear

cat <<EOF


                    Welcome to MyPomodoro!

        Short break: ${short_break}     Elapsed: ${elapsed}
        Long break: ${long_break}     Remaining: ${remaining}
        Goal: ********     Completed: ${completed_pomodoros}


EOF

}
    
while true; do
    show_pom
    pomo=$(compute $start_time)
    elapsed=$(convertsecs $pomo)
    remaining=$(remainingsecs $pomo $pomodoro)
    ((pomo=$durationsecs + 10))
    if [ $pomo -gt $durationinsecs ]; then
        completed_pomodoros=$(completed)
        start_time=$(date +%s)
        if  $(( ${#completed_pomodoros} % 4 )) == 0 ; then
            run_break 25
        else
            run_break 5
        fi
    fi
    sleep 1
done




