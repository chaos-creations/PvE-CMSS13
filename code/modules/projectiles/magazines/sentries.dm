// STANDARD Sentry
/obj/item/ammo_magazine/sentry
	name = "M30 ammo drum (10x28mm Caseless)"
	desc = "An ammo drum of 500 10x28mm caseless rounds for the UA 571-C Sentry Gun. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "ua571c"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = "10x28mm"
	max_rounds = 500
	default_ammo = /datum/ammo/bullet/rifle/heavy
	gun_type = null

/obj/item/ammo_magazine/sentry/dropped
	max_rounds = 100
	max_inherent_rounds = 500

/obj/item/ammo_magazine/sentry/premade
	max_rounds = 99999
	current_rounds = 99999

/obj/item/ammo_magazine/sentry/upp
	name = "AK-500 ammo drum (10x31mm Caseless)"
	desc = "An ammo drum of 10x31mm caseless rounds for the UPPA 32-H sentry. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "sentry"
	caliber = "10x31mm"
	max_rounds = 350
	default_ammo = /datum/ammo/bullet/rifle/heavy/upp

/obj/item/ammo_magazine/sentry/shotgun
	name = "12g buckshot drum"
	desc = "An ammo drum of 50 12g buckshot drums for the UA 12-G Shotgun Sentry. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	caliber = "12g"
	max_rounds = 50
	default_ammo = /datum/ammo/bullet/shotgun/buckshot

// FLAMER Sentry
/obj/item/ammo_magazine/sentry_flamer
	name = "sentry incinerator tank"
	desc = "A fuel tank of usually Ultra Thick Napthal Fuel, a sticky combustible liquid chemical, used in the UA 42-F."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "ua571c"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS
	caliber = "Napalm B"
	max_rounds = 100
	default_ammo = /datum/ammo/flamethrower/sentry_flamer
	gun_type = null

/obj/item/ammo_magazine/sentry_flamer/glob
	name = "plasma sentry incinerator tank"
	desc = "A fuel tank of compressed Ultra Thick Napthal Fuel, used in the UA 60-FP."
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/glob

/obj/item/ammo_magazine/sentry_flamer/mini
	name = "mini sentry incinerator tank"
	desc = "A fuel tank of Ultra Thick Napthal Fuel, used in the UA 45-FM."
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/mini
