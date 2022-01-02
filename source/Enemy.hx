package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

enum EnemyType
{
	DROPPER;
	LASER;
}

class Enemy extends FlxSprite
{
	public var type:EnemyType;

	var sneakIn:Bool;
	var slam:Bool;
	var fading:Bool;

	override public function new(x:Float, y:Float, type:EnemyType)
	{
		super(x, y);

		this.type = type;

		switch (type)
		{
			case DROPPER:
				makeGraphic(16, 16, FlxColor.RED);
				angularVelocity = 180;
			case LASER:
				makeGraphic(16, FlxG.height, FlxColor.PINK);
			default:
				makeGraphic(16, 16, FlxColor.RED);
		}
	}

	function dropAI(vel:Float = 150)
	{
		velocity.y = vel;

		if (!inWorldBounds())
		{
			kill();
		}
	}

	function laserAI()
	{
		if (!sneakIn)
		{
			sneakIn = true;
			slam = true;
			fading = true;
			FlxTween.tween(this, {y: y + 10}, 0.5);
			new FlxTimer().start(1, function(timer:FlxTimer):Void slam = false);
		}
		else if (!slam)
		{
			sneakIn = true;
			slam = true;
			fading = true;
			FlxTween.tween(this, {y: 0}, 0.1);
			FlxG.camera.shake(0.01, 0.1);
			new FlxTimer().start(1, function(timer:FlxTimer):Void fading = false);
		}
		else if (!fading)
		{
			FlxTween.tween(this, {alpha: 0}, 0.5);
			new FlxTimer().start(0.5, function(timer:FlxTimer):Void kill());
		}
	}

	override function update(elapsed:Float)
	{
		switch (type)
		{
			case DROPPER:
				dropAI(300);
			case LASER:
				laserAI();
			default:
				dropAI();
		}

		super.update(elapsed);
	}
}
