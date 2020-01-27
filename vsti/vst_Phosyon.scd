{
	" \n loading vst Phoscyon \n ".postln;
	(
		SynthDef(\vsti, { | buz |
			var out = Select.kr(buz, ~dirt.orbits.collect(_.dryBus));
			var sound = VSTPlugin.ar( nil, ~dirt.numChannels );
			OffsetOut.ar(out, sound);
		}).add;
	);

	0.2.wait;

	(
		~pho = VSTPluginController(
			Synth(\vsti, [\buz, 2] )
		).open( "Phoscyon", editor: true );
	);
	s.sync;
	0.2.wait;
	~pho.readProgram("/home/skmecs/vst/phosycon.fxp");
	/*
	~pho.close;
	~pho.editor;
	~acid.gui;
	*/
	2.wait;
	~dirt.soundLibrary.addMIDI(\pho, ~pho.midi);
	0.2.wait;
	" \n Phoscyon 303! loaded ".postln;
	"use 'pho' in Tidal \n ".postln;
}.fork;

