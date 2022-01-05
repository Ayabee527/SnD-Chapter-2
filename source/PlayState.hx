package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.shapes.FlxShapeLine;
import flixel.addons.transition.TransitionData;
import flixel.addons.ui.FlxUILine;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import spawners.DropperSpawn;
import spawners.LaserSpawn;

class PlayState extends FlxState
{
	private var _yMultiples = [
		16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 272, 288, 304, 320, 336, 352, 368, 384, 400, 416, 432, 448, 464
	];
	private var _xMultiples = [
		16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 272, 288, 304, 320, 336, 352, 368, 384, 400, 416, 432, 448, 464, 480, 496,
		512, 528, 544, 560, 576, 592, 608, 624
	];
	private var _grid:FlxTypedGroup<FlxSprite>;

	private var song:FlxSound;
	private var lastBeat:Float;
	private var _totalBeats:Float = 0;
	private var _totalBars:Float = 0;

	private var _camIn:Bool;
	private var _camOut:Bool;

	private var _player:Player;

	private var enemies:FlxTypedGroup<FlxTypedGroup<Enemy>>;
	private var lasers:LaserSpawn;
	private var droppers:DropperSpawn;

	var spawn:Bool;

	override public function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);

		song = new FlxSound();
		song.loadEmbedded("assets/music/storm.ogg", true, true);
		add(song);
		song.volume = 0.33;
		song.play(true);

		Conductor.bpm = 140;

		lastBeat = 0;

		_player = new Player(FlxG.width / 2, FlxG.height / 2);
		add(_player);

		_grid = new FlxTypedGroup<FlxSprite>();
		createGrid(0.05);

		lasers = new LaserSpawn();
		droppers = new DropperSpawn();

		enemies = new FlxTypedGroup<FlxTypedGroup<Enemy>>();
		enemies.add(lasers);
		enemies.add(droppers);
		add(enemies);

		super.create();
	}

	function createGrid(alpha:Float)
	{
		for (i in 0..._xMultiples.length)
		{
			var line = new FlxUILine(_xMultiples[i], 0, VERTICAL, FlxG.height, 2, 0xFF999999);
			_grid.add(line);
		}
		for (i in 0..._yMultiples.length)
		{
			var line = new FlxUILine(0, _yMultiples[i], HORIZONTAL, FlxG.width, 2, 0xFF999999);
			_grid.add(line);
		}
		add(_grid);

		for (line in _grid)
			line.alpha = alpha;
	}

	override public function update(elapsed:Float)
	{
		FlxG.watch.add(song, "time");
		FlxG.watch.add(this, "lastBeat");
		FlxG.watch.add(Conductor, "crochet");
		FlxG.watch.add(this, "_totalBeats");
		FlxG.watch.add(this, "_totalBars");

		Conductor.songPosition = song.time;
		// Every beat
		if (Conductor.songPosition > lastBeat + Conductor.crochet)
		{
			lastBeat += Conductor.crochet;
			_totalBeats += 1;
			_totalBars += _totalBeats / 4;
		}

		for (spawner in enemies)
		{
			for (enemy in spawner)
			{
				if (!enemy.alive)
				{
					spawner.remove(enemy);
				}
			}
		}

		if (FlxG.overlap(_player, enemies))
		{
			FlxG.camera.shake(0.02, 0.2);
			FlxG.camera.flash(FlxColor.RED, 0.25);
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() FlxG.switchState(new Editor()));
		}

		FlxSpriteUtil.bound(_player);

		super.update(elapsed);
	}
}
