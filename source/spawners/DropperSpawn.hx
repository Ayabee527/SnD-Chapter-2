package spawners;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import haxe.Json;
import lime.utils.Assets;

class DropperSpawn extends FlxTypedGroup<Enemy>
{
	// [laser timings], [dropper timings]
	var timings:Array<Array<Array<Float>>> = [];

	var data:Dynamic;

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
				if (enemCatIndex == 1)
				{
					if (Conductor.songPosition == timings[enemCatIndex][enemIndex][2])
					{
						var enem = new Enemy(timings[enemCatIndex][enemIndex][0], timings[enemCatIndex][enemIndex][1], DROPPER);
						add(enem);
					}
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		spawn();

		super.update(elapsed);
	}
}
