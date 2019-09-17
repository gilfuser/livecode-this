/*
https://sccode.org/1-1HT
record, save the file in a sample folder, load and copy the file name. All you need to do is paste it in your tidal code.
Change the paths to match the ones in your computer, and set SC to have enough out channels.
It depends on EspClock Quark to sync SC and Tidal. You can install it via Quarks.gui.
Download and install EspGrid: https://github.com/d0kt0r0/EspGrid (you will need as soon its working with Tidal 1.0.x)
Start EspGrid.

boot the server, start SuperDirt and evaluate this:
{
t = EspClock.new;
0.1.wait;
t.start;
0.1.wait;
}.fork;
TempoClock.default.tempo;
only then, evaluate what follows
You can change the tempo in the GUI and press enter. No need to reload.
New recordings with the same name will substitute the older.
If they are being played in Tidal they will change there instantly.
*/

var click_out = 0;
var win = Window("Super Looper", Rect(100, 200, 800, 200)).front;
var numbufs = 16;
var layout = win.addFlowLayout((0@0), (0@0));
var container = ();
var size = (40@40);
var metronome = ();
var font = Font("Synchro LET", 18);
var buffer = nil!numbufs;
var durations = [2,4,8,16];
var player = nil!numbufs;
var player_button = (nil!(numbufs/4))!4;
var recorder_button = (nil!(numbufs/4))!4;
var reload_func = {
	var tempo = l.tempo;
	numbufs.do{ |i|
		var slot = floor(i/(numbufs/4));
		buffer[i].free;
		buffer[i] = Buffer.alloc(s, s.sampleRate * durations[slot] * tempo);
	};
};
var recordCounter = 0;

TempoClock.default = l; // link.scd
// Window
win.view.background_(Color.white);

// Controls
StaticText(win, (800@10));

StaticText(win, (100@30))
.font_(font)
.string_(" Tempo:");

NumberBox(win, (100@30))
.align_(\right)
.font_(font)
.step_(0.01)
.scroll_step_(0.1)
.clipLo_(40)
.clipHi_(400)
.value_(TempoClock.default.tempo * 60)
.action_{ |v| TempoClock.default.tempo = (v.value / 60).postln};

StaticText(win, (40@10));
Button(win, (120@30))
.font_(font)
.states_([["Reload", Color.red, Color.white]])
.action_{ reload_func.value };
StaticText(win, (40@10));


StaticText(win, (100@30))
.font_(font)
.align_(\center)
.string_(" Click:");

metronome.button = Button(win, (100@30)).states_([
	["OFF", Color.white, Color.black],
	["ON", Color.white, Color.red(0.75)],
])
.font_(font)
.action_{ |v|
	if ( v.value.booleanValue )
	{ metronome.player_instance = metronome.player.play(quant:4) }
	{ metronome.player_instance.stop }
};

metronome.display = 4.collect{
	StaticText(win, (15@10));
	UserView(win, (30@30)).background_(Color.red(0.25))
};
StaticText(win, (15@10));
StaticText(win, (800@10));
layout.nextLine;

4.do{ |i| StaticText(win, (200@30)).align_(\center).font_(font).string_(durations[i]) };

// Loopers
4.do{ |i|
	var font = Font("Synchro LET", 14);
	var bsize = 43;
	container[i] = ();
	container[i].view = CompositeView(win, (200@400));
	container[i].view.background_([Color.black, Color.white, Color.black, Color.white][i]);
	container[i].layout = container[i].view.addFlowLayout((5@5),(5@5));
	(numbufs/4).do{ |j|
		var current_buffer = (i * (numbufs/4) ) + j;
		var folder, name;
		// REC
		recorder_button[i][j] = Button(container[i].view, (bsize@bsize))
		.font_(font)
		.states_([
			["REC", Color.red, Color.white],
			["-", Color.white, Color.red]
		])
		.action_{ |v|
			("will record buffer: "++current_buffer).postln;
			Pbind(
				\instrument, \buf_recorder,
				\buf, Pseq([buffer[current_buffer]], 1)
			).play(quant:4);

			name = durations[i].asString ++ "_" ++ (j + 1).asString.split(separator: $.)[0].asString;
			folder = ("loop" ++ name).asString;

			unixCmd( "cd ~/tidal-samples/loops; mkdir -p %".format(folder) );

			AppClock.sched(
				(TempoClock.default.tempo * durations[i])
				+ ((TempoClock.default.nextBar - TempoClock.default.beats) * TempoClock.default.beatDur),
				{ v.value_(0);
					{
						buffer[current_buffer].write(
							"/home/gilfuser/tidal-samples/loops" +/+ folder +/+ name ++ ".wav",
							headerFormat: "WAV",
							sampleFormat: "int16"
						);
						"check it out!".postln;
						s.sync;
						~dirt.loadSoundFiles("~/tidal-samples/loops/%".format(folder) ); //.loadSoundFile(path, name, appendToExisting: false)
						// ~dirt.soundLibrary.addBuffer(\buffer, b1);  // TODO: substitute for that!!!!!!!!!!!!!!!!!!!!!!!
						s.sync;
						unixCmd( "cd ~/tidal-samples/loops; echo -n % > sample.txt; cat sample.txt| xclip -selection clipboard".format(folder) );
					}.fork;
				}
			);
		};

		// PLAY
		player_button[i][j] = Button(container[i].view, (bsize@bsize))
		.font_(font)
		.states_([
			["PLAY", Color.green, Color.white],
			["STOP", Color.black, Color.green(0.5)]
		])
		.action_{ |v|
			if (v.value.booleanValue) {
				("will play buffer: "++current_buffer).postln;
				buffer[current_buffer].postln;
				player[current_buffer] = Pbind(
					\instrument, \buf_player,
					\buf, buffer[current_buffer],
					\dur, durations[i],
					\out, 0 // 2 + (i * 2)
				).play(quant:4);
			} {
				("stopping buffer: "++current_buffer).postln;
				player[current_buffer].stop;
			}
		};
	};
};

StaticText(win, (800@100)).font_(font).string_("Record and play loops in different lengths as you wish.
If you change the tempo, be sure to hit 'refresh'
Have fun!!!");

// Players
metronome.player = Pbind(
	\instrument, \click,
	\freq, Pseq([1000, Pn(500,3)], inf),
	\amp, 0.2
);

metronome.display_player = Pbind(
	\type, \setProperties,
	\args, #[\background],
	\receiver, Pstutter(2, Pseq(metronome.display, inf)),
	\background, Pseq([Color.green, Color.red(0.25)], inf),
	\dur, Pseq([9,1]/10, inf),
).play(quant:4);

win.onClose_{
	metronome.display_player.stop;
	metronome.player_instance.stop;
	numbufs.do{ |i| buffer[i].free };
	// SystemClock.clear;
	// AppClock.clear;
	// t.clear;
};

s = Server.default;
s.waitForBoot {

	reload_func.value;

	SynthDef(\click, { |freq amp|
		var env = EnvGen.ar(Env.perc(0.001,0.05), levelScale:amp, doneAction:2);
		var snd = SinOsc.ar(freq, 0.5pi);
		snd = snd * env;
		OffsetOut.ar(click_out, snd!2);
	}).add;

	SynthDef(\buf_recorder, { |buf|
		RecordBuf.ar(InFeedback.ar(0, 2), buf, loop:0, doneAction:2)
	}).add;


	SynthDef(\buf_player, { |out, buf, rate=1, lag = 0 |
		var snd = PlayBuf.ar(2, buf, rate, loop:0, doneAction:2);
		OffsetOut.ar(out, snd!2)
	}).add;

};
