/******************************************
 * Omitted.mod 
 * Collection of mods that were taken out of the code for this project.
 * The main reason is because these are done through file edits, without 
 * a need to change the values (yet, perhaps.) after the files are edited.
 * Most of these are minigame.kmg-related.
 *
 * None of these codes themselves take effect in the project, but the effects are still in
 * the game.
 ******************************************/


/****** Taken from General.mod ******/

/* Changes amount of points earned after popping someone's last balloon.*/
MOD_REL(
	mod_earnedBalloonPts,
	BalloonPtsGainOnlineAddr,
	
	li		r3, 1;  /* 1 Extra point for popping someone's balloon. */
)

/* Changes amount of points lost when losing all of your balloons. */
/* Note: 0x80534170 [ntsc-u] might control points when falling off? [offline] */
MOD_REL (
	mod_lostBalloonPts,
	BalloonPtsLossOnlineAddr,
	
	bl		setPtLoss;
)



/******Taken from FFA_Mirror.mod ******/

/* Although you can hit your teammates, you don't get a point for that in balloon battle.
  * Minigame.kmg seems to have a two bytes reserved for how many points a player gains when hitting
  * A teammate. So this mod fixes the issue by always giving +1 at the memory address that reads from
  * that minigame.kmg byte. 805381c8 online*/  
 MOD_REL(
	mod_TeammatePtFix,
	TeammatePointEarnedAddr,
	
	li r3, 1; /* +1 pt */
 
 )
 
 /* And of course, if you get +1 pt for hitting a teammate, you also get +1 for hitting yourself. This can
  * Can cause an unfair manuever where a player can hit themselves over and over again to farm points. To prevent this,
  * The mod below gives you -1 for hitting yourself (So +0 overall.) Like the previous mod above, this is done through an
  * address that reads from Minigame.kmg. There are two bytes reserved for the amount of points gained/lost for being hit by a teammate.
  * But as a side effect, you also get -1 for being hit by a teammate... So I'll look into fixing that as well uafnwigiueg 
  * 805381ec online*/
 MOD_REL(
	mod_hitYourselfFix,
	TeammatePointLossAddr,
	
	lis 	r3, 0xFFFF;
	ori		r3, r3,0xFFFF; /* -1 pt */
 
 )
 