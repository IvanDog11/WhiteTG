/obj/item/style_meter
	name = "измеритель стиля"
	desc = "Прикрепите это к очкам, чтобы установить в них систему измерения стиля. \
		Вы получаете очки стиля за выполнение стильных действий и теряете их за нарушение своего стиля. \
		Стиль влияет на качество вашей добычи, и вы можете добывать руду лучше во время хорошей цепочки. \
		Отзывчивый HUD данных дает вам возможность отражать лавалендские снаряды, ударив их пустой рукой. \
		Кроме того, при высоком уровне стиля вы можете поменять предмет в руке на тот, который находится в вашем рюкзаке, <b>ударив</b> один другим."
	icon_state = "style_meter"
	icon = 'icons/obj/clothing/glasses.dmi'
	/// The style meter component we give.
	var/datum/component/style/style_meter
	/// Mutable appearance added to the attached glasses
	var/mutable_appearance/meter_appearance
	/// If this is multitooled, which is passed onto the component on-creation, if one doesn't currently exist
	var/multitooled = FALSE

/obj/item/style_meter/Initialize(mapload)
	. = ..()
	meter_appearance = mutable_appearance(icon, icon_state)
	RegisterSignal(src, COMSIG_ATOM_TOOL_ACT(TOOL_MULTITOOL), PROC_REF(on_multitool))

/obj/item/style_meter/Destroy(force)
	if(istype(loc, /obj/item/clothing/glasses))
		clean_up(loc)
	return ..()

/obj/item/style_meter/examine(mob/user)
	. = ..()
	. += span_notice("Кажется, я моуг использовать <b>мультитул<b> на этом.")

/obj/item/style_meter/afterattack(atom/movable/attacked_atom, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!istype(attacked_atom, /obj/item/clothing/glasses))
		return

	forceMove(attacked_atom)
	attacked_atom.add_overlay(meter_appearance)
	RegisterSignal(attacked_atom, COMSIG_ITEM_EQUIPPED, PROC_REF(check_wearing))
	RegisterSignal(attacked_atom, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(attacked_atom, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(attacked_atom, COMSIG_CLICK_ALT, PROC_REF(on_altclick))
	RegisterSignal(attacked_atom, COMSIG_ATOM_TOOL_ACT(TOOL_MULTITOOL), PROC_REF(on_multitool))
	balloon_alert(user, "измеритель стиля прикреплен")
	playsound(src, 'sound/machines/click.ogg', 30, TRUE)
	if(!iscarbon(attacked_atom.loc))
		return

	var/mob/living/carbon/carbon_wearer = attacked_atom.loc
	if(carbon_wearer.glasses != attacked_atom)
		return

	style_meter = carbon_wearer.AddComponent(/datum/component/style, multitooled)

/obj/item/style_meter/Moved(atom/old_loc, Dir, momentum_change)
	. = ..()
	if(!istype(old_loc, /obj/item/clothing/glasses))
		return
	clean_up(old_loc)


/// Check if the glasses that this meter is linked with are being worn
/obj/item/style_meter/proc/check_wearing(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(!(slot & ITEM_SLOT_EYES))
		if(style_meter)
			QDEL_NULL(style_meter)
		return

	style_meter = equipper.AddComponent(/datum/component/style, multitooled)


/// Signal proc for when the meter-holding glasses are dropped/unequipped
/obj/item/style_meter/proc/on_drop(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!style_meter)
		return

	QDEL_NULL(style_meter)


/// Signal proc for on-examine
/obj/item/style_meter/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("Кажется, я могу использовать <b>мультитул</b> на этом.")
	examine_list += span_notice("<b>Alt-клик</b> чтобы убрать измеритель стиля.")


/// Signal proc to remove from glasses
/obj/item/style_meter/proc/on_altclick(datum/source, mob/user)
	SIGNAL_HANDLER

	if(istype(loc, /obj/item/clothing/glasses))
		clean_up()
		forceMove(get_turf(src))

	return COMPONENT_CANCEL_CLICK_ALT


/// Signal proc for when the glasses or the meter is multitooled
/obj/item/style_meter/proc/on_multitool(datum/source, mob/living/user, obj/item/tool, list/recipes)
	multitooled = !multitooled
	if(style_meter)
		SEND_SIGNAL(style_meter, COMSIG_ATOM_TOOL_ACT(TOOL_MULTITOOL), user, tool, recipes)
	else
		balloon_alert(user, "измеритель [multitooled ? "взломан" : "нормальный"]")


/// Unregister signals and just generally clean up ourselves after being removed from glasses
/obj/item/style_meter/proc/clean_up(atom/movable/old_location)
	old_location.cut_overlay(meter_appearance)
	UnregisterSignal(old_location, COMSIG_ITEM_EQUIPPED)
	UnregisterSignal(old_location, COMSIG_ITEM_DROPPED)
	UnregisterSignal(old_location, COMSIG_ATOM_EXAMINE)
	UnregisterSignal(old_location, COMSIG_ATOM_TOOL_ACT(TOOL_MULTITOOL))
	if(!style_meter)
		return
	QDEL_NULL(style_meter)


/atom/movable/screen/style_meter_background
	icon_state = "style_meter_background"
	icon = 'icons/hud/style_meter.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "WEST,CENTER:16"
	maptext_height = 120
	maptext_width = 105
	maptext_x = 5
	maptext_y = 100
	maptext = ""
	layer = SCREENTIP_LAYER

/atom/movable/screen/style_meter
	icon_state = "style_meter"
	icon = 'icons/hud/style_meter.dmi'
	layer = SCREENTIP_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
