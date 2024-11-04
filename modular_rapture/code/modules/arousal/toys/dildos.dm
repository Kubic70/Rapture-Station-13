/obj/item/dildo/ComponentInitialize() //SPLURT edit
	. = ..()
	var/list/procs_list = list(
		"before_inserting" = CALLBACK(src, PROC_REF(item_inserting)),
		"after_inserting" = CALLBACK(src, PROC_REF(item_inserted)),
		"after_removing" = CALLBACK(src, PROC_REF(item_removed)),
	)
	AddComponent(/datum/component/genital_equipment, list(ORGAN_SLOT_VAGINA, ORGAN_SLOT_BUTT), procs_list)

/obj/item/dildo/proc/item_inserting(datum/source, obj/item/organ/genital/G, mob/user)
	. = TRUE
	if(!(G.owner.client?.prefs?.erppref == "Yes"))
		to_chat(user, span_warning("They don't want you to do that!"))
		return FALSE

	if(user == G.owner)
		G.owner.visible_message(span_warning("\The <b>[user]</b> is trying to insert a <b>[src.name]</b> inside themselves!"),\
			span_warning("You try to insert a <b>[src.name]</b> inside yourself!"))
	else
		G.owner.visible_message(span_warning("\The <b>[user]</b> is trying to insert a <b>[src.name]</b> inside \the <b>[G.owner]</b>!"),\
			span_warning("\The <b>[user]</b> is trying to insert a <b>[src.name]</b> inside you!"))

	if(!do_mob(user, G.owner, 5 SECONDS))
		return FALSE

	if(user == G.owner)
		to_chat(user, span_userlove("[G] feel somthing big inside!"))
		var/mob/living/U = user
		U.handle_post_sex(NORMAL_LUST*dildo_size, null, user)
		playsound(user, 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1)

/obj/item/dildo/proc/item_inserted(datum/source, obj/item/organ/genital/G, mob/user)
	. = TRUE
	to_chat(user, span_userlove("You insert [src] in <b>\The [G.owner]</b>'s [G]."))
	playsound(G.owner, 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	START_PROCESSING(SSobj, src)

/obj/item/dildo/proc/item_removed(datum/source, obj/item/organ/genital/G, mob/user)
	. = TRUE
	to_chat(user, span_userlove("You retrieve [src] from <b>\The [G.owner]</b>'s [G]."))
	playsound(G.owner, 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	STOP_PROCESSING(SSobj, src)

/obj/item/dildo/process()
	var/obj/item/organ/genital/G = loc
	var/mob/living/carbon/human/target = G.owner
	if(!istype(target) || target.stat >= DEAD)
		sleep(60)
		return
	if(prob(25))
		to_chat(target, span_love(pick("I feel <b>[src.name]</b> inside my <b>[G.name]</b>!", "You feel a pleasure from <b>[src.name]</b> deep inside you <b>[G.name]</b>!")))
		target.handle_post_sex(LOW_LUST*dildo_size, null, target)
	sleep(rand(5,60))
