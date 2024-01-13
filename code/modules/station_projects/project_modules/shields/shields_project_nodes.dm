
/datum/project_progression_node/shields
	node_name = "Generic Shields Node"
	node_flags = NODE_TYPE_DISCOVERABLE

/datum/project_progression_node/shields/initial
	node_name = "Build Shields Console"
	node_flags = NODE_TYPE_TRUNK
	node_available = TRUE
	child_node_types = list(/datum/project_progression_node/shields/order_shields)

/datum/project_progression_node/shields/order_shields
	node_name = "Order Shields Crate"
	child_node_types = list(
		/datum/project_progression_node/shields/shields_a,
		/datum/project_progression_node/shields/shields_b
	)

/datum/project_progression_node/shields/shields_a
	node_name = "Do Shields A"
	child_node_types = list(/datum/project_progression_node/shields/shields_c)

/datum/project_progression_node/shields/shields_b
	node_name = "Do Shields B"
	child_node_types = list(/datum/project_progression_node/shields/shields_c)

/datum/project_progression_node/shields/shields_c
	node_name = "Do Shields C"
