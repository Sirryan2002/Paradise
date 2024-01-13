
/datum/station_project
	/// The Official name of the Station Proect
	var/project_name = "Generic Station Project"
	/// The name that will show up in the manager console
	var/project_flavor_name = "The Generic Intiative 1.0"
	/// The description of the project that will show up when choosing projects in the manager console
	var/project_short_description = "Direct the station to attempt to complete the most borining initiative available to the crew and explore absolutely nothing!"
	/// The description of the project that will show up when getting additional details about the project in the manager console
	var/project_long_description = "Direct the station to attempt to complete the most borining initiative available to the crew and explore absolutely nothing!"
	/// The splash image of the project that will show up in the manager cnsole
	var/image/project_splash = null

	/// The path of the base node for this project
	var/datum/project_progression_node/base_node = null

	var/list/progression_nodes = list()

/// All the nodes in the graph exists only as individual types right now, in each nodes new() it will also new() all of its child nodes and
/// ensure parent nodes are properly referenced, this proc will start the entire process of traversing the tree and will return once its done
/datum/station_project/proc/build_progression_graph()
	if(length(progression_nodes))
		CRASH("build_progression_graph() called on [project_name]([UID()]) but graph was already partially or fully built")
	if(isnull(base_node))
		CRASH("build_progression_graph() called on [project_name]([UID()]) but there is not a defined base_node type")
	/// new'ing the base_node will recursively build all the child nodes in the graph
	new base_node(null, src)
	/// once the entire graph is built we can go through and intialize every node which will set it's states and special properties
	for(var/datum/project_progression_node/node as anything in progression_nodes)
		node.initialize_node()

/// In order to properly render the tech graph, we need to track all the nodes and their directed edges in the graph
/// It's called "directed" because the edges only go in a single direction and not back and forth
/datum/station_project/proc/build_directed_adjacency_table()
	var/list/directed_adjency_table = list()
	for(var/datum/project_progression_node/node as anything in progression_nodes)
		var/node_UID = node.UID()
		directed_adjency_table[node_UID] = list()
		for(var/datum/project_progression_node/child_node as anything in node.child_nodes)
			directed_adjency_table[node_UID] += child_node.UID()
	return directed_adjency_table

/datum/station_project/proc/update_progression_graph(list/nodes_to_update = list())
	if(!length(nodes_to_update))
		nodes_to_update = progression_nodes

/// Checks to see if we've already new'd this node in the tree, returns TRUE if found, returns FALSE if not found
/datum/station_project/proc/check_for_node(node_type)
	for(var/datum/project_progression_node/existing_node in progression_nodes)
		if(istype(existing_node, node_type))
			return TRUE
	return FALSE

/datum/station_project/proc/send_report()
	GLOB.minor_announcement.Announce("Priority Nanotrasen directive received. Project \"[project_flavor_name]\" details inbound.", "Incoming Priority Message", 'sound/AI/commandreport.ogg')

/datum/station_project/proc/check_completion()
	return TRUE


/datum/station_goal/Destroy()
	. = ..()
