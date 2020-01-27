
/*VSTPlugin.search(s, "~/.vst_linvst")
VSTPlugin.clear*/

{
    ("\n loading VST Effects \n ").postln;
    q.busses0 = ~dirt.orbits.collect(_.dryBus) ++ 0;

	(
		SynthDef(\insertVst, { | buz = 0|
            var out = Select.kr( buz, q.busses0 );
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
        ~molotcomp = VSTPluginController(
            Synth( \insertVst,[ \buz, ( q.busses0.last ) ], target: ~masterFxGroup , addAction: 'addToTail')
        ).open( "Molot", editor: true );
    );
	s.sync;
    0.2.wait;
	/*
	~molotcomp.info.parameters.do{|v|v.postln};
    ~molotcomp.close;
	~molotcomp.writeProgram("/home/skmecs/vst/molot.fxp");
    ~molotcomp.editor;
	~molotcomp.gui;
	*/
    ~molotcomp.readProgram("/home/skmecs/vst/molot.fxp");
	// s.sync;
	" \n molot loaded  \n ".postln;
}.fork;

