
/datum/project_progression_node
	/// Short Name of the node that will show up in the tree
	var/node_name = "blank node"
	/// Flags to give the progression special behaviours
	var/node_flags = 0
	/// The level this node is at, increases as you go further down the tree
	var/node_level = 1
	/// The station project datum (i.g. the data tree) that this node is inside
	var/datum/station_project/parent_project

	/// Is this node completed?
	var/completed = FALSE
	/// Is this node currently available to start completing (i.g. clickable in the research tree)?
	var/node_available = FALSE

	/// How many points does this node have towards node completion?
	var/completion_points = 0
	/// How many points does this node need to have in order for it to be completed? If 0, no points will be required
	var/required_completion_points = 0

	/// Currently active tasks on this node, will not be populated until node is activated
	var/list/required_tasks = list()
	///
	var/list/child_node_types = list()
	var/list/child_nodes = list()
	var/list/parent_nodes = list()

// Used to build our tree, will make sure all parent nodes are connected to src and then new all the children nodes of src
/datum/project_progression_node/New(datum/project_progression_node/parent_node, datum/station_project/_parent_project)
	// add the parent node passed in constructor to our parent node list
	parent_project = _parent_project
	parent_project.progression_nodes |= src
	if(parent_node)
		parent_nodes += parent_node
		parent_node.child_nodes |= src
	// now we need to go through and handle our child nodes
	var/child_nodes = list()
	for(var/child_node as anything in child_node_types)
		// since nodes can potentially have two parents, we need to make sure this child doesn't already exist in the graph
		var/node_exists = FALSE
		for(var/datum/project_progression_node/existing_node in parent_project.progression_nodes)
			if(istype(existing_node, child_node))
				child_nodes += existing_node
				existing_node.parent_nodes |= src
				node_exists = TRUE
		if(node_exists)
			continue
		// this child node doesn't exist so we will create it (this is recursive until all children under this node is initialized)
		child_nodes += new child_node(src, parent_project)

/// Called once progression graph is built, will properly set flags and status of src based on parent & children nodes
/datum/project_progression_node/proc/initialize_node(update_graph = FALSE)
	if(node_flags & NODE_TYPE_AUTOCOMPLETE)
		completed = TRUE // immediately set src to completed but don't reveal it until we know parent is revealed or it's non-discoverable
		on_completion()
	if(!(node_flags & NODE_TYPE_DISCOVERABLE))
		reveal_node() // non-discoverable nodes are visible by default

	if(!completed)
		var/completed_parent_count = 0
		for(var/datum/project_progression_node/parent_node as anything in parent_nodes)
			node_level = max(parent_node.node_level + 1, node_level) // src should have a node_level 1 higher than it's highest parent
			if(!(parent_node.node_flags & NODE_TYPE_AUTOCOMPLETE)) //we check flags instead of `completed` here b/c one parent node may not be init'd yet
				continue
			reveal_node() // if one parent is completed, you should be able to see the next node
			completed_parent_count++
			if(completed_parent_count == length(parent_nodes))
				node_available = TRUE //if both parents are completed, make this node available

	if(node_available && !completed) // if the node is available and not already completed, go ahead and activate it
		activate_node()
		for(var/datum/project_progression_node/child_node as anything in child_nodes)
			child_node.reveal_node()


	if(update_graph)
		parent_project.update_progression_graph()

/// Used to fully initialize the node once it's accesible in the progression graph
/datum/project_progression_node/proc/activate_node()
	var/task_paths = required_tasks
	required_tasks = list() //clear the list
	for(var/task_path in task_paths)
		required_tasks += new task_path(src)

/// Make src visible in the progression graph
/datum/project_progression_node/proc/reveal_node()
	node_flags |= NODE_REVEALED

/// Make src invisible in the progression graph
/datum/project_progression_node/proc/hide_node()
	node_flags &= ~NODE_REVEALED

/// Called when the node is completed
/datum/project_progression_node/proc/on_completion()
	for(var/datum/project_progression_node/child_node as anything in child_nodes)
		child_node.reveal_node()
	parent_project.update_progression_graph()
