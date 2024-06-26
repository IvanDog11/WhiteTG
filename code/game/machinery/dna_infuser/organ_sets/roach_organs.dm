#define ROACH_ORGAN_COLOR "#7c4200"
// Yeah i'm lazy and we don't use any of the other color slots
#define ROACH_COLORS ROACH_ORGAN_COLOR + ROACH_ORGAN_COLOR + ROACH_ORGAN_COLOR

/datum/armor/roach_internal_armor
	bomb = 100
	bio = 90

/datum/status_effect/organ_set_bonus/roach
	id = "organ_set_bonus_roach"
	organs_needed = 4
	bonus_activate_text = span_notice("ДНК таракана теперь часть меня! Я чувствую, что моё тело стало более устойчивым к взрывам, радиации и вирусам.")
	bonus_deactivate_text = span_notice("Я больше не таракан, и я чувствую, что моё тело не переживёт ядерный апокалипсис.")

	// - Immunity to nuke gibs
	// - Nukes come with radiation (not actually but yknow)
	bonus_traits = list(TRAIT_NUKEIMMUNE, TRAIT_RADIMMUNE, TRAIT_VIRUS_RESISTANCE)
	/// Armor type attached to the owner's physiology
	var/datum/armor/given_armor = /datum/armor/roach_internal_armor
	/// Storing biotypes pre-organ bonus applied so we don't remove bug from mobs which should have it.
	var/old_biotypes = NONE

/datum/status_effect/organ_set_bonus/roach/enable_bonus()
	. = ..()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.armor = human_owner.physiology.armor.add_other_armor(given_armor)

	old_biotypes = human_owner.mob_biotypes
	human_owner.mob_biotypes |= MOB_BUG

/datum/status_effect/organ_set_bonus/roach/disable_bonus()
	. = ..()
	if(!ishuman(owner) || QDELETED(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.armor = human_owner.physiology.armor.subtract_other_armor(given_armor)

	if(!(old_biotypes & MOB_BUG)) // only remove bug if it wasn't there before
		human_owner.mob_biotypes &= ~MOB_BUG

/// Roach heart:
/// Reduces damage taken from brute attacks from behind,
/// but increases duration of knockdowns
/obj/item/organ/internal/heart/roach
	name = "сердце таракана"
	desc = "ДНК таракана внедрена в то, что когда-то было обычным сердцем."
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "heart"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = ROACH_COLORS

	/// Bodypart overlay applied to the chest the heart is in
	var/datum/bodypart_overlay/simple/roach_shell/roach_shell

	COOLDOWN_DECLARE(harden_effect_cd)

/obj/item/organ/internal/heart/roach/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "кожа выглядит слека полупрозрачной.")
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/roach)
	roach_shell = new()

/obj/item/organ/internal/heart/roach/Destroy()
	QDEL_NULL(roach_shell)
	return ..()

/obj/item/organ/internal/heart/roach/on_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	if(!ishuman(organ_owner))
		return

	var/mob/living/carbon/human/human_owner = organ_owner

	RegisterSignal(human_owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(modify_damage))
	RegisterSignal(human_owner, COMSIG_MOB_AFTER_APPLY_DAMAGE, PROC_REF(do_block_effect))
	human_owner.physiology.knockdown_mod *= 3

	var/obj/item/bodypart/chest/chest = human_owner.get_bodypart(BODY_ZONE_CHEST)
	chest.add_bodypart_overlay(roach_shell)
	human_owner.update_body_parts()

/obj/item/organ/internal/heart/roach/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	if(!ishuman(organ_owner) || QDELETED(organ_owner))
		return

	var/mob/living/carbon/human/human_owner = organ_owner

	UnregisterSignal(human_owner, list(COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, COMSIG_MOB_AFTER_APPLY_DAMAGE))
	human_owner.physiology.knockdown_mod /= 3

	var/obj/item/bodypart/chest/chest = human_owner.get_bodypart(BODY_ZONE_CHEST)
	chest.remove_bodypart_overlay(roach_shell)
	human_owner.update_body_parts()

/**
 * Signal proc for [COMSIG_MOB_APPLY_DAMAGE_MODIFIERS]
 *
 * Adds a 0.5 modifier to attacks from the back
 */
/obj/item/organ/internal/heart/roach/proc/modify_damage(mob/living/carbon/human/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER

	if(!is_blocking(source, damage_amount, damagetype, attack_direction))
		return

	damage_mods += 0.5

/**
 * Signal proc for [COMSIG_MOB_AFTER_APPLY_DAMAGE]
 *
 * Does a special effect if we blocked damage with our back
 */
/obj/item/organ/internal/heart/roach/proc/do_block_effect(mob/living/carbon/human/source, damage_dealt, damagetype, def_zone, blocked, wound_bonus, bare_wound_bonus, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER

	if(!is_blocking(source, damage_dealt, damagetype, attack_direction))
		return

	if(COOLDOWN_FINISHED(src, harden_effect_cd))
		source.visible_message(span_warning("Спина [source] отражает удар!"))
		playsound(source, 'sound/effects/constructform.ogg', 25, vary = TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	COOLDOWN_START(src, harden_effect_cd, 5 SECONDS) // Cooldown resets EVERY time we get hit

/// Checks if the passed mob is in a valid state to be blocking damage with the roach shell
/obj/item/organ/internal/heart/roach/proc/is_blocking(mob/living/carbon/human/blocker, damage_amount, damagetype, attack_direction)
	if(damage_amount < 5 || damagetype != BRUTE || !attack_direction)
		return
	if(!ishuman(blocker) || blocker.stat >= UNCONSCIOUS)
		return FALSE
	// No tactical spinning
	if(blocker.flags_1 & IS_SPINNING_1)
		return FALSE
	if(blocker.body_position == LYING_DOWN || (blocker.dir & attack_direction))
		return TRUE
	return FALSE

// Simple overlay so we can add a roach shell to guys with roach hearts
/datum/bodypart_overlay/simple/roach_shell
	icon_state = "roach_shell"
	layers = EXTERNAL_FRONT|EXTERNAL_BEHIND

/datum/bodypart_overlay/simple/roach_shell/get_image(image_layer, obj/item/bodypart/limb)
	return image(
		icon = icon,
		icon_state = "[icon_state]_[mutant_bodyparts_layertext(image_layer)]",
		layer = image_layer,
	)

/// Roach stomach:
/// Makes disgust a non-issue, very slightly worse at passing off reagents
/// Also makes you more hungry
/obj/item/organ/internal/stomach/roach
	name = "желудок таракана"
	desc = "ДНК таракана внедрена в то, что когда-то было обычным желудком."
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	disgust_metabolism = 32 // Demolishes any disgust we have
	metabolism_efficiency = 0.033 // Slightly worse at transferring reagents
	hunger_modifier = 3

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "stomach"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = ROACH_COLORS

/obj/item/organ/internal/stomach/roach/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/roach)

/// Roach liver:
/// Purges toxins at a higher threshold, but takes more damage from them if not purged
/obj/item/organ/internal/liver/roach
	name = "печень таракана"
	desc = "ДНК таракана внедрено в то, что когда-то было обычной печенью."
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 5 // More tolerance for toxins
	liver_resistance = 0.25 // But if they manage to get in you're screwed

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "liver"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = ROACH_COLORS

/obj/item/organ/internal/liver/roach/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/roach)

/obj/item/organ/internal/liver/roach/on_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	if(!ishuman(organ_owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.tox_mod *= 2

/obj/item/organ/internal/liver/roach/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	if(!ishuman(organ_owner) || QDELETED(organ_owner))
		return

	var/mob/living/carbon/human/human_owner = organ_owner
	human_owner.physiology.tox_mod /= 2

/// Roach appendix:
/// No appendicitus! weee!
/obj/item/organ/internal/appendix/roach
	name = "аппендикс таракана"
	desc = "ДНК таракана внедрена в то, что когда-то было обычным аппендиксом."
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD

	icon = 'icons/obj/medical/organs/infuser_organs.dmi'
	icon_state = "appendix"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = ROACH_COLORS

/obj/item/organ/internal/appendix/roach/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/roach)

/obj/item/organ/internal/appendix/roach/become_inflamed()
	return

#undef ROACH_ORGAN_COLOR
#undef ROACH_COLORS
