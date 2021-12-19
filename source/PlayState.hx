package;

import flixel.FlxState;
import flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	var player:Player;

	var yMultiples = [
		16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 272, 288, 304, 320, 336, 352, 368, 384, 400, 416, 432, 448, 464
	];
	var xMultiples = [
		16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 272, 288, 304, 320, 336, 352, 368, 384, 400, 416, 432, 448, 464, 480, 496,
		512, 528, 544, 560, 576, 592, 608, 624
	];

	override public function create()
	{
		super.create();

		player = new Player();
		add(player);
	}

	override public function update(elapsed:Float)
	{
		FlxSpriteUtil.bound(player);

		super.update(elapsed);
	}
}
