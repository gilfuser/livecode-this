
/*VSTPlugin.search(s, "~/.vst_linvst")
VSTPlugin.clear*/

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

	// Master Effect
	// VSTPlugin.pluginKeys(s)
	// add a group after default group
	~masterFxGroup = Group.after(1);
    s.sync;
	0.1.wait;
    (
        ~comp = VSTPluginController(
            Synth( \insertVst,[ \buz, ( q.busses0.last ) ], target: ~masterFxGroup , addAction: 'addToTail')
        ).open( "Calf Compressor", editor: false );
    );
	s.sync;
    0.2.wait;
	/*
	~comp.info.parameters.do{|v|v.postln};
    ~comp.close;
	~comp.writeProgram("/home/skmecs/vst/calfcomp.fxp");
	~comp.gui;
	*/
    ~molotcomp.readProgram("/home/skmecs/vst/calfcomp.fxp");
	// s.sync;
	" \n molot loaded  \n ".postln;
	0.2.wait;

	//-----------------------------------------------------------------------------

	// Orb 0 FX chain
	(
		~eqOrb0 = VSTPluginController(
        Synth(\insertVst, [ \buz, 0 ], ~dirt.orbits[0].group, addAction: \addAfter)
    ).open( "TDR Nova", editor: true );
	);
	s.sync;
    0.2.wait;
	/*
	~eqOrb0.writeProgram("/home/gilfuser/vst/orb0eq.fxp");
	*/
	~eqOrb0.readProgram("/home/skmecs/vst/orb0eq.fxp");
	s.sync;
    0.2.wait;
	" \n nova at orb 0 loaded \n ".postln;
	/*
    ~eqOrb0.editor;
    ~eqOrb0.gui;
	~eqOrb0.close;
	*/

    0.2.wait;
	(
		~verbOrb0 = VSTPluginController(
        Synth(\insertVst, [ \buz, 0 ], ~eqOrb0.synth, addAction: \addAfter)
    ).open( "TAL Reverb 4 Plugin", editor: true );
	);
	s.sync;
    0.2.wait;
	~verbOrb0.readProgram("/home/skmecs/vst/orb0verb.fxp");
	s.sync;
	0.2.wait;

	// change the FX order dynamically, e.g. move '~fx2' before '~fx1':
    /*
    ~verbOrb0.editor;
    ~verbOrb0.gui;
	~verbOrb0.info.parameters.printcsAll;
	~fx2.synth.moveBefore(~fx1.synth);
	~fx1.synth.free; // remove from FX chain
	~fx2.synth.free; // remove from FX chain
	*/
	" \n tal verb at orb 0 loaded  \n ".postln;
	/*
	~verbOrb0.gui;
	~verbOrb0.info;
	~verbOrb0.close;
	*/
	(
		~verbOrb1 = VSTPluginController(
		Synth(\insertVst, [ \buz, 1 ], ~dirt.orbits[1].group, addAction: \addAfter)
	).open( "TAL Reverb 4 Plugin", editor: true );
	);
	s.sync;
	0.2.wait;
	~verbOrb1.readProgram("/home/skmecs/vst/orb1verb.fxp");
	s.sync;
	0.2.wait;
	" \n tal verb at orb 1 loaded \n ".postln;
	/*
    ~verbOrb1.editor;
	~verbOrb1.gui;
	~verbOrb1.close;
	*/
	(
		~eqOrb2 = VSTPluginController(
		Synth(\insertVst, [ \buz, 2 ], ~dirt.orbits[2].group, addAction: \addAfter)
	).open( "TDR Nova", editor: true );
	);
	s.sync;
	0.2.wait;
	~eqOrb2.readProgram("/home/skmecs/vst/orb2eq.fxp");
	s.sync;
	0.2.wait;
	" \n nova at orb 3 loaded \n ".postln;
	/*
    ~eqOrb2.editor;
	~eqOrb2.close
	*/
	(
		~verbOrb2 = VSTPluginController(
		Synth(\insertVst, [ \buz, 2 ], ~eqOrb2.synth, addAction: \addAfter)
	).open( "TAL Reverb 4 Plugin", editor: true );
	);
	s.sync;
	0.2.wait;
	~verbOrb2.readProgram("/home/skmecs/vst/orb2verb.fxp");
	s.sync;
	0.2.wait;
	" \n tal verb at orb 2 loaded \n ".postln;
	/*
    ~verbOrb2.editor;
	~verbOrb2.gui;
	~verbOrb2.close;
	*/
	(
		~verbOrb3 = VSTPluginController(
			Synth(\insertVst, [ \buz, 3 ], ~dirt.orbits[3].group, addAction: \addAfter)
		).open( "TAL Reverb 4 Plugin", editor: true );
	);
	s.sync;
	0.2.wait;
	~verbOrb3.readProgram("/home/skmecs/vst/orb3verb.fxp");
	/*
    ~verbOrb3.editor;
    ~verbOrb3.close;
    */
" \n tal verb at orb 3 loaded \n ".postln;
"\n VST FXs - LOADED \n ".postln;
}.fork;

