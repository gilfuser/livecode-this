{
	~vwet = Bus.control(s, 4);
	~vdry = Bus.control(s, 4);
	~vdelay = Bus.control(s, 4);
	~vsize = Bus.control(s, 4);
	~vlocut = Bus.control(s, 4);
	~vhicut = Bus.control(s, 4);

	~vwet.setn([0.2, 0.2, 0.3, 0.2]);
	~vdry.setn(1!4);
	~vdelay.setn([0.1, 0.1, 0.125, 0.15]);
	~vsize.setn(0.60!4);
	~vlocut.setn([0.7, 0.7, 0.64, 0.64]);
	~vhicut.setn([0.25, 0.25, 0.125, 0.125]);

	(
		SynthDef(\masterFX, { | in out bypass = 0 |
			ReplaceOut.ar(out, VSTPlugin.ar( In.ar(in, ~dirt.numChannels), ~dirt.numChannels, bypass ));
		}).add;

		SynthDef.new(\vst_insert, { | in out bypass=0 |
			ReplaceOut.ar(out, VSTPlugin.ar( In.ar(in, ~dirt.numChannels), ~dirt.numChannels, bypass ));
		}).add;
	);

	0.1.wait;
	~masterFxGroup = Group.after(1); // after default group
	0.1.wait;
	~molotcomp = VstPluginController( Synth( \masterFX, [ \in, 0, \out, 0 ], target: ~masterFxGroup , addAction: 'addToTail') );
	0.1.wait;
	~molotcomp.open( "/home/gilfuser/vst/Molot03-x64.so",  info: true, editor: true );
	10.wait;
	s.sync;
	~molotcomp.readProgram("/home/gilfuser/vst/molot.fxp");
	/*
	~molotcomp.close
	*/
	s.sync;
	~molotcomp.editor;
	" \n molot loaded  \n".postln;

	~fxGroupO0 = Group.after(1);
	0.1.wait;

	~eqOrb0 = VstPluginController( Synth(\vst_insert, [ \in, 2, \out, 2 ], ~fxGroupO0, addAction: \addToTail));
	0.1.wait;
	~eqOrb0.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, editor: true );
	10.wait;
	s.sync;
	~eqOrb0.readProgram("/home/gilfuser/vst/orb0eqPedras.fxp");
	0.1.wait;
	s.sync;
	~eqOrb0.editor;
	" \n nova at orb 0 loaded \n".postln;

	~verbOrb0 = VstPluginController( Synth(\vst_insert, [ \in, 2, \out, 2 ], ~fxGroupO0, addAction: \addToTail));
	0.1.wait;
	~verbOrb0.open( "/home/gilfuser/vst/talverb4/TAL-Reverb-4-64.so",  info: true, editor: true );
	2.wait;
	s.sync;
	~verbOrb0.readProgram("/home/gilfuser/vst/orb0verb.fxp");
	s.sync;
	~verbOrb0.editor;
	0.1.wait;

	s.sync;

	~verbOrb0.map(1, ~vwet.subBus(0));
	~verbOrb0.map(2, ~vdry.subBus(0));
	~verbOrb0.map(3, ~vdelay.subBus(0));
	~verbOrb0.map(4, ~vsize.subBus(0));
	~verbOrb0.map(5, ~vlocut.subBus(0));
	~verbOrb0.map(6, ~vhicut.subBus(0));
	" \n tal verb at orb 0 loaded  \n".postln;
	/*
	~verbOrb0.close;
	~verbOrb0.free;
	~verbOrb0.info;
	*/

	~fxGroupOrb1 = Group.after(1);
	0.1.wait;
	s.sync;
	/*

	~eqOrb1 = VstPluginController( Synth(\vst_insert, [ \in, 4, \out, 4 ], ~fxGroupOrb1, addAction: \addToTail));
	0.1.wait;
	~eqOrb1.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, gui: \vst );
	2.wait;
	~eqOrb1.readProgram("/home/gilfuser/vst/orb1eqPedras.fxp");
	s.sync;
	~eqOrb1.showGui;
	" \n nova at orb 1 loaded \n ".postln;
	~verbOrb1.close
	*/

	~verbOrb1 = VstPluginController( Synth(\vst_insert, [ \in, 4, \out, 4 ], ~fxGroupOrb1, addAction: \addToTail));
	0.1.wait;
	s.sync;
	~verbOrb1.open( "/home/gilfuser/vst/talverb4/TAL-Reverb-4-64.so",  info: true, editor: true );
	2.wait;
	~verbOrb1.readProgram("/home/gilfuser/vst/orb1verb.fxp");
	s.sync;
	~verbOrb1.editor;
	s.sync;
	~verbOrb1.map(1, ~vwet.subBus(1));
	~verbOrb1.map(2, ~vdry.subBus(1));
	~verbOrb1.map(3, ~vdelay.subBus(1));
	~verbOrb1.map(4, ~vsize.subBus(1));
	~verbOrb1.map(5, ~vlocut.subBus(1));
	~verbOrb1.map(6, ~vhicut.subBus(1));
	" \n tal verb at orb 1 loaded \n ".postln;
	/*
	~verbOrb1.close;
	*/

	~fxGroupOrb2 = Group.after(1);
	0.1.wait;
	s.sync;

	~eqOrb2 = VstPluginController( Synth(\vst_insert, [ \in, 6, \out, 6 ], ~fxGroupOrb2, addAction: \addToTail));
	0.1.wait;
	~eqOrb2.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, editor: true );
	1.wait;
	~eqOrb2.readProgram("/home/gilfuser/vst/orb2eqPedras.fxp");
	s.sync;
	~eqOrb2.editor;
	"nova at orb 3 loaded".postln;
	/*
	~eqOrb2.close
	*/

	~verbOrb2 = VstPluginController( Synth(\vst_insert, [ \in, 6, \out, 6 ], ~fxGroupOrb2, addAction: \addToTail));
	0.1.wait;
	~verbOrb2.open( "/home/gilfuser/vst/talverb4/TAL-Reverb-4-64.so",  info: true, editor: true );
	1.wait;
	~verbOrb2.readProgram("/home/gilfuser/vst/orb2verb.fxp");
	s.sync;
	~verbOrb2.editor;
	s.sync;
	~verbOrb2.map(1, ~vwet.subBus(2));
	~verbOrb2.map( 2, ~vdry.subBus(2));
	~verbOrb2.map(3, ~vdelay.subBus(2));
	~verbOrb2.map(4, ~vsize.subBus(2));
	~verbOrb2.map(5, ~vlocut.subBus(2));
	~verbOrb2.map(6, ~vhicut.subBus(2));
	" \n tal verb at orb 2 loaded \n".postln;
	/*
	~verbOrb2.close;
	*/

	~fxGroupOrb3 = Group.after(1);
	0.1.wait;
	s.sync;

	/*~eqOrb3 = VstPluginController( Synth(\vst_insert, [ \in, 8, \out, 8 ], ~fxGroupOrb3, addAction: \addToTail));
	0.1.wait;
	~eqOrb3.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, gui: \vst );
	1.wait;
	~eqOrb3.readProgram("/home/gilfuser/vst/orb3eqPedras.fxp");
	s.sync;
	~eqOrb3.showGui;
	"nova at orb 3 loaded".postln;
	~verbOrb3.close
	*/

	~verbOrb3 = VstPluginController( Synth(\vst_insert, [ \in, 8, \out, 8 ], ~fxGroupOrb3, addAction: \addToTail));
	0.1.wait;
	~verbOrb3.open( "/home/gilfuser/vst/talverb4/TAL-Reverb-4-64.so",  info: true, editor: true );
	1.wait;
	~verbOrb3.readProgram("/home/gilfuser/vst/orb3verb.fxp");
	s.sync;
	~verbOrb3.editor;
	s.sync;
	~verbOrb3.map( 1, ~vwet.subBus(3) );
	~verbOrb3.map( 2, ~vdry.subBus(3) );
	~verbOrb3.map( 3, ~vdelay.subBus(3) );
	~verbOrb3.map( 4, ~vsize.subBus(3) );
	~verbOrb3.map(5, ~vlocut.subBus(3));
	~verbOrb3.map(6, ~vhicut.subBus(3));
	" \n tal verb at orb 2 loaded \n ".postln;
	/*
	~verbOrb3.close;
	*/

	(
		SynthDef(\vst_istrument, {arg out;
			OffsetOut.ar(out, VstPlugin.ar(nil, ~dirt.numChannels));
		}).add;
	);
	0.1.wait;
	/*~talnoise = VstPluginController( Synth(\vst_istrument) );
	~talnoise.open( "/home/gilfuser/vst/TAL-noiseMaker/TAL-NoiseMaker-64.so",  info: true, editor: true );
	~talnoise.editor;*/

	// "/home/gilfuser/.wine/drive_c/Program Files/VstPlugins/AudioRealism/ABL3/ABL3(x64).so"

	~acid = VstPluginController( Synth(\vst_istrument, [\out, Ndef(\orb3).bus]) );
	0.1.wait;
	~acid.open( "/home/gilfuser/.wine/dosdevices/c:/users/gilfuser/Downloads/D16 Group 201805 NO INSTALL/C/Program Files/VstPlugins/D16 Group x64/Phoscyon x64.so",  info: true, editor: true );
	10.wait;
	~acid.readProgram("/home/gilfuser/vst/phosycon.fxp");
	~acid.editor;
	/*
	~acid.gui;
	~acid.loaded;
	~acid.numParameters;
	~acid.close;
	~acid.info.printAll;
	~acid.currentProgram
	~acid.numParameters
	*/
	~acid.setTempo(110);
	0.1.wait;
	~dirt.soundLibrary.addMIDI(\acid, ~acid.midi);
}.fork

/* 'p1' controls the plugin parameter 1. 'p2' controls a parameter whose index can be set dynamically with 'idx'. */
// having one Synth per VstPlugin has the advantage that you can change the FX order on the fly with .moveAfter / .moveBefore.