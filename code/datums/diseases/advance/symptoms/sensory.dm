/* Mind Restoration
 * Slight stealth reduction
 * Reduces resistance
 * Slight increase to stage speed
 * Greatly decreases transmissibility
 * Critical level
*/
/datum/symptom/mind_restoration
	name = "Восстановление разума"
	desc = "Вирус укрепляет связи между нейронами, сокращая продолжительность любых психических заболеваний."
	stealth = -1
	resistance = -2
	stage_speed = 1
	transmittable = -3
	level = 5
	symptom_delay_min = 5
	symptom_delay_max = 10
	var/purge_alcohol = FALSE
	var/trauma_heal_mild = FALSE
	var/trauma_heal_severe = FALSE
	threshold_descs = list(
		"Сопротивление 6" = "Лечит незначительные травмы головного мозга.",
		"Сопротивление 9" = "Лечит тяжелые травмы головного мозга.",
		"Передача 8" = "Удаляет алкоголь из кровотока.",
	)

/datum/symptom/mind_restoration/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalResistance() >= 6) //heal brain damage
		trauma_heal_mild = TRUE
	if(A.totalResistance() >= 9) //heal severe traumas
		trauma_heal_severe = TRUE
	if(A.totalTransmittable() >= 8) //purge alcohol
		purge_alcohol = TRUE

/datum/symptom/mind_restoration/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/M = A.affected_mob


	if(A.stage >= 3)
		M.adjust_dizzy(-4 SECONDS)
		M.adjust_drowsiness(-4 SECONDS)
		// All slurring effects get reduced down a bit
		for(var/datum/status_effect/speech/slurring/slur in M.status_effects)
			slur.remove_duration(1 SECONDS)

		M.adjust_confusion(-2 SECONDS)
		if(purge_alcohol)
			M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 3)
			M.adjust_drunk_effect(-5)

	if(A.stage >= 4)
		M.adjust_drowsiness(-4 SECONDS)
		if(M.reagents.has_reagent(/datum/reagent/toxin/mindbreaker))
			M.reagents.remove_reagent(/datum/reagent/toxin/mindbreaker, 5)
		if(M.reagents.has_reagent(/datum/reagent/toxin/histamine))
			M.reagents.remove_reagent(/datum/reagent/toxin/histamine, 5)

		M.adjust_hallucinations(-20 SECONDS)

	if(A.stage >= 5)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3)
		if(trauma_heal_mild && iscarbon(M))
			var/mob/living/carbon/C = M
			if(prob(10))
				if(trauma_heal_severe)
					C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_SURGERY)
				else
					C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)



/datum/symptom/sensory_restoration
	name = "Сенсорное восстановление"
	desc = "Вирус стимулирует производство и замену сенсорных тканей, заставляя хозяина регенерировать глаза и уши при повреждении."
	stealth = 0
	resistance = 1
	stage_speed = -2
	transmittable = 2
	level = 4
	base_message_chance = 7
	symptom_delay_min = 1
	symptom_delay_max = 1

/datum/symptom/sensory_restoration/Activate(datum/disease/advance/advanced_disease)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/infected_mob = advanced_disease.affected_mob
	switch(advanced_disease.stage)
		if(4, 5)
			if(advanced_disease.has_required_infectious_organ(infected_mob, ORGAN_SLOT_EARS))
				var/obj/item/organ/internal/ears/ears = infected_mob.get_organ_slot(ORGAN_SLOT_EARS)
				ears.adjustEarDamage(-4, -4)

			if(!advanced_disease.has_required_infectious_organ(infected_mob, ORGAN_SLOT_EYES))
				return

			var/obj/item/organ/internal/eyes/eyes = infected_mob.get_organ_slot(ORGAN_SLOT_EYES)
			infected_mob.adjust_temp_blindness(-4 SECONDS)
			infected_mob.adjust_eye_blur(-4 SECONDS)

			eyes.apply_organ_damage(-2)
			if(prob(20))
				if(infected_mob.is_blind_from(EYE_DAMAGE))
					to_chat(infected_mob, span_warning("Зрение возвращается..."))
					infected_mob.adjust_eye_blur(20 SECONDS)

				else if(infected_mob.is_nearsighted_from(EYE_DAMAGE))
					to_chat(infected_mob, span_warning("Темнота уходит из периферийного зрения."))
					infected_mob.adjust_eye_blur(5 SECONDS)

		else
			if(prob(base_message_chance))
				to_chat(infected_mob, span_notice("[pick("Глазам стало лучше.","Глаза теперь могут видеть лучше.", "Можно не моргать.","Ушам стало лучше.","Слышу всё гораздо лучше.")]"))
