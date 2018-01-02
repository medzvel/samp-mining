/*
	MINING stYSTEM FRAMEWORK - UTILS
	Last Update - 8/25/2017
	Script Version - 0.1
	Created By Amagida (2017)
*/

#if !defined PICKAXE_MODEL
	#define PICKAXE_MODEL (18635)
#endif

#if !defined MAIN_STONE_MODEL
	#define MAIN_STONE_MODEL (3930)
#endif

#if !defined MAX_STONES
	#define MAX_STONES (500)
#endif

#if !defined MAX_STONE_NAME
	#define MAX_STONE_NAME (32)
#endif

enum Stone
{
	sID,
	Float:stX,
	Float:stY,
	Float:stZ,
	sClass,
	Float:sHP,
	Text3D:sLabel,
	sObject,
	bool:SomeoneMining
}

static
	Stone_Name[4][MAX_STONE_NAME],
	Stone_Color[4][16];

new
	Stones[MAX_STONES][Stone],
	StonePricePerGram[4],
	CreatedStones = 0,
	goldgenerated = 0,
	diamondgenerated = 0;


forward CreateGoldStone(Float:x, Float:y, Float:z, name = 2);
forward CreateNormalStone(Float:x, Float:y, Float:z, name = 1);
forward CreateDiamondStone(Float:x, Float:y, Float:z, name = 3);
forward DebugStone(stone);
forward SetStoneName(class, name[]);
forward GetStoneDefaultName(class, out[], length = sizeof(out));
forward GetStoneName(class, out[], length = sizeof(out));
forward CreateStone(class, Float:x, Float:y, Float:z);
forward DestroyStone(stoneid);
forward IsValidStoneID(stoneid);
forward SetStonePricePerGram(class, price);
forward GetMinedStonePrice(class, Float:grams);
forward GetStonePricePerGram(class);
forward LoadStones(filename[]);
forward GetStoneID(stone);
forward AddStone(filename[], Float:x, Float:y, Float:z);
/* END OF FORWARDS */

/* USED TOOLS */
stock Float:frandom(Float:max, Float:min = 0.0, dp = 4)
{
    new
        Float:mul = floatpower(10.0, dp),
        imin = floatround(min * mul),
        imax = floatround(max * mul);
    return float(random(imax - imin) + imin) / mul;
}
stock minrand(min, max) //By Alex "Y_Less" Cole
{
	return random(max - min) + min;
}
/* END OF USED TOOLS */

stock CreateStone(class,Float:x, Float:y, Float:z)
{
	if(class < 1) return printf("Class Can't Be Less Then 1!");
	switch(class)
	{
		case 1: CreateNormalStone(x,y,z);
		case 2: CreateGoldStone(x,y,z);
		case 3: CreateDiamondStone(x,y,z);
	}

	return 1;
}

stock CreateDiamondStone(Float:x, Float:y, Float:z, name = 3)
{
	new
		stonename[36],
		stonecolor[16],
		string[126];

	Stones[CreatedStones][stX] = x;
	Stones[CreatedStones][stY] = y;
	Stones[CreatedStones][stZ] = z;
	Stones[CreatedStones][sClass] = 3;
	Stones[CreatedStones][sHP] = frandom(100.0, 10.0);
	Stones[CreatedStones][sObject] = CreateDynamicObject(
			MAIN_STONE_MODEL,
			x, y, z,
			0.000, 5.000, 0.000,
			-1, -1, -1,
			7777.777, 7777.777);
	Stones[CreatedStones][SomeoneMining] = false;

	SetDynamicObjectMaterial(
		Stones[CreatedStones][sObject], 0, 5154,
		"dkcargoshp_las2", "Diamondp64", 0xFFFFFFFF);

	GetStoneName(name, stonename);
	GetStoneColor(name, stonecolor);

	format(string, sizeof(string),
		"{%s}%s\n{73E774}Grams: {FFFFFF}%f",
		stonecolor, stonename, Stones[CreatedStones][sHP]);

	Stones[CreatedStones][sLabel] = CreateDynamic3DTextLabel(string, 0xFFFF00FF, x, y, z, 2.0);

	return CreatedStones++;
}

stock CreateGoldStone(Float:x, Float:y, Float:z, name = 2)
{
	new
		stonename[36],
		stonecolor[16],
		string[126];

	Stones[CreatedStones][stX] = x;
	Stones[CreatedStones][stY] = y;
	Stones[CreatedStones][stZ] = z;
	Stones[CreatedStones][sClass] = 2;
	Stones[CreatedStones][sHP] = frandom(100.0, 10.0);
	Stones[CreatedStones][sObject] = CreateDynamicObject(MAIN_STONE_MODEL,x,y,z,0.000,5.000,0.000,-1,-1,-1,7777.777,7777.777);
	Stones[CreatedStones][SomeoneMining] = false;

	SetDynamicObjectMaterial(Stones[CreatedStones][sObject], 0, 8463, "vgseland", "tiadbuddhagold", 0xFFFFFFFF);

	GetStoneName(name, stonename);
	GetStoneColor(name, stonecolor);

	format(string, sizeof(string), "{%s}%s\n{73E774}Grams: {FFFFFF}%f",stonecolor, stonename, Stones[CreatedStones][sHP]);
	Stones[CreatedStones][sLabel] = CreateDynamic3DTextLabel(string, 0xFFFF00FF, x, y, z, 2.0);

	return CreatedStones++;
}

stock DestroyStone(stoneid)
{
	if(!IsValidStoneID(stoneid))
	{
		printf("[MINING ERROR] Stone ID Is Not Correct");
		return 1;
	}

	Stones[stoneid][stX] = 0.0;
	Stones[stoneid][stY] = 0.0;
	Stones[stoneid][stZ] = 0.0;
	Stones[stoneid][sHP] = 0.0;

	DestroyDynamicObject(Stones[stoneid][sObject]);
	DestroyDynamic3DTextLabel(Stones[stoneid][sLabel]);

	return 0;
}

stock IsValidStoneID(stoneid)
{
	if(!(0 <= stoneid < CreatedStones))
	{
		return false;
	}

	return true;
}

stock GetStoneID(stone)
{
	return Stones[stone][sID];
}

stock CreateNormalStone(Float:x, Float:y, Float:z, name = 1)
{
	new stonename[36], stonecolor[16], string[126];

	CreatedStones++;

	Stones[CreatedStones][sID] = CreatedStones;
	Stones[CreatedStones][stX] = x;
	Stones[CreatedStones][stY] = y;
	Stones[CreatedStones][stZ] = z;
	Stones[CreatedStones][sClass] = 1;
	Stones[CreatedStones][sHP] = frandom(100.0, 10.0);
	Stones[CreatedStones][sObject] = CreateDynamicObject(MAIN_STONE_MODEL,x,y,z,0.000,5.000,0.000,-1,-1,-1,7777.777,7777.777);
	Stones[CreatedStones][SomeoneMining] = false;

	SetObjectMaterial(Stones[CreatedStones][sObject], 0, 18202, "w_towncs_t", "hatwall256hi", 0xFFFFFFFF);

	GetStoneName(name, stonename);
	GetStoneColor(name, stonecolor);

	format(string, sizeof(string), "{%s}%s\n{73E774}Grams: {FFFFFF}%f",stonecolor, stonename, Stones[CreatedStones][sHP]);
	Stones[CreatedStones][sLabel] = CreateDynamic3DTextLabel(string, 0xFFFF00FF, x, y, z, 2.0);
}

stock SetStonePricePerGram(class, price)
{
	if(class > 4)
	{
		print("[MINING ERROR] Class Can't Be More Then 4!");
	}
	else
	{
		StonePricePerGram[class] = price;
	}
}

stock GetStonePricePerGram(class)
{
	if(class > 4)
	{
		print("[MINING ERROR] Class Can't Be More Then 4!");
	}
	return StonePricePerGram[class];
}

stock GetMinedStonePrice(class, Float:grams)
{
	if(class > 4) return print("[MINING ERROR] Class Can't Be More Then 4!");
	new Float:firststep;
	firststep = GetStonePricePerGram(class) * grams;
	new GeneratedPrice = floatround(firststep);
	return GeneratedPrice;
}

stock SetStoneName(class, name[])
{
	strcat(Stone_Name[class], name);
}

stock SetStoneColor(class, color[])
{
	strcat(Stone_Color[class], color);
}

stock GetStoneName(class, out[], length = sizeof(out))
{
    if(isnull(Stone_Name[class]))
    {
        printf("[MINEING ERROR] Stone Name For Class ID: %d, Not Found! Setting Stone Name To Default!", class);

        GetStoneDefaultName(class, out,length);
    }
    else
    {
        strcat(out, Stone_Name[class], length);
    }
}

stock GetStoneDefaultName(class, out[], length = sizeof(out))
{
	if(class > 4)
	{
		printf("[MINEING ERROR] Theres Class With ID %d",class);
	}
	else
	{
		switch(class)
		{
			case 1:
			{
				strcat(out, "Normal Rock",length);
				SetStoneName(class, out);
			}

			case 2:
			{
				strcat(out, "Gold Ore", length);
				SetStoneName(class, out);
			}

			case 3:
			{
				strcat(out, "Diamond Ore", length);
				SetStoneName(class, out);
			}
		}
	}
}

stock DebugStone(stone)
{
	new ID = GetStoneID(stone);

	printf("DEBUG : Stone ID %d", ID);

	new Float:x,
		Float:y,
		Float:z;

	x = Stones[stone][stX];
	y = Stones[stone][stY];
	z = Stones[stone][stZ];

	printf("DEBUG : Position of Stone ID %d \n X : %f \n Y : %f \n Z : %f", ID, x, y, z);
}


stock GetStoneColor(class, out[], length = sizeof(out))
{
	if(isnull(Stone_Color[class]))
	{
		printf("[MINING ERROR] Color For Stone Class %d Not Found! Setting Color To Default!", class);
		GetStoneDefaultColor(class, out, length);
	}
	else
	{
		strcat(out, Stone_Color[class], length);
	}
}


stock GetStoneDefaultColor(class, out[], length = sizeof(out))
{
	switch(class)
	{
		case 1:
		{
			strcat(out, "ADADAD", length);
			SetStoneColor(class, out);
		}
		case 2:
		{
			strcat(out, "DBF055", length);
			SetStoneColor(class, out);
		}
		case 3:
		{
			strcat(out, "88EEF9", length);
			SetStoneColor(class, out);
		}
	}
}


stock AddStone(filename[], Float:x, Float:y, Float:z)
{
	new File:file, string[264];
	if(!fexist(filename))
	{
		printf("[MINING ERROR] file: \"%s\" NOT FOUND", filename);
		return 0;
	}
	file = fopen(filename, io_append);
	format(string, sizeof(string), "StonePositions(%f, %f,%f);\r\n", class, x, y, z);
	fwrite(file, string);
	fclose(file);
	printf("Added New Stone positions: X: %f, Y: %f, Z: %f", class, x, y, z);
	return 1;
}



stock GotoStone(playerid, stoneid)
{
	new Float:x, Float:y, Float:z;
	x = Stones[stoneid][stX];
	y = Stones[stoneid][stY];
	z = Stones[stoneid][stZ];
	SetPlayerPos(playerid, x, y, z);
}



stock LoadStones(filename[])
{
	new
		File:file,
		line[256],
		linenumber = 1,
		count,

		funcname[32],
		funcargs[128],

		Float:x,
		Float:y,
		Float:z;

	if(!fexist(filename))
	{
		printf("[MINING ERROR] file: \"%s\" NOT FOUND", filename);
		return 0;
	}

	file = fopen(filename, io_read);

	if(!file)
	{
		printf("[MINING ERROR] \"%s\" NOT LOADED", filename);
		return 0;
	}

	while(fread(file, line))
	{
		if(line[0] < 65)
		{
			linenumber++;
			continue;
		}

		if(sscanf(line, "p<(>s[32]p<)>s[128]{s[96]}", funcname, funcargs))
		{
			linenumber++;
			continue;
		}

		if(!strcmp(funcname, "StonePositions"))
		{
			if(sscanf(funcargs, "p<,>fff", x, y, z))
			{
				printf("[MINING ERROR] [LOADING] Malformed parameters on line %d", linenumber);
				linenumber++;
				continue;
			}
			new randomclass = 1;
			count++;
			linenumber++;
			new randomchanceforrare = random(100);
			if(count > 30 && goldgenerated < 5 && randomchanceforrare > 90)
			{
				randomclass = 2;
				goldgenerated++;
				printf("[MINING DEBUG] Gold Stone Generated With Chance ID: %d", randomchanceforrare);
			}
			if(count > 60 && diamondgenerated < 1 && randomchanceforrare < 10)
			{
				randomclass = 3;
				diamondgenerated++;
				printf("[MINING DEBUG] Diamond Stone Generated With Chance ID: %d", randomchanceforrare);
			}
			CreateStone(randomclass, x, y, z-1.0);
		}
	}

	printf("[MINING] Loaded %d stone position from '%s'.", count, filename);

	return 1;
}
