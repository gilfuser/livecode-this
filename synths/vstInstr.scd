{
    " \n loading vst instruments \n ".postln;
	(
		SynthDef(\vsti, { | out buz |
            var orb = Select.kr(buz, q.dryBusses);
	        var sound = VSTPlugin.ar( nil, ~dirt.numChannels );
			OffsetOut.ar(orb, sound);
		}).add;
	);

	0.1.wait;

    (
        ~bass = VSTPluginController(
            Synth(\vsti, [\buz, 4])
        ).open("MODO BASS", editor: true);
    );
	s.sync;
	0.1.wait;
	~dirt.soundLibrary.addMIDI(\modo, ~bass.midi);
	0.1.wait;
	~bass.readProgram("/home/gilfuser/vst/modobass.fxp");
    0.1.wait;
    /*
    ~bass.editor;
    ~bass.close
    ~bass.gui
    */
    " \n MODO Bass loaded \n ".postln;

    (
        ~talnoise = VSTPluginController(
            Synth(\vsti, [\buz, 3])
        ).open( "TAL-NoiseMaker-64", editor: true );
    );
	s.sync;
	0.1.wait;
	/*
    ~talnoise.editor;
	~talnoise.gui;
	~talnoise.info.parameters.do{|v|v.postln};
	~talnoise.close;
	*/
	~dirt.soundLibrary.addMIDI(\talnoise, ~talnoise.midi);
	0.1.wait;
    " \n TAL-NoiseMaker loaded \n ".postln;

    (
        ~acid = VSTPluginController(
            Synth(\vsti, [\buz, 2] )
        ).open( "Phoscyon x64", editor: true );
    );
	s.sync;
	/*
	~acid.readProgram("/home/gilfuser/vst/phosycon.fxp");
	~acid.close;
    ~acid.editor;
	*/
	0.1.wait;
	~dirt.soundLibrary.addMIDI(\acid, ~acid.midi);
    " \n Phoscyon Acid! loaded \n ".postln;
	/*
	Pdef(\test,
	Pbind(
	\type, \midi,
	\midiout, ~bass.midi, // set the midi target
	\chan, 0,
	\degree, Pwhite(0, 12, inf),
	\dur, Prand(#[0.125, 0.25, 0.5, 1], inf),
	\legato, Pexprand(0.5, 1.0, inf),
	\amp, Pexprand(0.5, 1.0, inf),
	\out, 0
	)
	);
	Pdef(\test).gui;
	*/
}.fork
