# SA-MP Mining

Dynamic Mining System Framework.


### How To Install

Put mine.inc and MINE folder in pawn > includes.

After that do this in your gamemode.

```
#include <mine>
```

### Functions

Functions to use this library.

```
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
```

### Callbacks

Callbacks which you need to use

```
forward OnPlayerEndMining(playerid,class, Float:Amount);
forward OnPlayerStartMining(playerid);
```

## Loading stones from file

Create file in scriptfiles. Name it what you want. Under OnGameModeInit write LoadStones("FileName");

At this moment, LoadStones function is still under development. Right now if you want to load stones from file, in file you would write positions with this format. StonePositions(x, y, z);

```
StonePositions(2562.507812,-1529.606811,1399.841064);
```

Stone class will be choosen randomly.

## Contributing

If you have any idea, to improve this script, feel free to do this. After doing some fix or Finding any bug please open issue or make pull request.


## Authors

* **Medzvel** - *Initial work* - [Medzvel](https://github.com/medzvel)

See also the list of [contributors](https://github.com/medzvel/SA-MP-Mining/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
