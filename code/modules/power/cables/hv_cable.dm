

/obj/structure/cable/high_voltage
	name = "high-voltage power cable"
	desc = "A flexible superconducting cable for heavy-duty station-wide power transfer."
	icon = 'icons/obj/power_cond/power_cond_white.dmi'
	icon_state = "0-1"
	level = 1
	anchored = TRUE
	on_blueprints = TRUE
	color = COLOR_RED

	//The following vars are set here for the benefit of mapping - they are reset when the cable is spawned
	alpha = 128	//is set to 255 when spawned
	plane = GAME_PLANE //is set to FLOOR_PLANE when spawned
	layer = LOW_OBJ_LAYER //isset to WIRE_LAYER when spawned

	power_voltage_type = VOLTAGE_HIGH
