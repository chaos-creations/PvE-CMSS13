/datum/ongoing_action/item_pickup
	name = "Item Pickup"
	var/obj/item/to_pickup

/datum/ongoing_action/item_pickup/New(datum/human_ai_brain/brain, list/arguments)
	. = ..()
	to_pickup = arguments[2]

/datum/ongoing_action/item_pickup/Destroy(force, ...)
	to_pickup = null
	return ..()

/datum/ongoing_action/item_pickup/trigger_action()
	if(QDELETED(to_pickup) || !isturf(to_pickup.loc))
		return ONGOING_ACTION_COMPLETED

	if(get_dist(to_pickup, brain.tied_human) > 1)
		if(!brain.move_to_next_turf(get_turf(to_pickup)))
			return ONGOING_ACTION_COMPLETED

		if(get_dist(to_pickup, brain.tied_human) > 1)
			return ONGOING_ACTION_UNFINISHED

	if(!brain.primary_weapon && isgun(to_pickup))
		brain.tied_human.put_in_hands(to_pickup, TRUE)
		var/obj/item/weapon/gun/primary = to_pickup
		// We do the three below lines to make it so that the AI can immediately pick up a gun and open fire. This ensures that we don't need to account for this possibility when firing.
		primary.wield_time = world.time
		primary.pull_time = world.time
		primary.guaranteed_delay_time = world.time
		return ONGOING_ACTION_COMPLETED

	if(istype(to_pickup, /obj/item/storage/belt) && !brain.container_refs["belt"])
		brain.tied_human.put_in_hands(to_pickup, TRUE)
		brain.tied_human.equip_to_slot(to_pickup, WEAR_WAIST)
		return ONGOING_ACTION_COMPLETED

	if(istype(to_pickup, /obj/item/storage/backpack) && !brain.container_refs["backpack"])
		brain.tied_human.put_in_hands(to_pickup, TRUE)
		brain.tied_human.equip_to_slot(to_pickup, WEAR_BACK)
		return ONGOING_ACTION_COMPLETED

	if(istype(to_pickup, /obj/item/storage/pouch) && !brain.container_refs["left_pocket"])
		brain.tied_human.put_in_hands(to_pickup, TRUE)
		brain.tied_human.equip_to_slot(to_pickup, WEAR_L_STORE)
		return ONGOING_ACTION_COMPLETED

	if(istype(to_pickup, /obj/item/storage/pouch) && !brain.container_refs["right_pocket"])
		brain.tied_human.put_in_hands(to_pickup, TRUE)
		brain.tied_human.equip_to_slot(to_pickup, WEAR_R_STORE)
		return ONGOING_ACTION_COMPLETED

	var/storage_spot = brain.storage_has_room(to_pickup)
	if(!storage_spot || !to_pickup.ai_can_use(brain.tied_human))
		return ONGOING_ACTION_COMPLETED

	if(is_type_in_list(to_pickup, brain.all_medical_items))
		brain.store_item(to_pickup, storage_spot)
		return ONGOING_ACTION_COMPLETED

	if(brain.primary_weapon && istype(to_pickup, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/mag = to_pickup
		if(istype(brain.primary_weapon, mag.gun_type))
			brain.store_item(to_pickup, storage_spot)
		return ONGOING_ACTION_COMPLETED
