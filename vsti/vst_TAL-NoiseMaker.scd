{
	" \n loading vst instruments \n ".postln;
	(
		SynthDef(\vsti, { | buz |
			var out = Select.kr(buz, ~dirt.orbits.collect(_.dryBus));
			var sound = VSTPlugin.ar( nil, ~dirt.numChannels );
			OffsetOut.ar(out, sound);
		}).add;
	);

	0.2.wait;

	(
		~taln = VSTPluginController(
			Synth(\vsti, [\buz, 3])
		).open("TAL NoiseMaker Plugin", editor: true);
	);

	s.sync;
	0.2.wait;
	~dirt.soundLibrary.addMIDI(\taln, ~taln.midi);
	0.2.wait;
	// ~taln.readProgram("/home/skmecs/vst/modobass.fxp");
	0.2.wait;


	/*
	~taln.editor;
	~taln.close;
	~taln.gui;
	"\nMODO Bass loaded \n ".postln;
	0.2.wait;
	*/

	"TAL NoiseMaker - LOADED".postln;
}.fork;

VSTPlugin.readPlugins.printAll