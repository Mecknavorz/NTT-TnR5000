 // On Mod Load:
#define init
	global.lastlvl = 1;
	global.newLevel = instance_exists(GenCont);
	/// Define Sprites : sprite_add("path/to/sprite/starting/from/mod/location.png", frames, x-offset, y-offset) \\\
	// A-Skin:
	global.spr_idle[0] = sprite_add("gunMutantIdle.png",	4, 12, 12);
	global.spr_walk[0] = sprite_add("gunMutantWalk.png",	6, 12, 12);
	global.spr_hurt[0] = sprite_add("gunMutantHurt.png",	3, 12, 12);
	global.spr_dead[0] = sprite_add("gunMutantDead.png",	6, 12, 12);
	global.spr_sit1[0] = sprite_add("gunMutantWalk.png",	3, 12, 12);
	global.spr_sit2[0] = sprite_add("gunMutantIdle.png",	1, 12, 12);
	global.spr_walkagain = sprite_add("gunMutantWalk.png",	6, 12, 12);

	
	 // Character Selection / Loading Screen:
	global.spr_slct = sprite_add("gunCharSelect.png",	1,				0,  0);
	global.spr_port = sprite_add("gunBigPortrait.png",	race_skins(),	40, 243);
	global.spr_icon = sprite_add("gunMapIcon.png",		race_skins(),	10, 10);

	 // Ultras:
	global.spr_ultport[1] = sprite_add("gunUltraA.png", 1, 12, 16);
	global.spr_ultport[2] = sprite_add("gunUltraB.png", 1, 12, 16);
	global.spr_ulticon[1] = sprite_add("ultraHUDIconA.png", 1, 8, 9);
	global.spr_ulticon[2] = sprite_add("ultraHUDIconB.png", 1, 8, 9);


	var _race = [];
	for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
	while(true){
		/// Character Selection Sound:
		for(var i = 0; i < maxp; i++){
			var r = player_get_race(i);
			if(_race[i] != r && r = "T&R STORM"){
				sound_play(sndMutant8Slct); // Select Sound
			}
			_race[i] = r;
		}
		/// Call level_start At The Start Of Every Level:
		if(instance_exists(GenCont)) global.newLevel = 1;
		else if(global.newLevel){
			global.newLevel = 0;
			level_start();
		}
		wait 1;
	}
	if(fork()){
        var gce = false;
        while 1{
            if instance_exists(GenCont) || instance_exists(menubutton){
                gce = true;
            }else{
                if (gce){
                    with(instances_matching(Player,"race",mod_current)){
                        activecheck = 1;
						maxhealth = 8;
						healthcheck = my_health; //for checking changes in health
						ammoRaw = 0; //for checking changes in ammo
						ammoOld = 0; //previously recorded ammo raw
						tillNext = 8;
						clipmax = 32; //max size of our active ability
						clip = 0; //keep track of how much ammmo is loaded into our active
						nextReload = current_time; //for helping delay reloading
						onCooldown = 0; //helps time reloading
						amount = 2; //default # of bullets per shot
						buttStr = 1.5; //how much does throne butt multiply amount by
						specdmg = .75; //base damage of our special
						bullettype = Bullet1;
                    }
                }
                gce = false;
            }
            wait 0;
        }
        exit;
    }

 // On Run Start:
#define game_start
	sound_play(sndMutant8Cnfm); // Play Confirm Sound
	
#define level_start
//ultra b code + throne butt;
//if GameCont.level > global.lastlvl{
if(ultra_get(mod_current,2)) with(instances_matching(Player, "race", mod_current)) { //if we have ultra add damage for weapon mutations and scaling with level
	//scales w/lvl at .25 per level, so 10 lvls is +4 damage
	specdmg = specdmg + (GameCont.wepmuts * .25) + 4;
	if(skill_get(5)){
		clipmax = 96; //increase our clip size
	}else{
		clipmax = 64;
	}
	bullettype = HeavyBullet;
}else if (skill_get(5)) with(instances_matching(Player, "race", mod_current)) { //if we have throne butt, add minor damage scaling with level
	specdmg = specdmg + (GameCont.level * .1);
	clipmax = 48; //minor boost to clip size
}
//}
//update our level counter
global.lastlvl = GameCont.level;

 // On Character's Creation (Starting a run, getting revived in co-op, etc.):
#define create
	activecheck = 1;
	maxhealth = 8;
	healthcheck = my_health; //for checking changes in health
	ammoRaw = 0; //for checking changes in ammo
	ammoOld = 0; //previously recorded ammo raw
	tillNext = 8;
	clipmax = 32; //max size of our active ability
	clip = 0; //keep track of how much ammmo is loaded into our active
	nextReload = current_time; //for helping delay reloading
	onCooldown = 0; //helps time reloading
	amount = 2; //default # of bullets per shot
	buttStr = 2; //how much does throne butt multiply amount by
	specdmg = .75; //base damage of our special
	bullettype = Bullet1; //type of bullet

	 // Set Sprites:
	spr_idle = global.spr_idle[bskin];
	spr_walk = global.spr_walk[bskin];
	spr_hurt = global.spr_hurt[bskin];
	spr_dead = global.spr_dead[bskin];
	spr_sit1 = global.spr_sit1[bskin];
	spr_sit2 = global.spr_sit2[bskin];

	 // Set Sounds:
	snd_wrld = sndMutant8Wrld;	// FLÄSHYN
	snd_hurt = sndMimicHurt;	// THE WIND HURTS
	snd_dead = sndMutant8Dead;	// THE STRUGGLE CONTINUES
	snd_lowa = sndMutant8LowA;	// ALWAYS KEEP ONE EYE ON YOUR AMMO
	snd_lowh = sndMutant8LowH;	// THIS ISN'T GOING TO END WELL
	snd_chst = sndMutant8Chst;	// TRY NOT OPENING WEAPON CHESTS
	snd_valt = sndMutant8Valt;	// AWWW YES
	snd_crwn = sndMutant8Crwn;	// CROWNS ARE LOYAL
	snd_spch = sndMutant8Spch;	// YOU REACHED THE NUCLEAR THRONE
	snd_idpd = sndMutant1IDPD;	// BEYOND THE PORTAL
	snd_cptn = sndMutant8Cptn;	// THE STRUGGLE IS OVER



 // Every Frame While Character Exists:
#define step
//pur active ability code
if (clip>0 && button_check(index, "spec")) {
	//subtract ammo from our clip
	clip -= 2;
	
	//if we have thronebutt
	if skill_get(5) {
		//fire 8 bullets
		repeat(amount * buttStr){
			if instance_exists(self) {
				weapon_post(4,-4,12); //do screenshape etc
				sound_play(sndSmartgun);//make out gun sound
				//fire one bullet
				with instance_create(x,y,other.bullettype) {
					direction = other.gunangle + (random_range(-8,8) * other.accuracy); //get the direction
					image_angle = direction; //apply the angle
					speed = 20; //how fast it goes
					damage = other.specdmg; //how much damage, probably best below 1
					force = 100; //how hard the bullet hits
					team = other.team;
					creator = other;
				}
			}
		}
	}
	else{ //if we don't have throne butt
		//fire bullets
		repeat(amount){
			if instance_exists(self) {
				weapon_post(4,-4,6); //do screenshape etc
				sound_play(sndSmartgun);//make out gun sound
				//fire one bullet
				with instance_create(x,y,other.bullettype) {
					direction = other.gunangle + (random_range(-10,10) * other.accuracy); //get the direction
					image_angle = direction; //apply the angle
					speed = 20; //how fast it goes
					damage = other.specdmg; //how much damage, probably best below 1
					force = 100; //how hard the bullet hits
					team = other.team;
					creator = other;
				}
			}
		}
	}
} else { //code for reloading our active ability
	if (button_released(index, "spec") && (current_time + 750 > nextReload) && (clip < clipmax-2)){
		onCooldown = 1;
		if (onCooldown > 0) {
			nextReload = current_time + 750;
		}
		sound_play(sndMimicSlurp);
    }
	if (!button_check(index,"spec") && current_time >= nextReload) {
		onCooldown = 0;
		if (clip <= clipmax-2 && ammo[1]>1) {
			//take bullets and put them into our body yum
			//subtract bullets
			ammo[1] -= 2;
			//into the clip (2 heads per bullet)
			clip += 2;
			//make a sound;
			sound_play(sndEmpty);
			//eject a shell (since the metal storm platform doesn't use bullet casings, we must remove the bullets from their cases and discard them)
			with instance_create(x,y,Shell) {
				motion_add(random_range(-20,0), random_range(2,4));
			}
			//so we don't spam, only show a message every 8 loaded
			if(clip % 8 == 0){
				// inform the player:
				with (instance_create(x, y, PopupText)) {
					sound_play(sndEmpty);
					mytext = string_insert(string(other.clip), "@y clip", 3);
					target = other.index;
				}
			}
		}
	}
}
//passive code
//when we gain health we regain a little ammo in the clip
if (my_health > healthcheck){
	dmgTaken = healthcheck - my_health;
	//get the amount healted
	var diff = 4*(my_health - healthcheck);
	//add it to the clip
	clip += diff;
	// inform the player:
	with (instance_create(x, y, PopupText)) {
		sound_play(sndEmpty);
		mytext = string_insert(string(diff), "@y+  clip", 4);
		target = other.index;
	}
}
///ultra a code
//when we pic up ammo we heal;
if (ultra_get(mod_current,1) && (my_health < maxhealth)){
	//reset our ammo raw
	ammoRaw = 0;
	//update our total ammo value
	for(i=1; i<5; i++){
		ammoRaw += ammo[i];
	}
	//figure out how much ammo we've gained
	var ammodiff = ammoRaw - ammoOld;
	//as long as we're over the amount of amo we want to convernt to two health
	while (ammodiff >= tillNext){
		var phealth = my_health + 2; //to test if we're over limit
		if(phealth > maxhealth){ //if we are, just set us to max
			my_health = maxhealth;
			break; //not sure if this is actually needed
		} else{
			my_health += 2; //heal 2;
			ammodiff -= tillNext; //take away how much we need to heal by our bullet to heal value 
		}
	}
}
//update our check
healthcheck = my_health;
//update ammo check
ammocheck = ammo;
ammoOld = ammoRaw;
//now make us explode if we die
if(my_health == 0){
	with (instance_create(x, y, GreenExplosion)) {
		sound_play(sndBloodCannon);
		ang = 69; //nice
		team = 2;
		damage = 8;
		force = 300;
		target = other.index;
	}
}

 // Name:
#define race_name
	return "T&R STORM";


 // Description:
#define race_text
	return "LIKES @yAMMO @wAND @rGUNS#@wLIVING @rGUN";


 // Starting Weapon:
#define race_swep
	return 1; // Revolver


 // Throne Butt Description:
#define race_tb_text
	return "@sUSE @sMORE @yGUN";


 // On Taking Throne Butt:
#define race_tb_take

 // Character Selection Icon:
#define race_menu_button
	sprite_index = global.spr_slct;


 // Portrait:
#define race_portrait
	return global.spr_port;


 // Loading Screen Map Icon:
#define race_mapicon
	return global.spr_icon;


 // Skin Count:
#define race_skins
	return 1; // 2 Skins, A + B


 // Skin Icons:
#define race_skin_button
	sprite_index = global.spr_skin;
	image_index = argument0;


 // Ultra Names:
#define race_ultra_name
	switch(argument0){
		case 1: return "@rBLOOD";
		case 2: return "@yBULLETS";
		/// Add more cases if you have more ultras!
	}


 // Ultra Descriptions:
#define race_ultra_text
	switch(argument0){
		case 1: return "@yAMO @rHEALS";
		case 2: return "@sSTRONGER @rGUN @sFROM @wWEAPON @gMUTATIONS";
		/// Add more cases if you have more ultras!
	}


 // On Taking An Ultra:
#define race_ultra_take
	if(instance_exists(mutbutton)) switch(argument0){
		 // Play Ultra Sounds:
		case 1:	sound_play(sndRobotUltraA); break;
		case 2: sound_play(sndRobotUltraB); break;
		/// Add more cases if you have more ultras!
	}


 // Ultra Button Portraits:
#define race_ultra_button
sprite_index = global.spr_ultport[argument0];

 // Ultra HUD Icons:
#define race_ultra_icon
return global.spr_ulticon[argument0];


 // Loading Screen Tips:
#define race_ttip
return choose("BULLET BEAST", "MECHANICAL MONSTER", "GREAT AND TERRIBLE GUNS", "THOUGHTS OF VIOLENCE", "GUN SAFTEY RULE:#HAVE FUN :] :]", "GUN SAFTEY RULE:#STAY POINTED IN A SAFE DIRECTION", "GUN SAFTEY RULE:#ALWAYS ACT AS IF LOADED", "GUN SAFTEY RULE:#KEEP YOUR TIGGERS UNOBSTRUCTED", "GUN SAFTEY RULE:#UNLOAD AFTER MURDER");