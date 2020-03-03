/*************************************************************************
 * NoMercy.mod by Noname
 * This code loads "No Mercy" mode in battles if the option is enabled.
 * No mercy is a gamemode I created with the following rules:
 * 
 * If balloon battle: You will "die" (lose a point then need to respawn back) 
 * each time you are hit (exluding mushrooms and stars?) as if you always have
 * 1 balloon.
 *
 * In Coin Runners: You will lose ALL of your coins when you are hit! Does not matter
 * How many coins you have. This applies for all items, and all obstacles. If someone 
 * stars or shrooms you? They have all of your coins now!
 *****************************************************************************/
 
 /* For balloon battle */
 MOD_REL(
	mod_loadnomercyBB,
	NoMercyBalloonAddr,
	
	bl		noMercyBalloon;
 
 )
 
 /* For coin runners */
  MOD_REL(
	mod_loadnomercyCR,
	NoMercyCoinAddr,
	
	bl		noMercyCoin;
 
 )
 
 
 MOD_DOL(
	mod_nomercy,
	0x80002550,
	
	
	.globl	noMercyBalloon;
	noMercyBalloon:
	lis 	r12, GametypeAddr@ha;
	lwz 	r11, GametypeAddr@l(r12);
	cmpwi 	r11, 0x58;
	bne 	skip; /*If No Mercy has not been activated, do nothing.*/
	li	r0, 0; /*If No Mercy is active, simulate players having just 1 balloon at all times.*/

	skip:
	stb     r0,964(r29); /*Original instruction. Store player's "balloon amount" */
	blr;
	
	
	/* Coin-version of nomercy: Lose ALL of your coins when hit.
	* Address: 8086e920: standard % coins lost
	* Address: 8086e92c: Minimum coins lost when falling out of bounds
	* Address: 8086e938: Minimum coins lost when hit by a player. [For bananas & fibs]
	* Addresses: 0x8086e940 & 8086e950: Min Coins lost when hit by player [stars, shrooms] */
	
	.globl noMercyCoin;
	noMercyCoin:
	
	lis 	r12, 0x8000;
	lwz 	r11, 0x22F8(r12);
	cmpwi 	r11, 0x58;
	bne 	storeoriginalcoin; /*If No Mercy is not active, do nothing */


	li	r0, 0x64 ;/* 0x64 = 100. 100% coin loss. */
	stb	r0, 0x000A(r29); /* Store coin % lost when hit */
	lwz	r3, 0x0004(r30); 
	stb	r0, 0x0006(r29); /* Store min. coins lost when falling out of bounds */
	lwz	r3, 0x0004(r30);
	stb	r0, 0x0007(r29) ;/* Store min.coins lost when hit by player [ground items e.g. nanas] */
	lwz	r3, 0x0004 (r30);
	stb	r0, 0x0009 (r29); /* Store min.coins lost when hit by [shroom/star?] */
	lwz	r3, 0x0004 (r30);
	stb	r0, 0x0008 (r29); /* Store min.coins lost when hit by [shroom/star?] */
	b	endcoinmercy;

	storeoriginalcoin:
	stb	r0, 0x0008(r29); /* Original instruction, store coin loss modifiers. */

	endcoinmercy:
	blr;
 
 )