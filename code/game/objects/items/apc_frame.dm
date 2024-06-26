// APC HULL
/obj/item/wallframe/apc
	name = "рамка электрощитка"
	desc = "Используется для ремонта или создания электрощитков."
	icon_state = "apc"
	result_path = /obj/machinery/power/apc/auto_name

/obj/item/wallframe/apc/try_build(turf/on_wall, user)
	if(!..())
		return
	var/turf/T = get_turf(on_wall) //the user is not where it needs to be.
	var/area/A = get_area(user)
	if(A.apc)
		to_chat(user, span_warning("Здесь уже есть электрощиток!"))
		return //only one APC per area
	if(!A.requires_power)
		to_chat(user, span_warning("Не могу установить [src] здесь!"))
		return //can't place apcs in areas with no power requirement
	for(var/obj/machinery/power/terminal/E in T)
		if(E.master)
			to_chat(user, span_warning("Здесь уже есть терминал!"))
			return
		else
			new /obj/item/stack/cable_coil(T, 10)
			to_chat(user, span_notice("Отрезаю провода старого терминала и ставлю новые."))
			qdel(E)
	return TRUE

/obj/item/wallframe/apc/screwdriver_act(mob/living/user, obj/item/tool)
	//overriding the wallframe parent screwdriver act with this one which allows applying to existing apc frames.

	var/turf/T = get_step(get_turf(user), user.dir)
	if(iswallturf(T))
		if(locate(/obj/machinery/power/apc) in get_turf(user))
			var/obj/machinery/power/apc/mounted_apc = locate(/obj/machinery/power/apc) in get_turf(user)
			mounted_apc.attackby(src, user)
			return TOOL_ACT_TOOLTYPE_SUCCESS
		T.attackby(src, user)
	return TOOL_ACT_TOOLTYPE_SUCCESS

