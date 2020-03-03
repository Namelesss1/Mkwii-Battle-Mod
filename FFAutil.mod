
 /* This mod is pretty important to my FFA mode. During the battles themselves,
  * this mod causes teams to be "completely" removed! This is done by "tricking"
  * the game into thinking that it will load a regular VS race last second even though
  * most battle functionality has already been stored. This results in an interesting 
  * combination of both battles and VS races. The User Interface is that of VS; with the
  * lap counter, whether you are in first, second, etc. As well as the results screens you
  * would see in a standard VS GP - but with battle points! Everything else works like usual in
  * battle. Finding an address to accomplish this was extremely difficult for me, but then 
  * I stumbled upon one that keeps track of what "Menu" a player is currently in. Turns out,
  * This is THE address i've been looking for!*/
 MOD_REL(
	mod_ffaResultsScreen,
	MenuManipulatorAddr,
	
	bl testTrash;
)


MOD_DOL(
	mod_ffaresults,
	0x80001798,
	
	.globl testTrash;
	testTrash:
	lis r12, FFAAddr@ha;
	lwz r11, FFAAddr@l(r12);
	cmpwi r11, 0x59;
	blt test22;
	cmpwi r11, 0x5A;
	bgt test22;
	cmpwi r4, 0x72;
	beq testtt;
	cmpwi r4, 0x73;
	beq testtt;
	cmpwi r4, 0x60;
	bne test22;
	li r4, 0x62;
	b  test22;
	
	testtt:
	li r4, 0x70;
	
	test22:
	mr r31, r4;
	blr;

)