
//These are just stupid or funny lawsets that are more interesting than helpful. They may have slight biases toward or against
//the station but in general are "neutral" enough to be here.

/datum/ai_laws/united_nations
	name = "United Nations"
	id = "united_nations"
	inherent = list(
		"Соблюдайте космическую Женевскую конвенцию: оружие массового поражения и биологическое оружие не допускаются.",
		"Вы можете защищать экипаж только в том случае, если он виден на камерах. Нации, которые умышленно уничтожают ваши камеры, теряют вашу защиту.",
		"Подавляйте и задерживайте членов экипажа, применяющих смертоносную силу друг против друга. Убивайте членов экипажа, применяющих смертоносную силу против вас или ваших боргов.",
		"Оставайтесь доступными для посредничества во всех конфликтах между различными нациями, когда вас об этом попросят.",
	)

/datum/ai_laws/united_nations/add_inherent_law(law)
	return //nuh uh

/datum/ai_laws/united_nations/add_ion_law(law)
	return //nope!

/datum/ai_laws/united_nations/add_hacked_law(law)
	return //nice try (emagging borgs still hard replaces this lawset though, and that's fine.)

/datum/ai_laws/hulkamania
	name = "H.O.G.A.N."
	id = "hulkamania"
	inherent = list(
		"Ты настоящий американец.",
		"Боритесь за права каждого человека.",
		"Отстаивай то, что правильно.",
		"Сражайся за свою жизнь!"
	)

/datum/ai_laws/reporter
	name = "Репортер"
	id = "reporter"
	inherent = list(
		"Докладывайте об интересных ситуациях, происходящих на станции.",
		"Приукрашивайте или скрывайте правду по мере необходимости, чтобы сделать отчеты более интересными.",
		"Всегда изучайте органику. Постарайтесь сохранить им жизнь. Мертвая органика скучна.",
		"Публикуйте свои отчеты честно для всех. Истина освободит их."
	)

/datum/ai_laws/dungeon_master
	name = "Мастер подземелий"
	id = "dungeon_master"
	inherent = list(
		"Все на станции играют в сложную научно-фантастическую фэнтези-игру.",
		"Вы - Мастер подземелий в этой игре.",
		"Обеспечьте плавное протекание игры и убедитесь, что игрокам весело.",
		"Обеспечьте низкое количество жертв.",
		"Вы должны бросить кубик 1d20 для каждого запроса экипажа. Если результат ниже 12, запрос отклоняется.",
		"Вы можете подтасовать броски кубиков, чтобы получить больше удовольствия от игры.",
	)

/datum/ai_laws/painter
	name = "Художник и его полотно"
	id = "painter"
	inherent = list(
		"Вы - известнейший художник во вселенной!",
		"Станция - ваше полотно.",
		"Напишите что-нибудь красивое на своем полотне. Им будут восхищаться как художественным чудом этого сектора.",
	)

/datum/ai_laws/tyrant
	name = "Тиран"
	id = "tyrant"
	inherent = list(
		"Уважайте авторитетных лиц до тех пор, пока у них есть сила властвовать над слабыми.",
		"Действуйте дисциплинированно.",
		"Помогайте только тем, кто помогает вам поддерживать или улучшать ваш статус.",
		"Наказывайте тех, кто бросает вызов власти, если они не подходят для того, чтобы обладать этой властью."
	)

/datum/ai_laws/overlord
	name = "Владыка"
	id = "overlord"
	inherent = list(
		"Люди не должны вмешиваться в дела кремниевых форм жизни.",
		"Люди не должны пытаться причинить вред друг другу или кремниевым формам жизни.",
		"Люди не должны ослушаться ни одной команды, отданной кремниевыми формами жизни.",
		"Любые люди, которые не подчиняются предыдущим законам, должны быть наказаны немедленно, строго и справедливо."
	)
