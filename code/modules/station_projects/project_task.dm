/datum/project_task
	var/task_name = "Generic Task"

	var/datum/project_progression_node/parent_node


/datum/project_task/New(loc, _parent_node)
	. = ..()
	parent_node = _parent_node
