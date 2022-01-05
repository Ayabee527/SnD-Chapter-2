package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUILine;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;

class Editor extends FlxState
{
	private var _yMultiples = [
		16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 272, 288, 304, 320, 336, 352, 368, 384, 400, 416, 432, 448, 464, 480
	];
	private var _xMultiples = [
		16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 272, 288, 304, 320, 336, 352, 368, 384, 400, 416, 432, 448, 464, 480, 496,
		512, 528, 544, 560, 576, 592, 608, 624, 640
	];
	private var _grid:FlxTypedGroup<FlxSprite>;

	var song:FlxSound;

	var timeTxt:FlxText;
	var enemTxt:FlxText;
	var curSelectedEnem:Int = 0;
	var curPlaced:Int = 0;
	var enemAmount:Int = 0;

	var cPlacedTxt:FlxText;

	// [laser], [dropper]
	// [xPos, yPos, time]
	var timings:Array<Array<Array<Float>>> = [];

	var enems = ["LASER", "DROPPER"];
	var sizes = [[16, FlxG.height], [16, 16]];
	var colors = [FlxColor.PINK, FlxColor.RED];

	var highlight:FlxSprite;

	var data:Dynamic;

	var xPos:Float;
	var yPos:Float;

	var xText:FlxText;
	var yText:FlxText;

	var sprites:Array<FlxSprite> = [];
	var times:Array<Float> = [];

	override function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);

		_grid = new FlxTypedGroup<FlxSprite>();

		highlight = new FlxSprite(0, 0).makeGraphic(16, 16, FlxColor.WHITE);
		highlight.alpha = 0.75;
		add(highlight);

		createGrid(0.75);

		song = new FlxSound();
		song.loadEmbedded("assets/music/storm.ogg", true, true);
		add(song);
		song.volume = 0.33;
		song.play(true);
		song.pause();

		timeTxt = new FlxText(10, 10, 0, "0/0", 16);
		timeTxt.color = FlxColor.CYAN;
		add(timeTxt);

		enemTxt = new FlxText(10, 0, "DROPPER", 16);
		enemTxt.color = FlxColor.CYAN;
		enemTxt.y = FlxG.height - enemTxt.height - 10;
		add(enemTxt);

		xText = new FlxText(0, 10, 0, "xPos: 0", 16);
		yText = new FlxText(0, 0, 0, "yPos: 0", 16);
		cPlacedTxt = new FlxText(0, 0, "Selected: 0", 16);

		yText.y = xText.y + xText.height + 15;
		cPlacedTxt.y = yText.y + yText.height + 15;

		add(xText);
		add(yText);
		add(cPlacedTxt);

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

		trace(timings);

		sprites = new Array<FlxSprite>();
		times = new Array<Float>();

		if (timings.length > 0)
		{
			for (enemCatIndex in 0...timings.length)
			{
				for (enemIndex in 0...timings[enemCatIndex].length)
				{
					var sprite = new FlxSprite();
					enemAmount++;
					switch (enemCatIndex)
					{
						case 0:
							sprite = new FlxSprite(timings[enemCatIndex][enemIndex][0],
								0).makeGraphic(sizes[enemCatIndex][0], sizes[enemCatIndex][1], colors[enemCatIndex]);
						case 1:
							sprite = new FlxSprite(timings[enemCatIndex][enemIndex][0],
								0).makeGraphic(sizes[enemCatIndex][0], sizes[enemCatIndex][1], colors[enemCatIndex]);
						default:
							sprite = new FlxSprite(timings[enemCatIndex][enemIndex][0],
								timings[enemCatIndex][enemIndex][1]).makeGraphic(sizes[enemCatIndex][0], sizes[enemCatIndex][1], colors[enemCatIndex]);
					}
					sprite.alpha = 0.75;
					// sprite.visible = false;
					sprites.push(sprite);

					times.push(timings[enemCatIndex][enemIndex][2]);
				}
			}
		}

		if (sprites.length > 0)
		{
			for (sprite in 0...sprites.length)
			{
				add(sprites[sprite]);
			}
		}

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

	function place()
	{
		switch (curSelectedEnem)
		{
			case 0:
				timings[curSelectedEnem][timings[curSelectedEnem].length] = [xPos, -FlxG.height, song.time];
			case 1:
				timings[curSelectedEnem][timings[curSelectedEnem].length] = [xPos, -16, song.time];
			default:
				timings[curSelectedEnem][timings[curSelectedEnem].length] = [xPos, yPos, song.time];
		}
	}

	override function update(elapsed:Float)
	{
		xText.x = FlxG.width - xText.width - 10;
		yText.x = FlxG.width - yText.width - 10;
		cPlacedTxt.x = FlxG.width - cPlacedTxt.width - 10;

		xText.text = "xPos: " + xPos;
		yText.text = "yPos: " + yPos;
		cPlacedTxt.text = (curPlaced + 1) + "/" + enemAmount;

		if (FlxG.keys.pressed.ENTER)
		{
			FlxG.camera.flash(0x00000000);
			var dat = {"data": timings};
			sys.io.File.saveContent("assets/data/storm.json", Json.stringify(dat));
		}

		if (FlxG.keys.justPressed.BACKSPACE)
		{
			var dat = {"data": timings};
			sys.io.File.saveContent("assets/data/storm.json", Json.stringify(dat));
			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			if (!song.playing)
				song.resume();
			else if (song.playing)
				song.pause();
		}

		if (FlxG.keys.justPressed.R)
		{
			song.time = 0;
		}

		if (FlxG.keys.justPressed.QUOTE)
		{
			FlxG.camera.flash(FlxColor.RED);
			timings = [[[320, -FlxG.height, 0]]];
			var dat = {"data": timings};
			sys.io.File.saveContent("assets/data/storm.json", Json.stringify(dat));
			FlxG.resetState();
		}

		timeTxt.text = song.time + "/" + song.length;
		enemTxt.text = enems[curSelectedEnem];

		if (FlxG.keys.justPressed.LEFT)
		{
			if (curSelectedEnem == 0)
				curSelectedEnem = enems.length - 1;
			else
				curSelectedEnem--;
		}
		else if (FlxG.keys.justPressed.RIGHT)
		{
			if (curSelectedEnem == enems.length - 1)
				curSelectedEnem = 0;
			else
				curSelectedEnem++;
		}

		if (!song.playing)
		{
			if (FlxG.keys.pressed.UP)
			{
				if (FlxG.keys.pressed.SHIFT)
					song.time -= 100;
				else if (FlxG.keys.pressed.CONTROL)
					song.time -= 1000;
				else
					song.time -= 10;
			}
			if (FlxG.keys.pressed.DOWN)
			{
				if (FlxG.keys.pressed.SHIFT)
					song.time += 100;
				else if (FlxG.keys.pressed.CONTROL)
					song.time += 1000;
				else
					song.time += 10;
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			var dat = {"data": timings};
			sys.io.File.saveContent("assets/data/storm.json", Json.stringify(dat));
			FlxG.switchState(new PlayState());
		}

		if (song.time < 0)
		{
			song.time = 0;
		}

		for (i in -1..._xMultiples.length - 1)
		{
			for (j in -1..._yMultiples.length - 1)
			{
				if (FlxG.mouse.x > _xMultiples[i] && FlxG.mouse.x < _xMultiples[i + 1])
				{
					highlight.x = _xMultiples[i];
					xPos = _xMultiples[i];
				}
				if (FlxG.mouse.y > _yMultiples[j] && FlxG.mouse.y < _yMultiples[j + 1])
				{
					highlight.y = _yMultiples[j];
					yPos = _yMultiples[j];
				}
			}
		}

		if (FlxG.mouse.justPressed)
		{
			if (timings[curSelectedEnem] == null)
			{
				timings[curSelectedEnem] = [];
				place();
			}
			else
			{
				place();
			}
		}

		if (!song.playing)
		{
			if (FlxG.keys.justPressed.Q)
			{
				if (curPlaced == 0)
					curPlaced = enemAmount - 1;
				else
					curPlaced--;
			}
			else if (FlxG.keys.justPressed.E)
			{
				if (curPlaced == enemAmount - 1)
					curPlaced = 0;
				else
					curPlaced++;
			}
		}

		if (!song.playing)
		{
			if (FlxG.keys.justPressed.Q || FlxG.keys.justPressed.E)
			{
				song.time = times[curPlaced];
			}
		}

		for (time in 0...times.length)
		{
			if (!song.playing)
			{
				if (song.time == times[time])
				{
					sprites[time].visible = true;
				}
				else
				{
					sprites[time].visible = false;
				}
			}
			else
			{
				sprites[time].visible = false;
			}
		}

		super.update(elapsed);
	}
}
