#include <YSI\y_hooks>
#include <progress2>

//Namespace
#define Mine:: mine_

//Callbacks
forward OnPlayerEndMining(playerid,class, Float:Amount);
forward OnPlayerStartMining(playerid);

//COLORS FOR STONES
#define MINING_GREY 0xAFAFAFAA
#define MINING_YELLOW 0xFFFF00AA
#define MINING_BLUE 16777215

//MINING TEXTDRAW
new Text:MINEGLOBALTD[2];
new PlayerText:MINEPLAYERTD[MAX_PLAYERS][1];

//MINING BAR
new PlayerBar:MiningBar[MAX_PLAYERS], Float:MiningValue[MAX_PLAYERS];

//MINING VARIABLES FOR PLAYER
new bool:PlayerIsMining[MAX_PLAYERS];
new MiningTimer[MAX_PLAYERS];
new Float:MinedGrams[MAX_PLAYERS];
new Float:CheckStoneLeftGrams[MAX_PLAYERS];
new bool:Mine::PlayerCanMine;
new PlayerIsMiningStoenID[MAX_PLAYERS];

hook OnGameModeInit()
{
	CreateMiningGlobalTD();
	return 1;
}

hook OnPlayerConnect(playerid)
{
	CreateMiningPlayerTD(playerid);
	PlayerIsMining[playerid] = false;
	MiningBar[playerid] = CreatePlayerProgressBar(playerid, 276.000000, 335.000000, 141.000000, 24.700000, -1429936641, 40.0000, 0); 
	return 1;
}


StartMiningActionForPlayer(playerid)
{
	TextDrawShowForPlayer(playerid, MINEGLOBALTD[0]);
	TextDrawShowForPlayer(playerid, MINEGLOBALTD[1]);
	PlayerTextDrawShow(playerid, MINEPLAYERTD[playerid][0]);
	ShowPlayerProgressBar(playerid, MiningBar[playerid]);
	TogglePlayerControllable(playerid, 0);
	PlayerIsMining[playerid] = true;
	MiningTimer[playerid] = SetTimerEx("CheckMiningValue", 350, true, "i", playerid);
	//ApplyAnimation(playerid, "CHAINSAW", "CSAW_1", 4.1, 1, 1, 1, 1, 1, 1);
	ApplyAnimation(playerid, "CHAINSAW", "CSAW_1", 4.1, 1, 1, 1, 1, 1, 1);
}

CancelMiningActionForPlayer(playerid)
{
	TextDrawHideForPlayer(playerid, MINEGLOBALTD[0]);
	TextDrawHideForPlayer(playerid, MINEGLOBALTD[1]);
	PlayerTextDrawHide(playerid, MINEPLAYERTD[playerid][0]);
	HidePlayerProgressBar(playerid, MiningBar[playerid]);
	TogglePlayerControllable(playerid, 1);
	PlayerIsMining[playerid] = false;
	MiningValue[playerid] = 0;
	SetPlayerProgressBarValue(playerid, MiningBar[playerid], MiningValue[playerid]);
	KillTimer(MiningTimer[playerid]);
	SetPlayerSpecialAction(playerid,0);
	Stones[PlayerIsMiningStoenID[playerid]][SomeoneMining] = false;
}

forward CheckMiningValue(playerid);
public CheckMiningValue(playerid)
{
	if(MiningValue[playerid] >= 0.0)
	{
		MiningValue[playerid] = MiningValue[playerid] - frandom(5.0, 2.5);
		SetPlayerProgressBarValue(playerid, MiningBar[playerid], MiningValue[playerid]);
	}	
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 1024)
	{
		for(new i; i<CreatedStones; i++)
		if(IsPlayerInRangeOfPoint(playerid, 2.0, Stones[i][stX], Stones[i][stY], Stones[i][stZ]) && !PlayerIsMining[playerid])
		{	
			new string[164];
			if(Stones[i][sHP] <= 0.0) return SendClientMessage(playerid, -1, "[MINING ERROR] This stone is already mined!");
			if(Stones[i][SomeoneMining]) return SendClientMessage(playerid, -1, "[MINING ERROR] Someone is already mining this stone!");
			if(funcidx("OnPlayerStartMining") != -1) CallLocalFunction("OnPlayerStartMining","d",playerid);
			if(Mine::PlayerCanMine)
			{
				switch(Stones[i][sClass])
				{
					case 1: 
					{
						PlayerTextDrawColor(playerid, MINEPLAYERTD[playerid][0], MINING_GREY);
						SetPlayerProgressBarMaxValue(playerid, MiningBar[playerid], 35);
					}	
					case 2: 
					{
						PlayerTextDrawColor(playerid, MINEPLAYERTD[playerid][0], MINING_YELLOW);
						SetPlayerProgressBarMaxValue(playerid, MiningBar[playerid], 80);
					}	
					case 3: 
					{
						PlayerTextDrawColor(playerid, MINEPLAYERTD[playerid][0], MINING_BLUE);
						SetPlayerProgressBarMaxValue(playerid, MiningBar[playerid], 130);
					}	
				}
				GetStoneName(Stones[i][sClass], string);
				PlayerTextDrawSetString(playerid, MINEPLAYERTD[playerid][0], string);
				PlayerIsMiningStoenID[playerid] = i;
				Stones[i][SomeoneMining] = true;
				StartMiningActionForPlayer(playerid);
			}	
		}	
	}
	if(newkeys == KEY_FIRE)
	{
		for(new i; i<CreatedStones; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Stones[i][stX], Stones[i][stY], Stones[i][stZ]) && PlayerIsMining[playerid])
			{
				switch(Stones[i][sClass])
				{
					case 1: MiningValue[playerid] = MiningValue[playerid] + frandom(7.8, 3.5);
					case 2: MiningValue[playerid] = MiningValue[playerid] + frandom(5.5, 1.5);
					case 3: MiningValue[playerid] = MiningValue[playerid] + frandom(3.5, 1.0);
				}
				//MiningValue[playerid] = MiningValue[playerid] + frandom(10.0, 7.8);
				SetPlayerProgressBarValue(playerid, MiningBar[playerid], MiningValue[playerid]);
				if(MiningValue[playerid] >= GetPlayerProgressBarMaxValue(playerid, MiningBar[playerid]))
				{
					CancelMiningActionForPlayer(playerid);
					MinedGrams[playerid] = frandom(10.0, 5.5);
					CheckStoneLeftGrams[playerid] = Stones[i][sHP] - MinedGrams[playerid];
					if(CheckStoneLeftGrams[playerid] < 0.0) MinedGrams[playerid] = Stones[i][sHP];
					Stones[i][sHP] = Stones[i][sHP] - MinedGrams[playerid];
					if(Stones[i][sHP] <= 0.0)
					{
						Stones[i][sHP] = 0.0;
						if(Stones[i][sClass] == 2 || Stones[i][sClass] == 3)
						{
							Stones[i][sClass] = 1;
							Stones[i][sHP] = frandom(100.0, 10.0);
							DestroyDynamicObject(Stones[i][sObject]);
							Stones[i][sObject] = CreateDynamicObject(MAINSTONEOBJECT,Stones[i][stX],Stones[i][stY],Stones[i][stZ],0.000,5.000,0.000,-1,-1,-1,7777.777,7777.777);
						}
					}
					new string[126], stonename[34], stonecolour[14];
					GetStoneName(Stones[i][sClass], stonename);
					GetStoneColour(Stones[i][sClass], stonecolour);
					format(string, sizeof(string), "{%s}%s\n{73E774}Grams: {FFFFFF}%f",stonecolour, stonename, Stones[i][sHP]);
					UpdateDynamic3DTextLabelText(Stones[i][sLabel], 0xFFFF00FF, string);
					if(funcidx("OnPlayerEndMining") != -1) CallLocalFunction("OnPlayerEndMining","ddf",playerid,Stones[i][sClass], MinedGrams[playerid]);
					MinedGrams[playerid] = 0.0;
				}

			}
		}
	}
	if(newkeys == KEY_HANDBRAKE)
	{
		for(new i; i<CreatedStones; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Stones[i][stX], Stones[i][stY], Stones[i][stZ]) && PlayerIsMining[playerid])
			{
				CancelMiningActionForPlayer(playerid);
			}
		}		
	}
	return 1;
}

CreateMiningGlobalTD()
{
	MINEGLOBALTD[0] = TextDrawCreate(420.828002, 368.816497, "box");
	TextDrawLetterSize(MINEGLOBALTD[0], 0.000000, -6.621235);
	TextDrawTextSize(MINEGLOBALTD[0], 267.290283, 0.000000);
	TextDrawAlignment(MINEGLOBALTD[0], 1);
	TextDrawColor(MINEGLOBALTD[0], -1);
	TextDrawUseBox(MINEGLOBALTD[0], 1);
	TextDrawBoxColor(MINEGLOBALTD[0], -5963521);
	TextDrawSetShadow(MINEGLOBALTD[0], 0);
	TextDrawSetOutline(MINEGLOBALTD[0], 0);
	TextDrawBackgroundColor(MINEGLOBALTD[0], 255);
	TextDrawFont(MINEGLOBALTD[0], 1);
	TextDrawSetProportional(MINEGLOBALTD[0], 1);
	TextDrawSetShadow(MINEGLOBALTD[0], 0);

	MINEGLOBALTD[1] = TextDrawCreate(274.538726, 313.083343, "MINING");
	TextDrawLetterSize(MINEGLOBALTD[1], 0.400000, 1.600000);
	TextDrawAlignment(MINEGLOBALTD[1], 1);
	TextDrawColor(MINEGLOBALTD[1], -1);
	TextDrawSetShadow(MINEGLOBALTD[1], 0);
	TextDrawSetOutline(MINEGLOBALTD[1], 1);
	TextDrawBackgroundColor(MINEGLOBALTD[1], 255);
	TextDrawFont(MINEGLOBALTD[1], 1);
	TextDrawSetProportional(MINEGLOBALTD[1], 1);
	TextDrawSetShadow(MINEGLOBALTD[1], 0);
}


CreateMiningPlayerTD(playerid)
{
	MINEPLAYERTD[playerid][0] = CreatePlayerTextDraw(playerid, 332.242248, 313.283355, "DIAMOND_ORE");
	PlayerTextDrawLetterSize(playerid, MINEPLAYERTD[playerid][0], 0.337686, 1.576667);
	PlayerTextDrawAlignment(playerid, MINEPLAYERTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, MINEPLAYERTD[playerid][0], 16777215);
	PlayerTextDrawSetShadow(playerid, MINEPLAYERTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, MINEPLAYERTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, MINEPLAYERTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, MINEPLAYERTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, MINEPLAYERTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, MINEPLAYERTD[playerid][0], 0);
}
