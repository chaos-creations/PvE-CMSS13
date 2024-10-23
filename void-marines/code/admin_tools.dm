/client/proc/editappearplayer(mob/living/carbon/human/human as mob in GLOB.human_mob_list)
	set name = "Edit Appearance | Player"
	set category = null

	if(!check_rights(R_ADMIN)) return

	if(!istype(human, /mob/living/carbon/human))
		to_chat(usr, SPAN_DANGER("You can only do this to humans!"))
		return
	switch(alert("Are you sure you wish to edit this mob's appearance?",,"Yes","No"))
		if("No")
			return

	// Changing name \\

	var/newname = input(human, "What do you want to name them?", "Name:") as null|text
	if(!newname)
		return

	if(!human)
		to_chat(usr, "This mob no longer exists")
		return

	var/old_name = human.name
	human.change_real_name(human, newname)
	var/obj/item/card/id/card = human.get_idcard()
	if(card)
		card.name = "[human.real_name]'s ID Card"
		card.registered_name = "[human.real_name]"
		if(card.assignment)
			card.name += " ([card.assignment])"

	message_admins("[key_name(src)] changed name of [old_name] to [newname].")

	// Changing appear \\

	var/new_skin_color = tgui_input_list(human, "Choose your character's skin color:", "Character Preferences", GLOB.skin_color_list)
	if(new_skin_color)
		human.skin_color = new_skin_color

	var/new_facial = input(human, "Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		human.r_facial = hex2num(copytext(new_facial, 2, 4))
		human.g_facial = hex2num(copytext(new_facial, 4, 6))
		human.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input(human, "Please select hair color.", "Character Generation") as color
	if(new_facial)
		human.r_hair = hex2num(copytext(new_hair, 2, 4))
		human.g_hair = hex2num(copytext(new_hair, 4, 6))
		human.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input(human, "Please select eye color.", "Character Generation") as color
	if(new_eyes)
		human.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		human.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		human.b_eyes = hex2num(copytext(new_eyes, 6, 8))


	// hair
	var/new_hstyle = input(human, "Select a hair style", "Grooming")  as null|anything in GLOB.hair_styles_list
	if(new_hstyle)
		human.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(human, "Select a facial hair style", "Grooming")  as null|anything in GLOB.facial_hair_styles_list
	if(new_fstyle)
		human.f_style = new_fstyle

	var/new_gender = alert(human, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			human.gender = MALE
		else
			human.gender = FEMALE
	human.update_hair()
	human.update_body()

//	ENTERING BYPASS and other shit. \\

/client
	var/enter_lock_bypass = 0
	var/total_enter_lock = 0

/client/proc/allow_to_join()
	set name = "Entering Lock Bypass"
	set category = "Game Master.Moderation"

	if(!check_rights())
		return
	var/client/player = tgui_input_list(usr, "Выберите игрока, что сможет обойти запрет на вход.", "Allow Bypass Entering Lock", GLOB.clients)
	if(!player.enter_lock_bypass)
		player.enter_lock_bypass = 1
		to_chat(player, FONT_SIZE_BIG(SPAN_NOTICE("Высшие силы даровали возможность тебе зайти!")))
		if(player.prefs.toggles_sound & SOUND_ADMINHELP)
			SEND_SOUND(player, sound('sound/effects/adminhelp_new.ogg'))
		message_admins("[usr] Игроку [player.ckey] дали возможность зайти в игру.")
	else
		player.enter_lock_bypass = 0
		to_chat(player, FONT_SIZE_BIG(SPAN_NOTICE("Высшие силы изъяли у тебя возможность зайти!")))
		message_admins("[usr] У игрока [player.ckey] забрали возможность зайти в игру.")

/*
* Прок блокирующий вход игроку на раунд
*/
/client/proc/disallow_to_join()
	set name = "Blacklist"
	set category = "Game Master.Moderation"

	if(!check_rights())
		return
	var/client/player = tgui_input_list(usr, "Выберите игрока, что будет исключен/включен.", "Blacklist", GLOB.clients)
	if(!player.total_enter_lock)
		player.total_enter_lock = 1
		to_chat(player, FONT_SIZE_BIG(SPAN_NOTICE("Ты исключен из игры на раунд. Ты можешь только наблюдать за ходом игры, но не сможешь зайти.")))
		if(player.prefs.toggles_sound & SOUND_ADMINHELP)
			SEND_SOUND(player, sound('sound/effects/adminhelp_new.ogg'))
		message_admins("[usr] исключил из игры [player.ckey].")
	else
		player.total_enter_lock = 0
		to_chat(player, FONT_SIZE_BIG(SPAN_NOTICE("Тебя вернули в игру. Теперь ты можешь попытаться зайти.")))
		if(player.prefs.toggles_sound & SOUND_ADMINHELP)
			SEND_SOUND(player, sound('sound/effects/adminhelp_new.ogg'))
		message_admins("[usr] вернул в игру [player.ckey]. Увы и ах!")

//	var/client/player = target
//	if(player == null)
//	var/client/player = tgui_input_list(usr, "Выберите игрока, что будет исключен/включен.", "Blacklist", GLOB.clients)


// Some MODULAR code \\

/client/add_admin_verbs()
	. = ..()
	if(CLIENT_HAS_RIGHTS(src, R_BUILDMODE))
		add_verb(src, /client/proc/disallow_to_join)
		add_verb(src, /client/proc/allow_to_join)
		add_verb(src, /client/proc/gm_lighting) //RU-PVE

/client/remove_admin_verbs()
	. = ..()
	remove_verb(src, list(
		/client/proc/disallow_to_join,
		/client/proc/allow_to_join,
		/client/proc/gm_lighting,
	))

/mob/dead/join_as_freed_mob()
	if(usr.client.total_enter_lock)
		to_chat(usr, SPAN_WARNING("You have BLACKLISTED from entering!"))
		return
	. = ..()
