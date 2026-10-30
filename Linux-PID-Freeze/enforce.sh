#!/bin/sh

# record list of currently running processes
ps -axho pid > pidActualList.txt

# for every line in actual list
for line in $()
do
# 	if line exists in allow list
# 		suspend process
# 		record to flagged.log 
# 		if suspension fails, kill process
# 		record kill action to flagged.log
# 	end of if statement
done
# end of for loop


# schedule this script as service or in cron
