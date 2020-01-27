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
		~modo = VSTPluginController(
			Synth(\vsti, [\buz, 3])
		).open("MODO BASS", editor: true);
	);
	s.sync;
	0.2.wait;
	~dirt.soundLibrary.addMIDI(\modo, ~modo.midi);
	0.2.wait;
	~modo.readProgram("/home/skmecs/vst/modobass.fxp");
	0.2.wait;


	/*
	~modo.editor;
	~modo.close;
	~modo.gui;
	" \n MODO Bass loaded \n ".postln;
	0.2.wait;
	*/

	"Modo Bass - LOADED".postln;
}.fork;

