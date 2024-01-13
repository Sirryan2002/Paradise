//Station Shield
// A chain of satellites encircles the station
// Satellites be actived to generate a shield that will block unorganic matter from passing it.
/datum/station_project/station_shield
	project_name = "Station Shield"
	project_flavor_name = "Station Shield construction"
	project_short_description = "We have a prototype shielding system you will deploy to reduce collision related accidents"
	project_long_description = "The station is located in a zone full of space debris. We have a prototype shielding system you will deploy to reduce collision related accidents.\
								You can order the satellites and control systems through the cargo shuttle."

	base_node = /datum/project_progression_node/shields/initial

	var/coverage_goal = 5000

/datum/station_project/station_shield/New()
	. = ..()
	var/obj/machinery/I = /obj/machinery/satellite
	project_splash = "[icon2base64(icon(initial(I.icon), initial(I.icon_state), SOUTH, 1))]"

/datum/station_project/station_shield/proc/on_report()
	//Unlock
	var/datum/supply_packs/P = SSeconomy.supply_packs["[/datum/supply_packs/misc/station_goal/shield_sat]"]
	P.special_enabled = TRUE

	P = SSeconomy.supply_packs["[/datum/supply_packs/misc/station_goal/shield_sat_control]"]
	P.special_enabled = TRUE

/datum/station_project/station_shield/check_completion()
	if(..())
		return TRUE
	if(get_coverage() >= coverage_goal)
		return TRUE
	return FALSE

/datum/station_project/station_shield/proc/get_coverage()
	var/list/coverage = list()
	for(var/obj/machinery/satellite/meteor_shield/A in GLOB.machines)
		if(!A.active || !is_station_level(A.z))
			continue
		coverage |= view(A.kill_range, A)
	return coverage.len
