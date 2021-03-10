(*
	Start Tyme tracker for current selected task in OmniFocus.

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

		-- cehck if task is already exsit
		try
			set tsk to the first item of (every task of every project whose name = tskName)
		on error errMsg
			set tsk to missing value
		end try

		-- try to generate project or task
		if tsk is missing value then
			-- Getting path to this file 
			tell application "Finder"
				get container of (path to me) as Unicode text 
				set currentLocation to result
			end tell

			run script file (currentLocation & "omni2tyme.applescript")

			-- check if task is generated
			try
				set tsk to the first item of (every task of every project whose name = tskName)
			on error errMsg
				set tsk to missing value
			end try
		end if

		if tsk is not missing value then
			set tskId to id of tsk
			StartTrackerForTaskID tskId
		end if
	end tell
end tell