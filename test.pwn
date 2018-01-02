

#include "mine.inc"


public OnGameModeInit()
{
	SetStonePricePerGram(1, 40); // Charcoal Stone
	SetStonePricePerGram(2, 100); // Gold Stone
	SetStonePricePerGram(3, 500); // Diamond Stone

	SetStoneName(1, "Charcoal Stone");
	SetStoneName(2, "Gold Stone");
	SetStoneName(3, "Diamond Stone");

	SetStoneColor(1, "A9A9A9"); // Charcoal Stone
	SetStoneColor(2, "FFD700"); // Gold Stone
	SetStoneColor(3, "00008B"); // Diamond Stone
	return 1;	
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/charc", true))
    {
    	new Float:x,
    		Float:y,
    		Float:z;

    	GetPlayerPos(playerid, x, y, z);
        CreateStone(1, x, y, z);
        return 1;
    }
    if(!strcmp(cmdtext, "/gold", true))
    {
    	new Float:x,
    		Float:y,
    		Float:z;

    	GetPlayerPos(playerid, x, y, z);
        CreateStone(2, x, y, z);
        return 1;
    }   
    if(!strcmp(cmdtext, "/diamond", true))
    {
    	new Float:x,
    		Float:y,
    		Float:z;

    	GetPlayerPos(playerid, x, y, z);
        CreateStone(3, x, y, z);
        return 1;
    } 
    return 0;
}

public OnPlayerStartMining(playerid)
{
	PlayerCanMine(playerid, true);
	return 1;
}

public OnPlayerEndMining(playerid, class, Float:Amount)
{
	new colorstr[24], 
		stonestr[36],
		string[164];

	GetStoneName(class, stonestr);
	GetStoneColor(class, colorstr);

	format(string,sizeof(string),"You took {44C300}%f{FFFFFF} Gram {%s}%s. {FFFFFF}({44C300}%d${FFFFFF})",Amount,colorstr,stonestr,GetMinedStonePrice(class, Amount));
    SendClientMessage(playerid,-1,string);	

	GivePlayerMoney(playerid, GetMinedStonePrice(class, Amount));
	return 1;
}