package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import haxe.Json;
import lime.utils.Assets;

class Spawner extends FlxTypedGroup<Enemy>
{
	// [laser timings], [dropper timings]
	var timings:Array<Array<Array<Float>>> = [];

	var data:Dynamic;
	var types:Array<Enemy.EnemyType> = [LASER, DROPPER];

	override public function new()
	{
		super();

		var json:String = Assets.getText("assets/data/storm.json");
		if (json == null)
			data = null;
		else
			data = Json.parse(json);
		trace(data);

		if (data == null)
		{
			timings = [];
		}
		else
		{
			for (i in 0...data.data.length)
			{
				timings[i] = data.data[i];
			}
		}
	}

	public function spawn()
	{
		for (enemCatIndex in 0...timings.length)
		{
			for (enemIndex in 0...timings[enemCatIndex].length)
			{
				switch (enemCatIndex)
				{
					case 0:
						if (Conductor.songPosition == timings[enemCatIndex][enemIndex][2] - 1100)
						{
							var enem = new Enemy(timings[enemCatIndex][enemIndex][0], timings[enemCatIndex][enemIndex][1], types[enemCatIndex]);
							add(enem);
						}
					case 1:
						if (Conductor.songPosition == timings[enemCatIndex][enemIndex][2])
						{
							var enem = new Enemy(timings[enemCatIndex][enemIndex][0], timings[enemCatIndex][enemIndex][1], types[enemCatIndex]);
							add(enem);
						}
					default:
						if (Conductor.songPosition == timings[enemCatIndex][enemIndex][2])
						{
							var enem = new Enemy(timings[enemCatIndex][enemIndex][0], timings[enemCatIndex][enemIndex][1], types[enemCatIndex]);
							add(enem);
						}
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
