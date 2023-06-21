//this returns the mob's protection against eye damage (number between -1 and 2) from bright lights
/mob/living/proc/get_eye_protection()
	return 0

//this returns the mob's protection against ear damage (0:no protection; 1: some ear protection; 2: has no ears)
/mob/living/proc/get_ear_protection()
	return 0

/mob/living/proc/is_mouth_covered(head_only = 0, mask_only = 0)
	return FALSE

/mob/living/proc/is_eyes_covered(check_glasses = 1, check_head = 1, check_mask = 1)
	return FALSE

/mob/living/proc/on_hit(obj/item/projectile/P)
	return BULLET_ACT_HIT

/mob/living/proc/handle_projectile_attack_redirection(obj/item/projectile/P, redirection_mode, silent = FALSE)
	P.ignore_source_check = TRUE
	switch(redirection_mode)
		if(REDIRECT_METHOD_DEFLECT)
			P.setAngle(SIMPLIFY_DEGREES(P.Angle + rand(120, 240)))
			if(!silent)
				visible_message(span_danger("[P] gets deflected by [src]!"), \
					span_userdanger("You deflect [P]!"))
		if(REDIRECT_METHOD_REFLECT)
			P.setAngle(SIMPLIFY_DEGREES(P.Angle + 180))
			if(!silent)
				visible_message(span_danger("[P] gets reflected by [src]!"), \
					span_userdanger("You reflect [P]!"))
		if(REDIRECT_METHOD_PASSTHROUGH)
			if(!silent)
				visible_message(span_danger("[P] passes through [src]!"), \
					span_userdanger("[P] passes through you!"))
			return
		if(REDIRECT_METHOD_RETURN_TO_SENDER)
			if(!silent)
				visible_message(span_danger("[src] deflects [P] back at their attacker!"), \
					span_userdanger("You deflect [P] back at your attacker!"))
			if(P.firer)
				P.setAngle(Get_Angle(src, P.firer))
			else
				P.setAngle(SIMPLIFY_DEGREES(P.Angle + 180))
		else
			CRASH("Invalid rediretion mode [redirection_mode]")

// /mob/living/bullet_act(obj/item/projectile/P, def_zone)
// 	if(!istype(P)) // No projectile, no problem (here at least)
// 		return
// 	var/list/damage_list = SSdamage.shoot_target(P.firer, src, P, NONE, list())
// 	var/damage = GET_DAMAGE(damage_list)
// 	var/damage_in = max(P.damage, 0.01)
// 	knock_off_buckled_mobs(P, damage_list)
// 	var/final_percent = 100 - ((damage / damage_in) * 100)
// 	return P.on_hit(src, final_percent, def_zone) ? BULLET_ACT_HIT : BULLET_ACT_BLOCK



	// if(ranged_mob_grief(P))
	// 	if(ismob(P.firer))
	// 		var/mob/shootier = P.firer
	// 		shootier.show_message(span_alert("Your shot honorably misses your sleeping or wounded target!"))
	// 	return FALSE
	// var/totaldamage = P.damage
	// var/staminadamage = P.stamina
	// var/final_percent = 0
	// if(P.original != src || P.firer != src) //try to block or reflect the bullet, can't do so when shooting oneself
	// 	var/list/returnlist = list()
	// 	var/returned = mob_run_block(P, P.damage, "the [P.name]", ATTACK_TYPE_PROJECTILE, P.armour_penetration, P.firer, def_zone, returnlist)
	// 	final_percent = returnlist[BLOCK_RETURN_PROJECTILE_BLOCK_PERCENTAGE]
	// 	if(returned & BLOCK_SHOULD_REDIRECT)
	// 		handle_projectile_attack_redirection(P, returnlist[BLOCK_RETURN_REDIRECT_METHOD])
	// 		return BULLET_ACT_FORCE_PIERCE
	// 	if(returned & BLOCK_REDIRECTED)
	// 		return BULLET_ACT_FORCE_PIERCE
	// 	if(returned & BLOCK_SUCCESS)
	// 		P.on_hit(src, final_percent, def_zone)
	// 		return BULLET_ACT_BLOCK
	// 	totaldamage = block_calculate_resultant_damage(totaldamage, returnlist)
	// 	staminadamage = block_calculate_resultant_damage(staminadamage, returnlist)
	// var/armor = run_armor_check(def_zone, P.flag, null, null, P.armour_penetration, null)
	// var/dt = max(run_armor_check(def_zone, "damage_threshold", null, null, 0, null) - P.damage_threshold_modifier, 0)
	// if(!P.nodamage)
	// 	apply_damage(totaldamage, P.damage_type, def_zone, armor, wound_bonus = P.wound_bonus, bare_wound_bonus = P.bare_wound_bonus, sharpness = P.sharpness, damage_threshold = dt)
	// 	if(staminadamage)
	// 		apply_damage(staminadamage, STAMINA, def_zone, armor, wound_bonus = P.wound_bonus, bare_wound_bonus = P.bare_wound_bonus, sharpness = SHARP_NONE, damage_threshold = dt)
	// 	if(P.dismemberment)
	// 		check_damage_dismemberment(damage_list)
	// var/missing = 100 - final_percent
	// var/armor_ratio = armor * 0.01
	// if(missing > 0)
	// 	final_percent += missing * armor_ratio


/mob/living/proc/check_damage_dismemberment(obj/item/projectile/P, list/damage_list = DAMAGE_LIST)
	return 0

/obj/item/proc/get_volume_by_throwforce_and_or_w_class()
		if(throwforce && w_class)
				return clamp((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
		else if(w_class)
				return clamp(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
		else
				return 0

/mob/living/proc/catch_item(obj/item/I, skip_throw_mode_check = FALSE)
	return FALSE

/mob/living/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	// Throwingdatum can be null if someone had an accident() while slipping with an item in hand.
	var/obj/item/I
	var/throwpower = AM.throwforce || 30
	if(isitem(AM))
		I = AM
		throwpower = I.throwforce
	else
		playsound(loc, 'sound/weapons/genhit.ogg', 50, 1, -1)
		return ..()

	// var/list/block_return = list()
	// var/total_damage = AM.throwforce
	// if(mob_run_block(AM, throwpower, "\the [AM.name]", ATTACK_TYPE_THROWN, 0, throwingdatum?.thrower, impacting_zone, block_return) & BLOCK_SUCCESS)
	// 	hitpush = FALSE
	// 	skipcatch = TRUE
	// 	blocked = TRUE
	// 	total_damage = block_calculate_resultant_damage(total_damage, block_return)
	var/list/damage_list = SSdamage.collide_with_target(
		throwingdatum?.thrower,
		src,
		AM,
		throwpower,
		impacting_zone,
		attackchain_flags,
	)
	var/block_flags = LAZYACCESS(damage_list, DAMAGE_BLOCK_FLAGS)
	if(CHECK_BITFIELD(block_flags, BLOCK_SUCCESS))
		blocked = TRUE
	if(blocked)
		return TRUE
	var/nosell_hit = SEND_SIGNAL(I, COMSIG_MOVABLE_IMPACT_ZONE, src, impacting_zone, throwingdatum, FALSE, blocked)
	if(nosell_hit)
		skipcatch = TRUE
		hitpush = FALSE
	if(!skipcatch && isturf(I.loc) && catch_item(I))
		return TRUE
	var/damage = GET_DAMAGE(damage_list)
	var/dtype = GET_DAMAGE_TYPE(damage_list)

	if(COOLDOWN_FINISHED(src, projectile_message_antispam))
		COOLDOWN_START(src, projectile_message_antispam, ATTACK_MESSAGE_ANTISPAM_TIME)
		visible_message(
			span_danger("[src] is hit by [I]!"),
			span_userdanger("You're hit by [I]!")
		)
	return TRUE

/mob/living/mech_melee_attack(obj/mecha/M)
	if(M.occupant.a_intent == INTENT_HARM)
		if(HAS_TRAIT(M.occupant, TRAIT_PACIFISM))
			to_chat(M.occupant, span_warning("You don't want to harm other living beings!"))
			return
		M.do_attack_animation(src)
		if(M.damtype == "brute")
			step_away(src,M,15)
		switch(M.damtype)
			if(BRUTE)
				Unconscious(20)
				take_overall_damage(rand(M.force/2, M.force))
				playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			if(BURN)
				take_overall_damage(0, rand(M.force/2, M.force))
				playsound(src, 'sound/items/welder.ogg', 50, 1)
			if(TOX)
				M.mech_toxin_damage(src)
			else
				return
		updatehealth()
		visible_message(span_danger("[M.name] has hit [src]!"), \
						span_userdanger("[M.name] has hit you!"), null, COMBAT_MESSAGE_RANGE, null,
						M.occupant, span_danger("You hit [src] with your [M.name]!"))
		log_combat(M.occupant, src, "attacked", M, "(INTENT: [uppertext(M.occupant.a_intent)]) (DAMTYPE: [uppertext(M.damtype)])")
	else
		step_away(src,M)
		log_combat(M.occupant, src, "pushed", M)
		visible_message(span_warning("[M] pushes [src] out of the way."), \
			span_warning("[M] pushes you out of the way."), null, COMBAT_MESSAGE_RANGE, null,
			M.occupant, span_warning("You push [src] out of the way with your [M.name]."))

/mob/living/fire_act()
	adjust_fire_stacks(3)
	IgniteMob()

/// SRC is GRABBED by USER
/mob/living/proc/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	if(user == anchored || !isturf(user.loc))
		return FALSE

	if(user == src) //we want to be able to self click if we're voracious
		return FALSE

	if(!user.pulling || user.pulling != src)
		user.start_pulling(src, supress_message = supress_message)
		return

	if(!(status_flags & CANPUSH) || HAS_TRAIT(src, TRAIT_PUSHIMMUNE))
		to_chat(user, span_warning("[src] can't be grabbed more aggressively!"))
		return FALSE

	if(user.grab_state >= GRAB_AGGRESSIVE && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_notice("You don't want to risk hurting [src]!"))
		return FALSE

	grippedby(user)

//proc to upgrade a simple pull into a more aggressive grab.
/mob/living/proc/grippedby(mob/living/carbon/user, instant = FALSE)
	if(user.grab_state < GRAB_KILL)
		user.DelayNextAction(CLICK_CD_GRABBING, flush = TRUE)
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

		if(user.grab_state) //only the first upgrade is instantaneous
			var/old_grab_state = user.grab_state
			var/grab_upgrade_time = instant ? 0 : 30
			visible_message(span_danger("[user] starts to tighten [user.p_their()] grip on [src]!"), \
				span_userdanger("[user] starts to tighten [user.p_their()] grip on you!"), target = user,
				target_message = span_danger("You start to tighten your grip on [src]!"))
			switch(user.grab_state)
				if(GRAB_AGGRESSIVE)
					log_combat(user, src, "attempted to neck grab", addition="neck grab")
				if(GRAB_NECK)
					log_combat(user, src, "attempted to strangle", addition="kill grab")
			if(!do_mob(user, src, grab_upgrade_time))
				return 0
			if(!user.pulling || user.pulling != src || user.grab_state != old_grab_state || user.a_intent != INTENT_GRAB)
				return 0
		user.setGrabState(user.grab_state + 1)
		switch(user.grab_state)
			if(GRAB_AGGRESSIVE)
				var/add_log = ""
				if(HAS_TRAIT(user, TRAIT_PACIFISM))
					visible_message(span_danger("[user] has firmly gripped [src]!"),
						span_danger("[user] has firmly gripped you!"), target = user,
						target_message = span_danger("You have firmly gripped [src]!"))
					add_log = " (pacifist)"
				else
					visible_message(span_danger("[user] has grabbed [src] aggressively!"), \
									span_userdanger("[user] has grabbed you aggressively!"), target = user, \
									target_message = span_danger("You have grabbed [src] aggressively!"))
					update_mobility()
				stop_pulling()
				log_combat(user, src, "grabbed", addition="aggressive grab[add_log]")
			if(GRAB_NECK)
				log_combat(user, src, "grabbed", addition="neck grab")
				visible_message(span_danger("[user] has grabbed [src] by the neck!"),\
								span_userdanger("[user] has grabbed you by the neck!"), target = user, \
								target_message = span_danger("You have grabbed [src] by the neck!"))
				update_mobility() //we fall down
				if(!buckled && !density)
					Move(user.loc)
			if(GRAB_KILL)
				log_combat(user, src, "strangled", addition="kill grab")
				visible_message(span_danger("[user] is strangling [src]!"), \
								span_userdanger("[user] is strangling you!"), target = user, \
								target_message = span_danger("You are strangling [src]!"))
				update_mobility() //we fall down
				if(!buckled && !density)
					Move(user.loc)
		user.set_pull_offsets(src, grab_state)
		return 1

/mob/living/on_attack_hand(mob/user, act_intent = user.a_intent, attackchain_flags)
	..() //Ignoring parent return value here.
	SEND_SIGNAL(src, COMSIG_MOB_ATTACK_HAND, user)
	if((user != src) && act_intent != INTENT_HELP && (mob_run_block(user, 0, user.name, ATTACK_TYPE_UNARMED | ATTACK_TYPE_MELEE | ((attackchain_flags & ATTACK_IS_PARRY_COUNTERATTACK)? ATTACK_TYPE_PARRY_COUNTERATTACK : NONE), null, user, check_zone(user.zone_selected), null) & BLOCK_SUCCESS))
		log_combat(user, src, "attempted to touch")
		visible_message(span_warning("[user] attempted to touch [src]!"),
			span_warning("[user] attempted to touch you!"), target = user,
			target_message = span_warning("You attempted to touch [src]!"))
		return TRUE

/mob/living/attack_hulk(mob/living/carbon/human/user, does_attack_animation = FALSE)
	if(user.a_intent == INTENT_HARM)
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			to_chat(user, span_notice("You don't want to hurt [src]!"))
			return TRUE
		var/hulk_verb = pick("smash","pummel")
		if(user != src && (mob_run_block(user, 15, "the [hulk_verb]ing", ATTACK_TYPE_MELEE, null, user, check_zone(user.zone_selected), null) & BLOCK_SUCCESS))
			return TRUE
		..()
	return FALSE

/mob/living/attack_slime(mob/living/simple_animal/slime/M)
	if(!SSticker.HasRoundStarted())
		to_chat(M, "You cannot attack people before the game has started.")
		return
	if(M.buckled)
		if(M in buckled_mobs)
			M.Feedstop()
		return // can't attack while eating!
	var/list/damage_list = SSdamage.slime_attack(attacker = M, defender = src)
	log_combat(M, src, "attacked")
	M.do_attack_animation(src)
	visible_message(
		span_danger("The [M.name] glomps [src]!"),
		span_userdanger("The [M.name] glomps [src]!"),
		null,
		COMBAT_MESSAGE_RANGE,
		null,
		M,
		span_danger("You glomp [src]!")
	)
	return damage_list

/mob/living/attack_paw(mob/living/carbon/monkey/M)
	if(!M.CheckActionCooldown(CLICK_CD_MELEE))
		return
	M.DelayNextAction()
	if (M.a_intent == INTENT_HARM)
		var/list/damage_list = SSdamage.monkey_attack(attacker = M, defender = src)
		log_combat(M, src, "attacked")
		playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
		visible_message(
			span_danger("[M.name] bites [src]!"),
			span_userdanger("[M.name] bites you!"),
			null,
			COMBAT_MESSAGE_RANGE,
			null,
			M,
			span_danger("You bite [src]!")
		)
		return TRUE

/mob/living/attack_larva(mob/living/carbon/alien/larva/L)
	if(L.a_intent == INTENT_HELP)
		visible_message(
			span_notice("[L.name] rubs its head against [src]."),
			span_notice("[L.name] rubs its head against you."),
			target = L,
			target_message = span_notice("You rub your head against [src].")
		)
		return FALSE
	var/list/damage_list = SSdamage.larva_attack(attacker = L, defender = src)
	var/damage = GET_DAMAGE(damage_list)
	L.amount_grown = min(L.amount_grown + damage, L.max_grown)
	log_combat(L, src, "attacked")
	visible_message(
		span_danger("[L.name] bites [src]!"),
		span_userdanger("[L.name] bites you!"), 
		null,
		COMBAT_MESSAGE_RANGE,
		null,
		L,
		span_danger("You bite [src]!")
	)
	playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
	return TRUE

/mob/living/attack_alien(mob/living/carbon/alien/humanoid/M)
	switch(M.a_intent)
		if (INTENT_HELP)
			if(!isalien(src)) //I know it's ugly, but the alien vs alien attack_alien behaviour is a bit different.
				visible_message(span_notice("[M] caresses [src] with its scythe like arm."),
					span_notice("[M] caresses you with its scythe like arm."), target = M,
					target_message = span_notice("You caress [src] with your scythe like arm."))
			return FALSE
		if (INTENT_GRAB)
			grabbedby(M)
			return FALSE
		if(INTENT_HARM)
			if(isalien(src))
				return TRUE
			var/list/damage_list = SSdamage.alien_attack(attacker = M, defender = src)
			return DAMAGE_LIST
		if(INTENT_DISARM)
			if(!isalien(src))
				M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
			return TRUE

/mob/living/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	..()

//Looking for irradiate()? It's been moved to radiation.dm under the rad_act() for mobs.

/mob/living/acid_act(acidpwr, acid_volume)
	take_bodypart_damage(acidpwr * min(1, acid_volume * 0.1))
	return 1

///As the name suggests, this should be called to apply electric shocks.
/mob/living/proc/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	SEND_SIGNAL(src, COMSIG_LIVING_ELECTROCUTE_ACT, shock_damage, source, siemens_coeff, flags)
	shock_damage *= siemens_coeff
	if((flags & SHOCK_TESLA) && HAS_TRAIT(src, TRAIT_TESLA_SHOCKIMMUNE))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SHOCKIMMUNE))
		return FALSE
	if(shock_damage < 1)
		return FALSE
	if(!(flags & SHOCK_ILLUSION))
		adjustFireLoss(shock_damage)
	else
		adjustStaminaLoss(shock_damage)
	visible_message(
		span_danger("[src] was shocked by \the [source]!"), \
		span_userdanger("You feel a powerful shock coursing through your body!"), \
		span_hear("You hear a heavy electrical crack.") \
	)
	return shock_damage

/mob/living/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/obj/O in contents)
		O.emp_act(severity)

/mob/living/singularity_act()
	var/gain = 20
	investigate_log("([key_name(src)]) has been consumed by the singularity.", INVESTIGATE_SINGULO) //Oh that's where the clown ended up!
	gib()
	return(gain)

/mob/living/narsie_act()
	if(status_flags & GODMODE || QDELETED(src))
		return

	if(is_servant_of_ratvar(src) && !stat)
		to_chat(src, "<span class='userdanger'>You resist Nar'Sie's influence... but not all of it. <i>Run!</i></span>")
		adjustBruteLoss(35)
		if(src && reagents)
			reagents.add_reagent(/datum/reagent/toxin/heparin, 5)
		return FALSE
	if(GLOB.cult_narsie && GLOB.cult_narsie.souls_needed[src])
		GLOB.cult_narsie.souls_needed -= src
		GLOB.cult_narsie.souls += 1
		if((GLOB.cult_narsie.souls == GLOB.cult_narsie.soul_goal) && (GLOB.cult_narsie.resolved == FALSE))
			GLOB.cult_narsie.resolved = TRUE
			sound_to_playing_players('sound/machines/alarm.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, .proc/cult_ending_helper, 1), 120)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/ending_helper), 270)
	if(client)
		INVOKE_ASYNC(GLOBAL_PROC, .proc/makeNewConstruct, /mob/living/simple_animal/hostile/construct/harvester, src, null, TRUE) // must pass keyword args explicitly
	else
		switch(rand(1, 6))
			if(1)
				new /mob/living/simple_animal/hostile/construct/armored/hostile(get_turf(src))
			if(2)
				new /mob/living/simple_animal/hostile/construct/wraith/hostile(get_turf(src))
			if(3 to 6)
				new /mob/living/simple_animal/hostile/construct/builder/hostile(get_turf(src))
	spawn_dust()
	gib()
	return TRUE


/mob/living/ratvar_act()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD && !is_servant_of_ratvar(src))
		to_chat(src, "<span class='userdanger'>A blinding light boils you alive! <i>Run!</i></span>")
		adjust_fire_stacks(20)
		IgniteMob()
		return FALSE


//called when the mob receives a bright flash
/mob/living/proc/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /obj/screen/fullscreen/flash)
	if(get_eye_protection() < intensity && (override_blindness_check || !(HAS_TRAIT(src, TRAIT_BLIND))))
		overlay_fullscreen("flash", type)
		addtimer(CALLBACK(src, .proc/clear_fullscreen, "flash", 25), 25)
		return TRUE
	return FALSE

//called when the mob receives a loud bang
/mob/living/proc/soundbang_act()
	return 0

//to damage the clothes worn by a mob
/mob/living/proc/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	return


/mob/living/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!used_item)
		used_item = get_active_held_item()
	..()
	floating_need_update = TRUE


/mob/living/proc/getBruteLoss_nonProsthetic()
	return getBruteLoss()

/mob/living/proc/getFireLoss_nonProsthetic()
	return getFireLoss()
