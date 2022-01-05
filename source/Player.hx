package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	var moveTimer:Float = 0;

	override public function new(x:Float = 16, y:Float = 16)
	{
		super(x, y);

		// makeGraphic(16, 16, FlxColor.WHITE);
		loadGraphic("assets/images/player.png", true, 16, 16);
	}

	function gridMove(elapsed:Float)
	{
		var up = FlxG.keys.anyPressed([W, UP]);
		var left = FlxG.keys.anyPressed([A, LEFT]);
		var down = FlxG.keys.anyPressed([S, DOWN]);
		var right = FlxG.keys.anyPressed([D, RIGHT]);

		var delay = 0.075;

		if (moveTimer > delay)
		{
			if (up)
				y -= 16;
			if (left)
				x -= 16;
			if (down)
				y += 16;
			if (right)
				x += 16;

			moveTimer -= delay;
		}

		moveTimer += elapsed;
	}

	function move()
	{
		var up = FlxG.keys.anyPressed([W, UP]);
		var left = FlxG.keys.anyPressed([A, LEFT]);
		var down = FlxG.keys.anyPressed([S, DOWN]);
		var right = FlxG.keys.anyPressed([D, RIGHT]);

		var angle:Float = 0;
		if (up)
		{
			angle = -90;
			if (left)
				angle -= 45;
			else if (right)
				angle += 45;
		}
		else if (down)
		{
			angle = 90;
			if (left)
				angle += 45;
			else if (right)
				angle -= 45;
		}
		else if (left)
		{
			angle = 180;
		}
		else if (right)
		{
			angle = 0;
		}

		if ((up || down || left || right))
		{
			velocity.x = Math.cos(angle * FlxAngle.TO_RAD) * 200;
			velocity.y = Math.sin(angle * FlxAngle.TO_RAD) * 200;
		}
		else if (!(up || down || left || right))
		{
			velocity.set(0, 0);
		}
	}

	override function update(elapsed:Float)
	{
		gridMove(elapsed);
		// move();

		super.update(elapsed);
	}
}
