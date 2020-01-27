{
	" \n loading vst AudioBassLine 303 \n ".postln;
	(
		SynthDef(\vsti, { | buz |
			var out = Select.kr(buz, ~dirt.orbits.collect(_.dryBus));
			var sound = VSTPlugin.ar( nil, ~dirt.numChannels );
			OffsetOut.ar(out, sound);
		}).add;
	);

	0.2.wait;

	(
		~abl = VSTPluginController(
			Synth(\vsti, [\buz, 2] )
		).open( "ABL3", editor: true );
	);
	s.sync;
	0.2.wait;
	~abl.readProgram("/home/skmecs/vst/abl3.fxp");
	/*
	~abl.close;
	~abl.editor;
	~abl.gui;
	*/
	2.wait;
	~dirt.soundLibrary.addMIDI(\abl, ~abl.midi);
	0.2.wait;
	" \n AudioRealism Bass Line 303! loaded ".postln;
	"use 'abl' in Tidal \n ".postln;
}.fork;
// s.meter
// (
// SynthDef.new(\vsti, {arg out = 0;
//     // VST instruments usually donve inputs
//     Out.ar(out, VSTPlugin.ar(nil, 2));
// }).add;
// )
//
// // create Synth with VST instrument
// ~vsti = VSTPluginController(Synth(\vsti));
// // open plugin
// ~vsti.browse;
// ~vsti.editor
//
// // play the instrument with a \vst_midi Pbind
// (
// p = Pbind(
//     \type, \vst_midi,
//     \vst, ~vsti, // the VSTPluginController instance
//     \midicmd, \noteOn, // the default, can be omitted
//     \chan, 0, // MIDI channel (default: 0)
//     \midinote, Pseq([0, 2, 4, 7], inf) + Pwhite(-12, 12).stutter(Pwhite(4, 16)) + 60,
//     \dur, Prand([0.125, 0.25, 0.5], inf),
//     \legato, Pexprand(0.5, 1.0, inf),
//     \amp, Pexprand(0.5, 1.0, inf)
// ).play(quant: 1);
// )
//
// // change programs
// ~vsti.program_(1);
//
//     ~dirt.soundLibrary.addMIDI(\cheese, ~cheese.midi);
//
// p.stop
