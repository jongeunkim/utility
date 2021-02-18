#!/bin/bash

##### Parameters  
problist=problist.sh
# nodelist=( 0 1 3 5 6 7 )
nodelist=($(seq 0 1 7))


declare -i nProcessor
declare -i nRunning
declare -i i
declare -i nextprob
declare -a processor
declare -a procid


function print_job_assignment ()
{
	for (( i=0 ; i < nProcessor ; ++i )); do
		echo "processor[$i] = ${processor[i]}, procid=[$i] = ${procid[i]}"
	done
	echo ""
}


function checkRunningProcesses ()
{
    nRunning=0
    for (( i=0 ; i < nProcessor ; ++i )); do
		if [[ "${procid[i]}" != "0" ]]; then
			if [[ ! `ps h ${procid[i]}` ]]; then 
				procid[$i]=0
			else
				let ++nRunning
			fi
		fi
    done
}


function findFreeProc () 
{
    started="no"
    for (( i=0 ; i < nProcessor ; ++i )); do
		if (( procid[$i] == 0 )); then
			echo "Line ${nextprob} is running on ${processor[i]}"
			eval taskset -c ${processor[i]} $prob & # Execute string prob
			procid[$i]=$!
			let ++nextprob
			started="yes"
			sleep 5
			# print_job_assignment
			return
		fi
    done
}

##### Initialization
nextprob=1
nProcessor=0
for i in "${nodelist[@]}"; do
	processor[$nProcessor]=$i
	procid[$nProcessor]=0
	let ++nProcessor
done

echo "nProcessor = $nProcessor"
echo "# of commands = " `grep -v '^#' $problist | wc -l`
print_job_assignment

##### Run jobs in problist
while (( $nextprob <= `grep -v '^#' $problist | wc -l` )); do
	prob=`grep -v '^#' $problist | sed -e "$nextprob q;d" $runlist` # Read file except #-line. Then, read n-th line
    checkRunningProcesses
    findFreeProc
    if [[ $started == "no" ]]; then
		sleep 2
    fi
	# echo procid
done

##### Once the last job is executed, then check until there is no job running
nRunning=1 # initial value to begin the while loop
nRunning_prev=$nProcessor
while (( $nRunning != 0 )); do
    sleep 2
    checkRunningProcesses

	if [[ $nRunning < $nRunning_prev ]]; then
		nRunning_prev=$nRunning
		echo "$nRunning jobs are running"
    fi
done

echo "all done"

