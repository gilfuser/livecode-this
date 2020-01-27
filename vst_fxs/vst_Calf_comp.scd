
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
        ~calfcomp = VSTPluginController(
            Synth( \insertVst,[ \buz, ( q.busses0.last ) ], target: ~masterFxGroup , addAction: 'addToTail')
        ).open( "Calf Compressor", editor: true );
    );
	s.sync;
    0.2.wait;
	/*
	~calfcomp.info.parameters.do{|v|v.postln};
    ~calfcomp.close;
	~calfcomp.writeProgram("/home/skmecs/vst/calf.fxp");
    ~calfcomp.editor;
	~calfcomp.gui;
	*/
    ~calfcomp.readProgram("/home/skmecs/vst/calf.fxp");
	// s.sync;
	" \n calf loaded  \n ".postln;
}.fork;

