/// SAVE FOLDER FORMAT:
/// master folder: data/exp/
/// current folder: data/exp/current/
/// backup folder: data/exp/backup-<roundnum>/
/// Inside the current folder:
/// ckey folder: data/exp/current/<ckey>/
/// Inside the ckey folder:
/// uid folder: data/exp/current/<ckey>/<char_uid>/
/// Inside the uid folder:
/// exp file: data/exp/current/<ckey>/<char_uid>/exp-<key>.json
/// Inside the backup folder:
/// A copy of the current folder, but with the roundnum in the name

SUBSYSTEM_DEF(experience)
	name = "experience"
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 10 SECONDS
	priority = FIRE_PRIORITY_XP

	var/list/all_lvls = list()

	var/list/uids_associated_with_ckey = list()

	/// uids that need to be loaded, usually before the game started
	var/list/to_load = list()

	var/my_shark = "broken EXP system that's broken!!!"

	var/backup_sluut = 1 // your mom

	var/debug = TRUE

/datum/controller/subsystem/experience/proc/Initialize(timeofday)
	load_wave(TRUE)
	. = ..()
	shark()
	to_chat(world, span_boldannounce("Loaded [LAZYLEN(all_lvls)] characters worth of experience data! (including yours!)"))
	to_chat(world, span_announce("\t(Beware the [my_shark]!)"))

/datum/controller/subsystem/experience/proc/fire(resumed)
	save_loaded_exp()

/// Does the initial loading of all the EXP datas
/datum/controller/subsystem/experience/proc/load_wave(startup)
	if(startup)
		for(var/ck in GLOB.directory) // ckey2client
			var/client/C = GLOB.directory[ck]
			if(!C)
				continue
			var/datum/preferences/P = C.prefs
			if(!P)
				continue
			
			


/// gets the EXP directory for the character, yeah uhhhh so theres player and character, player holds the various character files, which hold the actual exp data
/datum/controller/subsystem/experience/proc/get_directory(c_key, uid, backup) // yup
	if(!c_key)
		return
	if(!uid)
		return
	if(backup)
		if(backup == TRUE)
			backup = GLOB.round_id
		return "[_XP_ROOT_PATH]/[_XP_BACKUP_PATH]-[GLOB.round_id]/[c_key]/[uid]/"
	return "[_XP_ROOT_PATH]/[_XP_CURRENT_PATH]/[c_key]/[uid]/"

/datum/controller/subsystem/experience/proc/allowed_exps(datum/exp/pat, c_key)
	if(!c_key)
		return FALSE
	if(!ispath(pat, /datum/exp))
		return FALSE
	return TRUE

/datum/controller/subsystem/experience/proc/init_player_xp(datum/preferences/P)
	if(!istype(P))
		P = extract_prefs(P)
	if(!P)
		CRASH("Failed to extract prefs from [P]!!!!!!!!!!!! Error code: HOT-SINGLE-MEGA-FLOUNDER") // yes
		return FALSE
	if(!P.parent)
		return FALSE // disconnected or something, clients be fickle
	var/myckey = P.parent.ckey // get it while its hot!!
	if(!P.prefs_uid) // hasnt been set yet
		give_new_uid(P)
		if(!P.prefs_uid)
			to_chat(P.parent, span_userdanger())
			CRASH("Failed to generate a UID for [P.parent.ckey]!!!!!!!!!!!! Error code: CURVY-JIGGLY-TURBO-EEL")
			return FALSE
	var/myuid = P.prefs_uid
	if(istype(LAZYACCESS(all_lvls, myuid), /datum/exp_holder))
		return TRUE // already there!
	var/datum/exp_holder/my_holder = new /datum/exp_holder(myckey, myuid)
	all_lvls[myuid] = my_holder // virginity will be set, awaiting the first load when we're good and ready
	to_chat(P.parent, span_notice("Loading character data for [P.real_name]..."))
	to_load |= myuid
	catalogue_uid(myckey, myuid)


/// loads a player-level save file and loads in all the characters' datas
/datum/controller/subsystem/experience/proc/load_player_save(datum/preferences/P, force_update)
	if(!critter)
		return
	var/datum/preferences/P = extract_prefs(critter)
	if(!P)
		return
	if(!P.parent)
		return
	if(!P.prefs_uid)
		generate_uid(critter)
		if(!P.prefs_uid)
			to_chat(P.parent, span_userdanger())
			CRASH("Failed to generate a UID for [P.parent.ckey]!!!!!!!!!!!!")
	var/myckey = P.parent.ckey
	var/myuid = P.prefs_uid
	if(LAZYACCESS(all_lvls, myuid) && !force_update)
		return // already there!
	var/ckeydirectory = "data/exp/current/[myckey]/"
	/// should give us a list in this format:
	/// var/list/folders = list("dir_uid1/", "dir_uid2/", ...)
	var/list/folders = flist(ckeydirectory)
	if(!LAZYLEN(folders)) // oh they're a new player? lets make a new folder for them!
		build_new_player_save(P)
		return .(critter) // try again!!!
	for(var/uid in folders) // characters
		var/datum/exp_holder/my_holder = new /datum/exp_holder(P.parent.ckey, uid)
		all_lvls[P.prefs_uid] = my_holder
		/// formt: var/list/idaho = list("exp-<key>.json", "exp-<key>.json", ...)
		var/list/idaho = flist("[ckeydirectory][uid]/")
		if(!LAZYLEN(idaho))
			continue
		for(var/expfile in idaho)
			if(!findtext(expfile, "exp-") || !findtext(expfile, ".json"))
				stack_trace("Invalid EXP file found! [expfile]!!!!!!!!!!")
			if(!my_holder.load_exp_file("[ckeydirectory][uid][expfile]"))
				stack_trace("Failed to load EXP file! [expfile]!!!!!!!!!!")

/// Saves All the EXP datas!
/datum/controller/subsystem/experience/proc/save_loaded_exp()
	for(var/ooid in all_lvls)
		save_exp(ooid, TRUE)

/// Saves a character's EXP data
/datum/controller/subsystem/experience/proc/save_exp(uid, soft = TRUE)
	if(!uid)
		return
	var/datum/exp_holder/my_holder = LAZYACCESS(all_lvls, uid)
	if(!my_holder)
		return
	my_holder.save_to_disk(soft)

/// vital
/datum/controller/subsystem/experience/proc/shark()
	var/list/adjs = GLOB.adjectives.Copy()
	var/firstadj = safepick(adjs) || "buggy"
	adjs -= firstadj
	var/secondadj = safepick(adjs) || "busted"
	adjs.Cut() // be kind, undefined
	var/firstshark = safepick(GLOB.megacarp_first_names) || "terror"
	var/lastshark = safepick(GLOB.megacarp_last_names) || "shark"
	var/my_shark = "[firstadj] [secondadj] [firstshark] [lastshark]"
	return TRUE

/datum/controller/subsystem/experience/proc/adjust_xp(mob/master, key, amount, list/data = list())
	if(!master)
		return
	if(!master.client)
		return
	var/ckey = master.client?.ckey
	var/datum/exp_holder/my_holder = LAZYACCESS(all_lvls, ckey)
	if(!my_holder)
		return
	my_holder.adjust_xp(key, amount, data)


//////////////////////////
/// mob UID management ///

/// The uid associated with the mob, assigned on login / inhabitting of mob
/mob/var/mob_uid = 0
/// theres a prefs uid in the prefs, its used to overwrite whatever the mob_uid is

/datum/controller/subsystem/experience/proc/give_new_uid(datum/preferences/P, force = FALSE)
	if(!P)
		return
	if(P.prefs_uid && !force)
		return FALSE
	var/cool_id = generate_uid()
	if(!cool_id)
		to_chat(P.parent, span_userdanger("something went horribly, horribly wrong! Error code: BIG-ANGRY-TERROR-SHARK"))
		CRASH("Failed to generate a UID for [P.parent.ckey]!!!!!!!!!!!! Error code: BIG-ANGRY-TERROR-SHARK")
	P.prefs_uid = cool_id

/datum/controller/subsystem/experience/proc/generate_uid()
	/// doesnt check if theres a dupe cus the chances of that are astronomically low
	var/randonum = rand(1000000, 9999999)
	var/list/adjs = GLOB.adjectives.Copy()
	var/firstadj = safepick(adjs) || "buggy"
	adjs -= firstadj
	var/secondadj = safepick(adjs) || "busted"
	adjs.Cut() // be kind, undefined
	var/new_id = "" // plus it'd be funny if it happens
	new_id += "[firstadj]-" // curvacious
	new_id += "[secondadj]-" // sultry
	new_id += "[safepick(GLOB.megacarp_first_names)]-" // terror
	new_id += "[safepick(GLOB.megacarp_last_names)]-" // shark
	new_id += "[randonum]" // 1234567
	return new_id

//////////////////////////
/// Holder of EXP data ///
/datum/exp_holder
	/// UID of the player this belongs to
	var/uid
	/// c_key of the player this belongs to
	var/c_key
	/// All the exp datums we have
	var/list/lvls = list()
	/// Whether or not we've received our first load of data
	var/virgin = TRUE

/datum/exp_holder/New(c_key, uid)
	. = ..()
	src.c_key = c_key
	src.uid = uid
	/// initial loading of blank xp data
	for(var/xp in subtypesof(/datum/exp))
		var/datum/exp/my_xp = new xp(c_key, uid)
		lvls[my_xp.kind] = my_xp

/datum/adjust_xp/proc/get_master_file(backup = FALSE)
	var/r00t = SSexperience.get_directory(c_key, uid, backup)
	return "[r00t][_XP_MASTER_FILENAME]" // /data/exp/current/<ckey>/<uid>/master.json

/datum/exp_holder/proc/adjust_xp(key, amount, list/data = list())
	var/datum/exp/my_xp = LAZYACCESS(lvls, key)
	if(!my_xp)
		return
	my_xp.adjust_xp(amount, data)

/datum/exp_holder/proc/load_from_disk(force)
	if(!file(get_master_file())) // nothing to load!
		init_master() // so lets make a new one!
	var/mydirectory = SSexperience.get_directory(c_key, uid, FALSE)
	var/list/xps = flist(mydirectory)
	if(!LAZYLEN(xps)) // by now we should have at least the master file, so, something went wrong
		var/client/C = ckey2client(c_key)
		if(C)
			to_chat(C, span_userdanger("Something went wrong with loading your EXP data! Contact an admin with this error code: LUMPY-SPINY-SEA-URCHIN"))
		CRASH("Failed to load EXP files for [c_key]!!!!!!!!!!!! Error code: LUMPY-SPINY-SEA-URCHIN")
	for(var/xpfile in xps)
		. = load_from_file(xpfile, force)

/datum/exp_holder/proc/load_from_file(xpfile, force)
	var/xppath = XP_CHAR_FILE(c_key, uid, xpfile)
	if(!file(xppath))
		CRASH("Failed to find EXP file! [c_key], [uid], [xppath]!!!!!!!!!! Error code: SUPER-DUPER-SCOOPER-GROUPER")
	if(!findtext(xppath, "exp-") || !findtext(xppath, ".json"))
		CRASH("Invalid EXP file found! [c_key], [uid], [xppath]!!!!!!!!!! Error code: SUPER-DUPER-SCOOPER-GROUPER")
	var/list/xpdata = safe_json_decode(file2text(xppath))
	if(!xpdata)
		CRASH("Failed to read EXP file! [c_key], [uid], [xppath]!!!!!!!!!! Error code: SUPER-DUPER-SCOOPER-GROUPER")
	var/datum/exp/my_xp = LAZYACCESS(lvls, xpdata["kind"])
	if(!my_xp)
		var/datum/exp/pat = text2path(xpdata["type"])
		if(!ispath(pat, /datum/exp))
			CRASH("Invalid EXP file found! [c_key], [uid], [xppath]!!!!!!!!!! Error code: SUPER-DUPER-SCOOPER-GROUPER")
		if(SSexperience.allowed_exps(pat, c_key))
			my_xp = new pat(xpdata["type"], c_key, uid)
			lvls[my_xp.key] = my_xp
		else
			CRASH("Invalid EXP file found! [c_key], [uid], [xppath]!!!!!!!!!! Error code: SUPER-DUPER-SCOOPER-GROUPER")
	return my_xp.load_from_json(xpdata, force)

/datum/exp_holder/proc/save_to_disk(soft)
	var/list/failed = list()
	for(var/xp in lvls)
		if(!xp.save_to_disk(soft))
			failed |= xp
	if(LAZYLEN(failed))
		var/client/C = ckey2client(c_key)
		if(C)
			to_chat(C, span_userdanger("Something went wrong with saving your EXP data! [LAZYLEN(failed)] EXPs failed!!! Contact an admin with this error code: MEGA-MINI-FLAT-FLUKE"))
		CRASH("Failed to save EXP files for [c_key]!!!!!!!!!!!! [LAZYLEN(failed)] EXPs failed!!! Error code: MEGA-MINI-FLAT-FLUKE")
	/// now update the master file
	var/masterpath = get_master_file()
	var/list/currmaster = safe_json_decode(file2text(masterpath))
	if(!currmaster)
		CRASH("Failed to read EXP master file! [c_key], [uid], [masterpath]!!!!!!!!!! Error code: CUTE-SUBBY-SPERM-WHALE")
	var/list/rounds_saved = LAZYACCESS(currmaster, "rounds_saved")
	if(!LAZYLEN(rounds_saved))
		rounds_saved = list()
	rounds_saved |= GLOB.round_id
	currmaster["rounds_saved"] = rounds_saved
	var/jsontext = safe_json_encode(currmaster)
	if(!jsontext)
		CRASH("Failed to encode EXP master file! [c_key], [uid], [masterpath]!!!!!!!!!! Error code: CUTE-DOMMY-SPERM-MOMMY")
	fdel(masterpath)
	WRITE_FILE(masterpath, jsontext)
	var/client/C = ckey2client(c_key)
	if(C)
		to_chat(C, span_good("Character data successfully saved! =3"))

/// Creates a new player save file, mainly to designate that this charaacter is a new player
/datum/exp_holder/proc/init_master()
	var/masterpath = get_master_file()
	if(file(masterpath))
		return TRUE // already there!
	var/list/currmaster = list()
	currmaster["c_key"] = c_key
	currmaster["uid"] = uid
	currmaster["rounds_saved"] = list()
	currmaster["rounds_saved"] |= GLOB.round_id
	currmaster["created_on"] = "[time2text(world.realtime, "DDD MMM DD hh:mm YYYY", "PST")]" // im PST =3
	currmaster["round_created_on"] = GLOB.round_id
	currmaster["cute_shark"] = SSexperience.my_shark // uwu
	var/jsontext = safe_json_encode(currmaster)
	if(!jsontext)
		CRASH("Failed to encode EXP master file! [c_key], [uid], [masterpath]!!!!!!!!!! Error code: CUTE-DOMMY-SPERM-MOMMY")
	fdel(masterpath)
	WRITE_FILE(masterpath, jsontext)
	return TRUE

//////////////////////////
/// Individual XP data ///
/datum/exp
	var/name = "Githubber"
	var/verbing = "Calling 1-800-IMC-ODER"
	var/readme_file = "default_readme.txt"
	var/kind = XP_DEFAULT
	var/lvl = 0
	var/total_xp = 0
	var/current_xp = 0
	var/highest_xp = 0
	var/next_level_xp = 0
	var/this_level_base_xp = 0
	var/max_level = 1000
	var/uid
	var/c_key

	var/currentround = 0
	var/last_updated = 0
	var/last_saved = 0

	var/today_year = 0
	var/today_month = 0
	var/today_day = 0

	var/virginity = TRUE
	var/durty = FALSE
	var/dont_save_me = FALSE // daddy

/datum/exp/New(c_key, uid)
	. = ..()
	if(!c_key)
		return
	if(!uid)
		return
	src.c_key = c_key
	src.uid = uid
	today_year = text2num(time2text(world.timeofday, "YY"))
	today_month = text2num(time2text(world.timeofday, "MM"))
	today_day = text2num(time2text(world.timeofday, "DD"))
	currentround = GLOB.round_id
	// last_updated = round(world.time, 1)
	// last_saved = round(world.time, 1)

/// Gets the file path for the XP data
/datum/exp/proc/get_filepath(backup = FALSE)
	// /data/exp/current/<ckey>/<uid>/
	var/r00t = SSexperience.get_directory(c_key, uid, FALSE)
	var/myfile = XP2FILE(kind)
	return "[r00t][myfile]" // /data/exp/current/<ckey>/<uid>/<char_uid>/exp-<key>.json

/// Saves the XP data to a file
/datum/exp/proc/save_to_disk(only_progress, soft)
	var/filepath = get_filepath(FALSE)
	var/backup_filepath = get_filepath(TRUE)
	if(!should_save(filepath, only_progress, soft))
		return TRUE
	var/list/savedata = list()
	savedata["name"] = name
	savedata["c_key"] = c_key
	savedata["uid"] = uid
	savedata["kind"] = kind
	savedata["type"] = type
	savedata["total_xp"] = total_xp
	savedata["current_xp"] = current_xp
	savedata["highest_xp"] = highest_xp
	savedata["next_level_xp"] = next_level_xp
	savedata["this_level_base_xp"] = this_level_base_xp
	savedata["lvl"] = lvl
	savedata["currentround"] = currentround
	savedata["last_updated"] = last_updated
	savedata["last_saved"] = last_saved
	savedata["today_year"] = today_year
	savedata["today_month"] = today_month
	savedata["today_day"] = today_day
	savedata[_XPVERIFICATION_FGLAND_KEY] = _XPVERIFICATION_FGLAND_VAL
	savedata[_XPVERIFICATION_BGLAND_KEY] = _XPVERIFICATION_BGLAND_VAL
	var/jsontext = safe_json_encode(savedata)
	if(!jsontext)
		var/client/C = ckey2client(c_key)
		if(C)
			to_chat(C, span_userdanger("Something went wrong with saving your EXP data! Contact an admin with this error code: MEGA-MINI-FLAT-FLUKE"))
		CRASH("Failed to encode EXP data! [c_key], [uid], [filepath]!!!!!!!!!! Error code: MEGA-MINI-FLAT-FLUKE")
	fdel(filepath)
	WRITE_FILE(filepath, jsontext)
	last_saved = round(world.time, 1)
	dont_save_me = FALSE // we're good to save again!
	if(saved_successfully(filepath))
		fdel(backup_filepath)
		WRITE_FILE(backup_filepath, jsontext)
		var/client/C = ckey2client(c_key)
		if(C)
			to_chat(C, span_good("Character data successfully saved! =3"))
		return TRUE
	else
		dont_save_me = TRUE // Something went wrong with saving, lets stop saving until its fixed
		var/client/C = ckey2client(c_key)
		if(C)
			to_chat(C, span_userdanger("Something went wrong with saving your EXP data! Contact an admin with this error code: MEGA-MINI-FLAT-FLUKE"))
		CRASH("Failed to save EXP data! [c_key], [uid], [filepath]!!!!!!!!!! Error code: MEGA-MINI-FLAT-FLUKE")

/// Test-reads the XP data from a file and compares it to the current data, which should be the same
/datum/exp/proc/saved_successfully(filepath)
	if(!file(filepath))
		return FALSE
	var/list/savedata = safe_json_decode(file2text(filepath))
	if(!savedata)
		return FALSE
	if(!verify_save(savedata))
		return FALSE
	if(total_xp != LAZYACCESS(xpdata, "total_xp"))
		return FALSE
	return TRUE

/// Checks if we should save the file
/// returns TRUE if we should, FALSE if we shouldn't
/datum/exp/proc/should_save(filepath, only_progress, soft)
	if(!fexists(filepath))
		return TRUE // no file, good to save!
	if(dont_save_me)
		return FALSE // something went wrong with saving, lets stop saving until its fixed
	if(soft && !durty)
		return FALSE // we're not dirty, no need to towel me off, daddy
	return TRUE
	// var/now_thisround = GLOB.round_id
	// var/now_roundtime = round(world.time, 1)
	// var/list/the_save = safe_json_decode(file2text(filepath))
	// var/then_thisround = LAZYACCESS(the_save, "currentround")
	// var/then_roundtime = LAZYACCESS(the_save, "last_updated")
	// if(!then_thisround || !then_roundtime)
	// 	return TRUE // something went wrong with saving, lets save again
	// if(then_thisround > now_thisround)
	// 	return FALSE // We're somehow in a previous round, don't save
	// if(then_roundtime > now_roundtime)
	// 	return FALSE // We're somehow in the past, don't save
	// if(only_progress)
	// 	if(total_xp <= LAZYACCESS(the_save, "total_xp"))
	// 		return FALSE // We haven't gained any XP, don't save

/// Loads the XP data from a file
/datum/exp/proc/load_from_file(xpfile, force)
	var/xppath = XP_CHAR_FILE(c_key, uid, xpfile)
	if(!file(xppath))
		CRASH("Failed to find EXP file! [c_key], [uid], [xppath]!!!!!!!!!! Error code: KOOKIE-RANDOM-SPIDER-FLOUNDER")
	if(!findtext(xppath, "exp-") || !findtext(xppath, ".json"))
		CRASH("Invalid EXP file found! [c_key], [uid], [xppath]!!!!!!!!!! Error code: KOOKIE-RANDOM-SPIDER-FLOUNDER")
	var/list/xpdata = safe_json_decode(file2text(xppath))
	if(!xpdata)
		CRASH("Failed to read EXP file! [c_key], [uid], [xppath]!!!!!!!!!! Error code: KOOKIE-RANDOM-SPIDER-FLOUNDER")
	return load_from_json(xpdata, force)

/// Loads the XP data from a list
/datum/exp/proc/load_from_json(list/xpdata, force)
	if(!virginity && !force)
		return TRUE // already loaded!
	if(!LAZYLEN(xpdata))
		return FALSE // nothing to load!
	if(!verify_save(xpdata))
		CRASH("Empty EXP file found! [type]!!!!!!!!!!")
	if(!read_data(xpdata))
		CRASH("Failed to read EXP file! [type]!!!!!!!!!!")
	post_load(xpdata)
	return TRUE

/// Reads the XP data from a file
/datum/exp/proc/read_data(list/xpdata)
	total_xp = LAZYACCESS(xpdata, "total_xp")
	return TRUE

/// Post load stuff
/datum/exp/proc/post_load(list/xpdata, announce = TRUE)
	check_level(FALSE)
	virginity = FALSE // thanks for that hot load, uwu
	if(announce)
		var/client/C = ckey2client(c_key)
		if(C)
			to_chat(C, span_notice("Sucessfully loaded [name] EXP data! [prob(5) ? "=3" : ""]"))

/// Checks if the contents of the save file are valid
/// okay it just checks if the first and last entries are valid
/// returns nothing if it's valid, returns a backup save file if it's not
/datum/exp/proc/verify_save(list/savedata)
	if(!LAZYLEN(savedata))
		return FALSE // nothing to load!
	var/list/verification_can = LAZYACCESS(savedata, _XPVERIFICATION_FGLAND_KEY)
	var/list/verification_juice = LAZYACCESS(savedata, _XPVERIFICATION_BGLAND_KEY)
	if(!LAZYACCESS(verification_can, _XPVERIFICATION_FGLAND_VAL) || !LAZYACCESS(verification_juice, _XPVERIFICATION_BGLAND_VAL))
		message_admins(span_userdanger(("WEEEOOOWEEEOO THE [c_key]'s [type] FILE IS CORRUPTED! IT BAD AND YOU NEED TO FIX IT OR GET DAN TO DO IT!!!!! Feel free to tell this player their hard earned videogame numbers are GONE FOREVER!!!!")))
		var/client/C = ckey2client(c_key)
		if(C)
			to_chat(C, span_userdanger("Your [name] EXP data is corrupted! Contact an admin! This set of XP will not change until it's fixed!"))
		dont_save_me = TRUE // Something went wrong with saving, lets stop saving until its fixed
		return FALSE
	return TRUE

/// Takes the total XP we had saved, and figures out what level we are
/// Also sets the current XP to the amount we have left over
/// Assumes a base level of 0
/// Used only for loading from prefs
/datum/exp/proc/check_level(loud = TRUE)
	for(var/i in 0 to max_level)
		var/needed_xp = xp2lvl(i)
		if(needed_xp < total_xp)
			continue
		var/new_lvl = i - 1
		current_xp = total_xp - xp2lvl(new_lvl)
		next_level_xp = xp2lvl(lvl + 1)
		this_level_base_xp = needed_xp
		var/num_levels = new_lvl - lvl
		lvl = new_lvl
		if(num_levels > 0)
			on_lvl_up(new_lvl, num_levels, loud)
			alert_lvl_change(new_lvl, num_levels, loud)
		else if(num_levels < 0)
			on_lvl_down(new_lvl, num_levels, loud)
			alert_lvl_change(new_lvl, num_levels, loud)
		return

/// Override with your own xp -> level code
/// takes in a level, returns the minimum amount of xp needed to be that level
/datum/exp/proc/xp2lvl(lvl)
	lvl = clamp(lvl, 0, max_level)
	var/out = lvl * lvl * 100
	return out

/// functional things for levelling up
/datum/exp/proc/on_lvl_up(new_lvl, num_levels, loud = TRUE)
	// override me!

/// functional things for levelling down
/datum/exp/proc/on_lvl_down(new_lvl, num_levels, loud = TRUE)
	// override me!

/// Alerts the player that they have levelled up or down
/datum/exp/proc/alert_lvl_change(new_lvl, num_levels, loud = TRUE)
	if(!loud)
		return
	if(num_levels == 0)
		return
	if(!c_key)
		return
	var/mob/M = ckey2mob(c_key)
	if(!M)
		return
	if(!M.client)
		return
	if(num_levels > 0)
		if(num_levels == 1)
			to_chat(M, span_greentext("You have gained a level in [span_love(name)]! You are now a level [new_lvl]!"))
		else
			to_chat(M, span_greentext("You have gained [num_levels] levels in [span_love(name)]! You are now a level [new_lvl]!"))
	else if(num_levels < 0)
		if(num_levels == -1)
			to_chat(M, span_userdanger("You have lost a level in [span_love(name)]! You are now level [new_lvl]!"))
		else
			to_chat(M, span_userdanger("You have lost [num_levels] levels in [span_love(name)]! You are now level [new_lvl]!"))

/// Adjusts the current XP by the amount given
/// can make it negative to remove XP
/datum/exp/proc/adjust_xp(amount, list/data = list())
	if(amount == 0)
		return
	total_xp += amount
	current_xp = total_xp - this_level_base_xp
	if(amount > 0)
		on_gain_xp(amount, data)
	else
		on_lose_xp(amount, data)
	check_level()

/// Override with your own code to do something when you gain XP
/// amount is the amount of XP gained
/datum/exp/proc/on_gain_xp(amount, list/data = list())
	// override me!

/// Override with your own code to do something when you lose XP
/datum/exp/proc/on_lose_xp(amount, list/data = list())
	// override me!




