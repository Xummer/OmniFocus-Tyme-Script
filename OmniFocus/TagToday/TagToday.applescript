(*
	Add tag "Today" to tasks with tag "This week" and remove "This week" tag.
*)
tell application "OmniFocus"
	tell front window
		set selectedTrees to selected trees of content
		set selectedTasks to every item of selectedTrees
	end tell
	
	tell front document
		repeat with tskIdx from 1 to count of selectedTasks
			-- display dialog "tag: " & tskIdx
			set theTask to the value of item tskIdx of selectedTasks
			set currTags to name of tags of theTask

			set todayTag to (first flattened tag whose name is "Today Quest")
			set shouldAdd to true

			repeat with tagIdx from 1 to count of currTags
				set currTag to item tagIdx of currTags
				if currTag = "This Week" then
					set weakTag to (first flattened tag whose name is "This Week")
					remove weakTag from tags of theTask
				else 
					if currTag = "Today Quest" then
						set shouldAdd to false
						remove todayTag from tags of theTask
					end if
				end if
			end repeat

			if shouldAdd is true then
				add todayTag to tags of theTask
			end if
			
		end repeat
	end tell
end tell