on timerStartedForTaskRecord(tskRecordID)
end timerStartedForTaskRecord

on timerStoppedForTaskRecord(tskRecordID)
end timerStoppedForTaskRecord

on timeoutDetectedForTaskRecord(tskRecordID)
end timeoutDetectedForTaskRecord

on projectCompletedChanged(projectID)
end projectCompletedChanged

on taskCompletedChanged(tskId)
	tell application "Tyme"
		set spent to 0.0
		GetTaskRecordIDs startDate ((current date) - (168 * 60 * 60)) endDate (current date) taskID tskId
		set fetchedRecords to fetchedTaskRecordIDs as list
		repeat with recordID in fetchedRecords
			GetRecordWithID recordID
			set duration to timedDuration of lastFetchedTaskRecord
			set spent to (spent + duration / 3600)
		end repeat
		set spent to (round (spent * 10)) / 10
		set tsk to the first item of (every task of every project whose id = tskId)
		set prj to the first item of (every project whose id = (relatedProjectID of tsk))
		set pname to name of prj
		set tname to name of tsk
		tell application "OmniFocus"
			tell default document
				set opro to the first item of (flattened projects whose name is pname)
				set otsk to the first item of ((flattened tasks of opro) whose name is tname)
				-- display dialog "spent: " & tname
				if completed of otsk is false then
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
					
					if (havPlan is true) then
						set name of otsk to (name of otsk & " ✅ " & spent as string) & " / " & (plan / 60) as string
					end if
				end if
			end tell
		end tell
	end tell
end taskCompletedChanged

