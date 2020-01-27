{
	" \n loading vsti Cheese \n ".postln;
	(
		SynthDef(\vsti, { | buz |
			var out = Select.kr(buz, ~dirt.orbits.collect(_.dryBus));
			var sound = VSTPlugin.ar( nil, ~dirt.numChannels );
			OffsetOut.ar(out, sound);
		}).add;
	);

	0.2.wait;

	(
		~cheese = VSTPluginController(
			Synth(\vsti, [\buz, 0])
		).open("TripleCheese.vst3", editor: true);
	);
	s.sync;
	0.2.wait;

	~dirt.soundLibrary.addMIDI(\cheese, ~cheese.midi);
	~cheese.setTempo( bpm: t.tempo * 60 * 4 );
	~cheese.readProgram("/home/skmecs/vst/cheese.fxp");

	/*
	~cheese.editor;
	~cheese.close;
	~cheese.gui;
	0.2.wait;
	*/

	" \n Triple Cheese - LOADED \n use 'cheese' in Tidal ".postln;
}.fork;

