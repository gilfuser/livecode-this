{
    ("\n loading VST Effects \n ").postln;
    q.busses0 = ~dirt.orbits.collect(_.dryBus) ++ 0;

	(
		SynthDef(\insertVst, { | buz = 0|
            var out = Select.kr(buz, q.busses0);
			ReplaceOut.ar(out, VSTPlugin.ar( In.ar(out, ~dirt.numChannels), ~dirt.numChannels ));
		}).add;
	);
    s.sync;
	0.2.wait;

	//-----------------------------------------------------------------------------
	(
		~verbOrb0 = VSTPluginController(
        Synth(\insertVst, [ \buz, 0 ], ~dirt.orbits[0].group, addAction: \addAfter)
    ).open( "Calf Reverb", editor: false );
	);
	s.sync;
    0.2.wait;
	// ~verbOrb0.readProgram("/home/skmecs/vst/orb0verb.fxp");
	" \n tal verb at orb 0 loaded \n ".postln;
	{ ~verbOrb0.gui }.defer;

    /*
    ~verbOrb0.close;
    ~verbOrb0.gui;
	~verbOrb0.close;
	~verbOrb0.info.parameters.printcsAll;
	*/
	" \n tal verb at orb 0 loaded  \n ".postln;

	(
		~verbOrb1 = VSTPluginController(
		Synth(\insertVst, [ \buz, 1 ], ~dirt.orbits[1].group, addAction: \addAfter)
	).open( "Calf Reverb", editor: false );
	);
	s.sync;
	0.2.wait;
	// ~verbOrb1.readProgram("/home/skmecs/vst/orb1verb.fxp");
	" \n tal verb at orb 1 loaded \n ".postln;
	{ ~verbOrb1.gui }.defer;
	/*
	~verbOrb1.gui;
	~verbOrb1.close;
	*/

	(
		~verbOrb2 = VSTPluginController(
		Synth(\insertVst, [ \buz, 2 ], ~dirt.orbits[2].group, addAction: \addAfter)
	).open( "Calf Reverb", editor: false );
	);
	s.sync;
	0.2.wait;
	// ~verbOrb2.readProgram("/home/skmecs/vst/orb2verb.fxp");
	" \n tal verb at orb 2 loaded \n ".postln;
	{ ~verbOrb2.gui }.defer;

	(
		~verbOrb3 = VSTPluginController(
			Synth(\insertVst, [ \buz, 3 ], ~dirt.orbits[3].group, addAction: \addAfter)
		).open( "Calf Reverb", editor: false );
	);
	s.sync;
	0.2.wait;
	// ~verbOrb3.readProgram("/home/skmecs/vst/orb3verb.fxp");
	" \n tal verb at orb 3 loaded \n ".postln;
	{ ~verbOrb3.gui }.defer;
	/*
    ~verbOrb3.editor;
    ~verbOrb3.close;
    */

" \n vst Reverbs loaded \n ".postln;
"\n VST FXs - LOADED \n ".postln;
}.fork;

