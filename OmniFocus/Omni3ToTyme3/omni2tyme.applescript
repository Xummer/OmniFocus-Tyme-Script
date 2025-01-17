activate "OmniFocus"
tell application "OmniFocus"
	tell front window
		set my_sel to selected trees of content
		repeat with ptaskt in reverse of my_sel
			set ptask to value of ptaskt
			set ftask to flattened tasks of ptask
			set haschild to false
			repeat with my_selection in ftask
				if (number of tasks of my_selection = 0 and completed of my_selection is not true) then
					my tell_tyme(my_selection)
					set haschild to true
				end if
			end repeat
			if (haschild is false) then
				my tell_tyme(ptask)
			end if
		end repeat
	end tell
end tell

on tell_tyme(my_selection)
	tell application "OmniFocus"
		tell front window
			set task_name to name of my_selection
			set havedue to false
			if due date of my_selection is not missing value then
				set due to due date of my_selection
				set havedue to true
			end if
			
			if (estimated minutes of my_selection is not missing value) then
				set esti to (estimated minutes of my_selection) * 60 as real
			else
				set esti to 0 as real
			end if
			set proj_name to name of containing project of my_selection
			
			tell application "Tyme"
				set make_new_project to true
				set make_new_task to true
				repeat with existed_project in every project
					if ((name of existed_project) is proj_name) then set make_new_project to false
					repeat with existed_task in every task in existed_project
						if ((name of existed_task) is task_name and (completed of existed_task) is false) then set make_new_task to false
					end repeat
					
				end repeat
				if (make_new_project) then make new project with properties {name:proj_name}
				
				if (make_new_task) then
					if (havedue is true) then
						make new task of (project proj_name) with properties {name:task_name, taskType:"timed", dueDate:due}
					else
						make new task of (project proj_name) with properties {name:task_name, taskType:"timed"}
					end if
				end if
			end tell
		end tell
	end tell
end tell_tyme
