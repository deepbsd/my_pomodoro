#!/usr/bin/env bash

short_break=5
long_break=25
pomodoro=25
completed_pomodoros=""
((durationinsecs=${pomodoro}*3600/60))


start_time=$(date +%s)

compute(){
   now_time=$(date +%s)
   elapsed=$( expr $now_time - $start_time )
   printf "%d " "${elapsed}"
}


convertsecs(){
    ((h=${1}/3600))
    ((m=(${1}%3600)/60))
    ((s=${1}%60))
    printf "%02d:%02d:%02d" $h $m $s
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
    now=$(date +%s)
    length=${1}
    elapsed=$(expr $now - $start)
    remaining=$(remainingsecs $elapsed $length)


while [ $elapsed -le $length ]; do
    now=$(date +%s)
    if [ $length -gt 5 ]; then
        break_type="Long Break"
    else
        break_type="Short Break"
    fi

    clear

cat <<EOBreak



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
    pomo=$(compute)
    elapsed=$(convertsecs $pomo)
    remaining=$(remainingsecs $pomo $pomodoro)
    ((pomo=$durationsecs + 10))
    if [ $pomo -gt $durationinsecs ]; then
        completed_pomodoros=$(completed)
        start_time=$(date +%s)
        run_break 5
    fi
    sleep 1
done




