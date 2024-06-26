/// Marks the item as being radiation protected.
/// Adds the TRAIT_RADIATION_PROTECTED_CLOTHING trait, as well as adding an
/// extra bit to the examine descrpition.
/datum/element/radiation_protected_clothing

/datum/element/radiation_protected_clothing/Attach(datum/target)
	. = ..()

	if (!isclothing(target))
		return ELEMENT_INCOMPATIBLE

	ADD_TRAIT(target, TRAIT_RADIATION_PROTECTED_CLOTHING, REF(src))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/element/radiation_protected_clothing/Detach(datum/source, ...)
	REMOVE_TRAIT(source, TRAIT_RADIATION_PROTECTED_CLOTHING, REF(src))
	UnregisterSignal(source, COMSIG_ATOM_EXAMINE)

	return ..()

/datum/element/radiation_protected_clothing/proc/on_examine(datum/source, mob/user, list/examine_text)
	SIGNAL_HANDLER

	examine_text += span_notice("Патч с символом радиационной опасности на боку намекает, что он <b>защищает вас от радиации</b>.")
