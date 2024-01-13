
/obj/machinery/project_manager
	name = "Station Project Console"
	desc = "DESCRIPTION."

	icon = 'icons/obj/machines/project_manager.dmi'
	icon_state = "project_base"

	var/datum/station_project/test = null

/obj/machinery/project_manager/attack_ghost(user as mob)
	attack_hand(user)

/obj/machinery/project_manager/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/project_manager/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.admin_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "StationProjectConsole", name, 750, 700, master_ui, state)
		ui.open()

/obj/machinery/project_manager/ui_data(mob/user)
	var/list/data = list()
	data["station_projects"] = list()
	for(var/datum/station_project/project as anything in SSeconomy.station_projects)
		data["station_projects"] += list(list(
			"project_name" = project.project_name,
			"project_short_description" = project.project_short_description,
			"project_description" = project.project_long_description,
			"project_image" = project.project_splash,
			"project_type" = project.type,
		))

	data["active_projects"] = list(
		list("project_name" = "DNA Vault"),
		list("project_name" = "BSA"))

	data["project_adjacency_table"] = list()

	if(test)
		data["project_adjacency_table"] = test.build_directed_adjacency_table()

	return data

/obj/machinery/project_manager/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return

	switch(action)
		if("select_project")
			test = new /datum/station_project/station_shield()
			test.build_progression_graph()
