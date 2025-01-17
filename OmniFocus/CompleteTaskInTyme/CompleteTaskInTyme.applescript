(*
	Complete current selected task in OmniFocus and complete the task with same name in Tyme .
	Then update the task name with a pair of time: real spent time / planned time.

	Copyright © 2020 Zhang Dong
	Licensed under MIT License
*)
tell application "OmniFocus"
	tell front window
		set selectedTree to selected trees of content
		set curTask to first item of selectedTree
		set tskName to name of curTask
	end tell
	
	tell application "Tyme"
		set tsk to the first item of (every task of every project whose name = tskName)
		set tskId to id of tsk
		my taskCompletedChanged(tskId)
		set completed of tsk to true
	end tell
end tell

on taskCompletedChanged(tskId)
	tell application "Tyme"
		-- Get spent time from Tyme 3
		set spent to 0.0
		GetTaskRecordIDs startDate ((current date) - (168 * 60 * 60)) endDate (current date) taskID tskId
		set fetchedRecords to fetchedTaskRecordIDs as list
		repeat with recordID in fetchedRecords
			GetRecordWithID recordID
			set duration to timedDuration of lastFetchedTaskRecord
			set spent to (spent + duration / 3600)
		end repeat

		-- Stop timer by taskID
		StopTrackerForTaskID tskId

		-- Convert time to minutes
		set spent to (round (spent * 10)) / 10
		set tsk to the first item of (every task of every project whose id = tskId)
		set prj to the first item of (every project whose id = (relatedProjectID of tsk))
		set pname to name of prj
		set tname to name of tsk
		tell application "OmniFocus"
			tell default document
				set opro to the first item of (flattened projects whose name is pname)
				set otsk to the first item of ((flattened tasks of opro) whose name is tname)
				mark complete otsk
				set havPlan to false
				if (estimated minutes of otsk is not missing value) then
					set plan to estimated minutes of otsk
					set havPlan to true
				else
					if due date of otsk is not missing value then
						set plan to due date of otsk
						set plan to minutes of plan
						set havPlan to true
					end if
				end if
				
				-- display dialog "spent: " & plan
				if (havPlan is true) then
					set name of otsk to (name of otsk & " ✅ " & spent as string) & " / " & (plan / 60) as string
				end if
			end tell
		end tell
	end tell
end taskCompletedChanged