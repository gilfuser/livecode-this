{

	SynthDef(\insertVst, { | bus |
		ReplaceOut.ar(bus, VSTPlugin.ar( In.ar(bus, ~dirt.numChannels), ~dirt.numChannels ));
	}).add;

	SynthDef(\vst_verb, { | bus bypass = 0 vwet = 0.2 vdry = 1 delay = 0.1 vsize = 0.60 vlocut = 0.7 vhicut = 0.25 |
		ReplaceOut.ar( bus, VSTPlugin.ar( In.ar(bus, ~dirt.numChannels), ~dirt.numChannels, bypass,
			params: [1, vwet, 2, vdry, 3, delay, 4, vsize, 5, vlocut, 6, vhicut] )
		);
	}).add;

	0.1.wait;

	// Master Effect

	// add a group after default group
	~masterFxGroup = Group.after(1);
	0.1.wait;
	~molotcomp = VSTPluginController( Synth( \insertVst, [ \bus, 0 ], target: ~masterFxGroup , addAction: 'addToTail') );
	0.1.wait;
	~molotcomp.open( "/home/gilfuser/vst/Molot03-x64.so",  info: true, editor: true );
	8.wait;
	s.sync;
	/*
	~molotcomp.close
	*/
	s.sync;
	~molotcomp.editor;
	" \n molot loaded  \n".postln;
	0.1.wait;

	//-----------------------------------------------------------------------------

	// Orb 0 FX chain

	~eqOrb0 = VSTPluginController( Synth(\insertVst, [ \bus, q.orb0.dryBus ], q.orb0.group, addAction: \addAfter));
	0.1.wait;
	~eqOrb0.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, editor: true );
	10.wait;
	s.sync;
	/*
	~eqOrb0.writeProgram("/home/gilfuser/vst/orb0eq.fxp");
	*/
	~eqOrb0.readProgram("/home/gilfuser/vst/orb0eq.fxp");
	0.1.wait;
	s.sync;
	~eqOrb0.editor;
	" \n nova at orb 0 loaded \n".postln;
	/*
	~eqOrb0.close;
	*/

	~verbOrb0 = VSTPluginController( Synth(\vst_verb, [ \bus, q.orb0.dryBus ], ~eqOrb0.synth, addAction: \addAfter));
	0.1.wait;
	~verbOrb0.open( "/home/gilfuser/vst/talverb4/TAL-Reverb-4-64.so",  info: true, editor: true );
	2.wait;
	s.sync;
	~verbOrb0.readProgram("/home/gilfuser/vst/orb0verb.fxp");
	s.sync;
	~verbOrb0.editor;
	0.1.wait;

	// change the FX order dynamically, e.g. move '~fx2' before '~fx1':
	/*
	~fx2.synth.moveBefore(~fx1.synth);

	~fx1.synth.free; // remove from FX chain
	~fx2.synth.free; // remove from FX chain
	*/

	s.sync;
	" \n tal verb at orb 0 loaded  \n".postln;
	/*
	~verbOrb0.gui;
	~verbOrb0.info;
	~verbOrb0.close;
	~verbOrb0.free;
	*/

	~verbOrb1 = VSTPluginController( Synth(\vst_verb, [ \bus, q.orb1.dryBus ], q.orb1.group, addAction: \addAfter));
	0.1.wait;
	s.sync;
	~verbOrb1.open( "/home/gilfuser/vst/talverb4/TAL-Reverb-4-64.so",  info: true, editor: true );
	2.wait;
	~verbOrb1.readProgram("/home/gilfuser/vst/orb1verb.fxp");
	s.sync;
	~verbOrb1.editor;
	s.sync;
	" \n tal verb at orb 1 loaded \n ".postln;
	/*
	~verbOrb1.gui;
	~verbOrb1.close;
	*/
	0.1.wait;

	~eqOrb2 = VSTPluginController( Synth(\insertVst, [ \bus, q.orb2.dryBus ], q.orb2.group, addAction: \addAfter));
	0.1.wait;
	~eqOrb2.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, editor: true );
	1.wait;
	~eqOrb2.readProgram("/home/gilfuser/vst/orb2eq.fxp");
	s.sync;
	~eqOrb2.editor;
	"nova at orb 3 loaded".postln;
	/*
	~eqOrb2.close
	*/

	~verbOrb2 = VSTPluginController( Synth(\vst_verb, [ \bus, q.orb2.dryBus ], ~eqOrb2.synth, addAction: \addAfter));
	0.1.wait;
	~verbOrb2.open( "/home/gilfuser/vst/talverb4/TAL-Reverb-4-64.so",  info: true, editor: true );
	1.wait;
	~verbOrb2.readProgram("/home/gilfuser/vst/orb2verb.fxp");
	s.sync;
	~verbOrb2.editor;
	s.sync;
	" \n tal verb at orb 2 loaded \n".postln;
	/*
	~verbOrb2.gui;
	~verbOrb2.close;
	*/

	~verbOrb3 = VSTPluginController( Synth(\vst_verb, [ \bus, q.orb3.dryBus ], q.orb3.group, addAction: \addAfter));
	0.1.wait;
	~verbOrb3.open( "/home/gilfuser/vst/talverb4/TAL-Reverb-4-64.so",  info: true, editor: true );
	1.wait;
	~verbOrb3.readProgram("/home/gilfuser/vst/orb3verb.fxp");
	s.sync;
	~verbOrb3.editor;
	s.sync;
	" \n tal verb at orb 2 loaded \n ".postln;
	/*
	~verbOrb3.gui;
	~verbOrb3.close;
	*/

	/*
	SynthDef(\vst_instrument, { | out |
        OffsetOut.ar(out, VSTPlugin.ar( nil, ~dirt.numChannels ));
	}).add;
	*/


	SynthDef(\vst_tal, { | out bypass = 0 tvolume = 0.5 tcutoff = 1 lfo1rate = 0.5 |
		var lfo1r;
		lfo1r = (lfo1rate).explin(0.01, 514.22, 0, 1);
		OffsetOut.ar( out, VSTPlugin.ar( nil, ~dirt.numChannels, bypass,
			params: [ 1, tvolume, 3, tcutoff, 28, lfo1r ] )
		);
	}).add;
	0.1.wait;

	~talnoise = VSTPluginController( Synth(\vst_tal, [ \out, q.orb3.dryBus ]) );
	~talnoise.open( "/home/gilfuser/vst/TAL-noiseMaker/TAL-NoiseMaker-64.so",  info: true, editor: true );
	8.wait;

	~talnoise.editor;
	/*
	~talnoise.gui;
	~talnoise.info.printcsAll;
	~talnoise.close;
	*/

	// ~talnoise.synth.set(\lfo1rate, 100 )

	~dirt.soundLibrary.addMIDI(\talnoise, ~talnoise.midi);

		SynthDef(\vst_acid, { | out bypass = 0 acutoff = 1 areson = 0.5 asweept = 1 aenvmod = 1 aenvatt = 0 aenvdec = 0.5 aaccdec = 0.5 aenvacc = 0.5 |
		OffsetOut.ar(out, VSTPlugin.ar( nil, ~dirt.numChannels, bypass,
			params: [ 2, acutoff, 3, areson, 4, asweept, 5, aenvmod, 6, aenvatt, 7, aenvdec, 8, aaccdec, 9, aenvacc ] )
		);
	}).add;
	0.1.wait;

	~acid = VSTPluginController( Synth(\vst_acid, [ \out, q.orb2.dryBus ]) );
	0.1.wait;
	~acid.open( "/home/gilfuser/.wine/dosdevices/c:/users/gilfuser/Downloads/D16 Group 201805 NO INSTALL/C/Program Files/VstPlugins/D16 Group x64/Phoscyon x64.so",  info: true, editor: true );
	8.wait;

	~acid.readProgram("/home/gilfuser/vst/phosycon.fxp");
	~acid.editor;
	0.1.wait;

	~dirt.soundLibrary.addMIDI(\acid, ~acid.midi);
	/*
	~acid.gui;
	~acid.loaded;
	~acid.numParameters;
	~acid.close;
	~acid.info.printcsAll;
	*/
}.fork
