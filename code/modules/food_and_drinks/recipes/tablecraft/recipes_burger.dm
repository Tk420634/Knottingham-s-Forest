// see code/module/crafting/table.dm
// Visual Reference: Food Old World under crafting

////////////////////////////////////////////////STANDARD BURGS////////////////////////////////////////////////

/datum/crafting_recipe/food/burger
	name = "Burger"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)

	result = /obj/item/reagent_containers/food/snacks/burger/plain
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/baconburger
	name = "Bacon Burger"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/meat/bacon = 3,
			/obj/item/reagent_containers/food/snacks/cheesewedge = 1,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)

	result = /obj/item/reagent_containers/food/snacks/burger/baconburger
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/bigbiteburger
	name = "Big bite burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 3,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 2,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/bigbite
	subcategory = CAT_MISCFOOD


/datum/crafting_recipe/food/cheeseburger
	name = "Cheese Burger"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
			/obj/item/reagent_containers/food/snacks/cheesewedge = 1,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/cheese
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/ribburger
	name = "McRib"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/bbqribs = 1,     //The sauce is already included in the ribs
			/obj/item/reagent_containers/food/snacks/onion_slice = 1, //feel free to remove if too burdensome.
			/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/rib
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/mcguffin
	name = "McGuffin"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/friedegg = 1,
			/obj/item/reagent_containers/food/snacks/meat/bacon = 2,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/mcguffin
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/tofuburger
	name = "Tofu burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tofu = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/tofu
	subcategory = CAT_MISCFOOD

///////////////EXOTIC//////////////////

/datum/crafting_recipe/food/fishburger
	name = "Fish burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fishmeat/carp = 1,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/fish
	subcategory = CAT_MISCFOOD


/datum/crafting_recipe/food/superbiteburger
	name = "Super bite burger"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 5,
		/datum/reagent/consumable/blackpepper = 5,
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 5,
		/obj/item/reagent_containers/food/snacks/grown/tomato = 4,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 3,
		/obj/item/reagent_containers/food/snacks/boiledegg = 1,
		/obj/item/reagent_containers/food/snacks/meat/bacon = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1

	)
	result = /obj/item/reagent_containers/food/snacks/burger/superbite
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/corgiburger
	name = "Corgi burger"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/meat/slab/corgi = 1,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)

	result = /obj/item/reagent_containers/food/snacks/burger/corgi
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/humanburger
	name = "Human burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/bun = 1,
		/obj/item/reagent_containers/food/snacks/meat/steak/plain/human = 1
	)
	parts = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain/human = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/human
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/appendixburger
	name = "Appendix burger"
	reqs = list(
		/obj/item/organ/appendix = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/appendix
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/brainburger
	name = "Brain burger"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/brain
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/bearger
	name = "Bearger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/bear = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/bearger
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/chickenburger
	name = "Chicken Sandwich"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/meat/steak/chicken = 1,
			/datum/reagent/consumable/mayonnaise = 5,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/chicken
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/crabburger
	name = "Crab Burger"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/meat/crab = 2,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/crab
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/fivealarmburger
	name = "Five alarm burger"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/grown/ghost_chili = 2,
			/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/fivealarm
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/slimeburger
	name = "Jelly burger"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/jelly/slime
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/jellyburger
	name = "Jelly burger"
	reqs = list(
			/datum/reagent/consumable/cherryjelly = 5,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/jelly/cherry
	subcategory = CAT_MISCFOOD

////////////COLORED BURGERS//////////////

/datum/crafting_recipe/food/redburger
	name = "Red burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
		/obj/item/toy/crayon/red = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/red
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/orangeburger
	name = "Orange burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
		/obj/item/toy/crayon/orange = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/orange
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/yellowburger
	name = "Yellow burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
		/obj/item/toy/crayon/yellow = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/yellow
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/greenburger
	name = "Green burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
		/obj/item/toy/crayon/green = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/green
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/blueburger
	name = "Blue burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
		/obj/item/toy/crayon/blue = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/blue
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/purpleburger
	name = "Purple burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
		/obj/item/toy/crayon/purple = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/purple
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/blackburger
	name = "Black burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
		/obj/item/toy/crayon/black = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/black
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/whiteburger
	name = "White burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 1,
		/obj/item/toy/crayon/white = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/white
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/sloppyjoe
	name = "sloppyjoe"
	reqs = list(
			/datum/reagent/consumable/bbqsauce = 5,
			/obj/item/reagent_containers/food/snacks/bun = 1,
			/obj/item/reagent_containers/food/snacks/meat/cutlet = 2,
			/obj/item/reagent_containers/food/snacks/grown/onion = 1

	)
	result = /obj/item/reagent_containers/food/snacks/burger/sloppy
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/phillycheesesteak
	name = "philly cheesesteak"
	reqs = list(
			/obj/item/reagent_containers/food/snacks/bun = 1,
			/obj/item/reagent_containers/food/snacks/meat/cutlet = 2,
			/obj/item/reagent_containers/food/snacks/grown/onion = 1

	)
	result = /obj/item/reagent_containers/food/snacks/burger/philly_cheesesteak
	subcategory = CAT_MISCFOOD

/// Legacy Content

/*
/datum/crafting_recipe/food/empoweredburger
	name = "Empowered Burger"
	reqs = list(
			/obj/item/stack/sheet/mineral/plasma = 2,
			/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/empoweredburger
	subcategory = CAT_BURGER

/datum/crafting_recipe/food/xenoburger
	name = "Xeno burger"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/steak/xeno = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/xeno
	subcategory = CAT_BURGER

////////////MYSTICAL////////////////

/datum/crafting_recipe/food/ghostburger
	name = "Ghost burger"
	reqs = list(
		/obj/item/ectoplasm = 1,
		/datum/reagent/consumable/sodiumchloride = 2,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/ghost
	subcategory = CAT_BURGER

/datum/crafting_recipe/food/spellburger
	name = "Spell burger"
	reqs = list(
		/obj/item/clothing/head/wizard/fake = 1,
	)
	result = /obj/item/reagent_containers/food/snacks/burger/spell
	subcategory = CAT_BURGER

/datum/crafting_recipe/food/spellburger2
	name = "Spell burger"
	reqs = list(
		/obj/item/clothing/head/wizard = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/burger/spell
	subcategory = CAT_BURGER
*/
