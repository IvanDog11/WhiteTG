/datum/quirk/monochromatic
	name = "Монохромия"
	desc = "Не могу различать цвета и вижу весь мир в черно-белых тонах."
	icon = FA_ICON_ADJUST
	value = 0
	medical_record_text = "У пациента было обнаружено нарушение цветового зрения."
	mail_goodies = list( // Noir detective wannabe
		/obj/item/clothing/suit/jacket/det_suit/noir,
		/obj/item/clothing/suit/jacket/det_suit/dark,
		/obj/item/clothing/head/fedora/beige,
		/obj/item/clothing/head/fedora/white,
	)

/datum/quirk/monochromatic/add(client/client_source)
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_add()
	if(is_detective_job(quirk_holder.mind.assigned_role))
		to_chat(quirk_holder, span_boldannounce("Ммм. На этой станции нет ничего чистого. Это всё оттенки серого..."))
		quirk_holder.playsound_local(quirk_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	quirk_holder.remove_client_colour(/datum/client_colour/monochrome)
