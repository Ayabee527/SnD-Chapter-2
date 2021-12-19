package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	var moveTimer:Float = 0;

	override public function new(x:Float = 16, y:Float = 16)
	{
		super(x, y);

		makeGraphic(16, 16, FlxColor.WHITE);
	}

	function move(elapsed:Float)
	{
		var up = FlxG.keys.anyPressed([W, UP]);
		var left = FlxG.keys.anyPressed([A, LEFT]);
		var down = FlxG.keys.anyPressed([S, DOWN]);
		var right = FlxG.keys.anyPressed([D, RIGHT]);

		var delay = 0.1;

		if (moveTimer > delay)
		{
			if (up)
				y -= 16;
			else if (left)
				x -= 16;
			else if (down)
				y += 16;
			else if (right)
				x += 16;

			moveTimer -= delay;
		}

		moveTimer += elapsed;
	}

	override function update(elapsed:Float)
	{
		move(elapsed);

		super.update(elapsed);
	}
}
