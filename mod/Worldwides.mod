/***************************************************
* Worldwide.mod by Noname
* This section contains codes and things that relate
* to WWs in this project.
****************************************************/


/* The mods below make the lower limit of BR to 7000 in the project's wws. It is possible to
 * go below 7k (E.g. New license = 5000BR.) but after your next match, you are brought back to 7k.
 */
MOD_REL(
	mod_BRlimit1,
	BrLimit1Addr,
	
	cmpwi r0,7000;
)

MOD_REL(
	mod_BRlimit2,
	BrLimit2Addr,
	
	li r0,7000;
)

MOD_REL(
	mod_BRlimit3,
	BrLimit3Addr,
	
	cmplwi r0,7000;
)

MOD_REL(
	mod_BRlimit4,
	BrLimit4Addr,
	
	li r0,7000;
)

MOD_REL(
	mod_BRlimit5,
	BrLimit5Addr,
	
	cmpwi r0,7000;
)

MOD_REL(
	mod_BRlimit6,
	BrLimit6Addr,
	
	li r0,7000;
)

/* Counts the amount of players in a ww room. If even amount of players, then do team battles.
 * If odd, do FFA battles to avoid uneven teams. */
MOD_REL(
	mod_wwffa,
	PlayerCountAddr,
	
	b	ffaIfOdd;
)


/* Subtle change to the BR system: The amount of points you earn in a battle
 * Are also your bonus BR points. So if you're supposed to win +2 BR and you scored 5 points
 * that battle, you will get +7BR. */
 MOD_REL(
 	mod_pointAdd,
	BrLimit1Addr - 0x04,
	
	b		BonusBR;
) 


MOD_REL(
	mod_wws,
	0x800027a0,
	
	.globl ffaIfOdd;
	ffaIfOdd:
	
	/* Determine if player is in WW. We only want this to apply for WWs. */
	lis		r12, CurrentOnlineStatusAddr@ha;
	lwz		r0, CurrentOnlineStatusAddr@l(r12);
	lis		r3, 0x805f;
	ori		r3, r3, 0xd238; /* Load from WwScreenMemoryAddr */
	cmpw	r0, r3;
	bne		storePlayerCount;
	cmpwi	r27, 1; /*Avoid FFA "All karts" feature when searching for players. */
	beq		loadwwteams;
	
	/* Determine if player count in room is odd/even: PlayerCount (r27) modulus (%) 2 */
	li  	r0, 2;
	divw	r0, r27, r0; /* Divide by 2 */
	mulli	r0, r0, 2; /* Multiply by 2 */
	sub		r0, r27, r0; /* r0 now holds even or odd (0 if even, 1 if odd) */
	
	/* If odd amount of players, load ffa. If even, teams. */
	cmpwi	r0, 1; 
	bne		loadwwteams;
	
	
	loadwwffa:
	li		r0, 0x59;
	stw		r0, FFAAddr@l(r12);
	b		storePlayerCount;
	
	loadwwteams:
	li 		r0, 0x5b;
	stw		r0, FFAAddr@l(r12);
	
	
	storePlayerCount:
	stw		r27, 0x000C (r31); /*Original*/
	b		PlayerCountAddr + 0x04;

	
	.globl  BonusBR;
	BonusBR:
	
	lis		r12, 0x8140;
	lwz		r12, 0(r12);
	/* Adding points scored to BR gain. Where r4 = Raw BR gain/loss, r12 = your points scored in the battle. */
	add		r4, r4, r12; 
	add		r0, r0, r4;
	b		BrLimit1Addr;
	
	

)


/* Notes for later: 0x8061ddd8 Controls whether the battle is balloons (0) or coins (1)
 * 80655d84, 8061ca10, keeps track of WW match number. */