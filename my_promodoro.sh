#!/usr/bin/env bash

short_break=5
long_break=20
pomodoro=25
completed_pomodoros=""
((durationinmins=${pomodoro}*3600/60))


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
    echo '*' 
}

run_break(){
    start=$(date +%s)
    now=$(date +%s)
    length=${1}
    elapsed_secs=$(expr $now - $start)
    minutes=$((elapsed_secs/60))



    while [ $minutes -le $length ]; do
        now=$(date +%s)
        pomo=$(compute $start)
        minutes=$((elapsed_secs/60))

        if (($minutes >= $length)) ; then 
            return 0
        fi

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


        //////////////////////   BREAK TIME  //////////////////////////////

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
    if ! (( $pomo < $durationinmins )) ; then
        if  [[  $(( ${#completed_pomodoros} % 4 )) == 0 ]] && [[ ${#completed_pomodoros} -ne 0 ]]; then
            run_break ${long_break}
        else
            run_break ${short_break}
        fi
        completed_pomodoros+=$(completed)
        start_time=$(date +%s)
    fi
    sleep 1
done




