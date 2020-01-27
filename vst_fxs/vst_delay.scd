
/*
VSTPlugin.search(s, "~/.vst_linvst")
VSTPlugin.pluginKeys(s)
VSTPlugin.readPlugins.printAll
VSTPlugin.clear
*/
// VSTPlugin.plugins(s)['Calf Vintage Delay'].printPrograms;

Quarks.install("https://github.com/X2theL/CaesarLooper.git")

{
    ("\n loading VST Delay \n ").postln;
    q.busses0 = ~dirt.orbits.collect(_.dryBus) ++ 0;

	(
		SynthDef(\insertDelay, { | buz = 0 bpm = 110 ingain = 1 ms = 500 bypass = 0|
            var out = Select.kr(buz, q.busses0);
			ReplaceOut.ar(out, VSTPlugin.ar(.
				In.ar(out, ~dirt.numChannels), ~dirt.numChannels, bypass, [1, ingain, 16, bpm, 17, ms] )
			);
		}).add;
	);
    s.sync;
	0.2.wait;

	//-----------------------------------------------------------------------------
	(
		~delayO0 = VSTPluginController(
        Synth(\insertDelay, [ \buz, 0, \bpm, t.tempo*60 ], ~dirt.orbits[0].group, addAction: \addAfter)
    ).open( "Calf Vintage Delay", editor: false );
	);
	s.sync;
    0.2.wait;
	~delayO0.readProgram("/home/skmecs/vst/calf_delay.fxp");
	~delayO0.setTempo(bpm: t.tempo*30 );
    {~delayO0.gui}.defer;
    /*
    ~delayO0.close;
    ~delayO0.gui;
	~delayO0.info.parameters.printcsAll;
	*/
	~delayO0.synth.set('bpm', (t.tempo*60) );
	~delayO0.synth.set('ms', (1000) );
	~delayO0.synth.set('bypass', 1 );
	~delayO0.synth.set('Input Ga', 0.02)
" \n vst Delay loaded \n ".postln;
"\n VST FXs - LOADED \n ".postln;
}.fork;

