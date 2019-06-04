(
q = q ? ();
s.waitForBoot(
	{
		q = q ? ();
		if(p == Ndef.dictFor(s) ) {p=nil} {p = Ndef.dictFor(s).quant_(4)};
		0.1.wait;
		~dirt.stop;
		0.1.wait;
		~dirt.free;
		0.1.wait;
		~dirt = SuperDirt(2, s);
		s.sync;
		~dirt.start(57120, ([2, 4, 6, 8]));
		s.sync;
		0.1.wait;
		~dirt.loadSoundFiles;
		// ~dirt.loadSoundFiles("~/tidal-samples/*/*" );
		0.1.wait;

		q.orb0 = ~dirt.orbits[0];
		q.orb1 = ~dirt.orbits[1];
		q.orb2 = ~dirt.orbits[2];
		q.orb3 = ~dirt.orbits[3];

		0.1.wait;
		Ndef(\orb0).ar(~dirt.numChannels);
		Ndef(\orb1).ar(~dirt.numChannels);
		Ndef(\orb2).ar(~dirt.numChannels);
		Ndef(\orb3).ar(~dirt.numChannels);

		0.1.wait;
		Ndef(\orb0).proxyspace.quant_(p.quant);
		Ndef(\orb1).proxyspace.quant_(p.quant);
		Ndef(\orb2).proxyspace.quant_(p.quant);
		Ndef(\orb3).proxyspace.quant_(p.quant);
		0.1.wait;
		q.orb0.outBus = Ndef(\orb0).bus;
		q.orb1.outBus = Ndef(\orb1).bus;
		q.orb2.outBus = Ndef(\orb2).bus;
		q.orb3.outBus = Ndef(\orb3).bus;
		0.1.wait;

		Ndef(\orb0).play(2);
		Ndef(\orb1).play(4);
		Ndef(\orb2).play(6);
		Ndef(\orb3).play(8);

		1.wait;

		~dirt.loadSynthDefs("../synths/tidalInstruments*");

		1.wait;
		(
			~dirt.addModule('saturator', { |dirtEvent|
				dirtEvent.sendSynth('saturator' ++ ~dirt.numChannels,
				);
			}, { ~sind.notNil or: { ~satur.notNil } }); // play synth only if at least one of the two was given
		);
		(
			SynthDef( "saturator" ++ ~dirt.numChannels, { | out sind = 4 smul = 0.25 satur = 1 sustain |
				var signal, saturated, drywet;
				signal = In.ar(out, ~dirt.numChannels);
				saturated = AudioMSG.ar( signal, sind, mul:smul);
				drywet = XFade2.ar(signal, saturated, satur * 2 - 1);
				ReplaceOut.ar(out, drywet)
			}).add;
		);

		Ndef(\allOrbs, {
			var in = [ InFeedback.ar( [2, 4, 6, 8] ,1), InFeedback.ar( [3, 5, 7, 9] ,1) ];
			OffsetOut.ar(0, in)
		}).play;

		"super-dirt prepared".postln;
		0.1.wait;

		/////////////////////////////////////////////////////////////////////////////////

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
		/*
		~molotcomp.close;
		*/

		SynthDef(\masterFX, { | in out bypass = 0 |
			ReplaceOut.ar(out, VSTPlugin.ar( In.ar(in, ~dirt.numChannels), ~dirt.numChannels, bypass ));
		}).add;

		SynthDef.new(\vst_insert, { | in out bypass=0 |
			ReplaceOut.ar(out, VSTPlugin.ar( In.ar(in, ~dirt.numChannels), ~dirt.numChannels, bypass ));
		}).add;

		0.1.wait;
		~masterFxGroup = Group.after(1); // after default group
		0.1.wait;
		~molotcomp = VSTPluginController( Synth( \masterFX, [ \in, 0, \out, 0 ], target: ~masterFxGroup , addAction: 'addToTail') );
		0.1.wait;
		~molotcomp.open( "/home/gilfuser/vst/Molot03-x64.so",  info: true, editor: true );
		13.wait;
		s.sync;
		~molotcomp.readProgram("/home/gilfuser/vst/molot.fxp");
		/*~molotcomp.open( "/home/gilfuser/vst/Molot03-x64.so",  info: true, gui: \vst );
		2.wait;
		~molotcomp.close
		*/
		s.sync;
		~molotcomp.editor;
		" \n molot loaded  \n".postln;


		/*	~fxGroupEqHi = Group.after(1);
		0.1.wait;

		~eqHi = VSTPluginController( Synth(\vst_insert, [ \in, [4,6], \out, [4,6] ], ~fxGroupEqHi, addAction: \addToTail));
		0.1.wait;
		~eqHi.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, gui: \vst );
		2.wait;
		s.sync;
		~eqHi.readProgram("/home/gilfuser/vst/orb2eqPedras.fxp");
		s.sync;
		~eqHi.showGui;
		" \n nova at orb 2 loaded  \n".postln;
		~eqHi.close
		~eqOrb0.close;
		*/

		~fxGroupO0 = Group.after(1); // after default group
		0.1.wait;

		~eqOrb0 = VSTPluginController( Synth(\vst_insert, [ \in, 2, \out, 2 ], ~fxGroupO0, addAction: \addToTail));
		0.1.wait;
		~eqOrb0.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, editor: true );
		12.wait;
		s.sync;
		~eqOrb0.readProgram("/home/gilfuser/vst/orb0eqPedras.fxp");
		0.1.wait;
		s.sync;
		~eqOrb0.editor;
		" \n nova at orb 0 loaded \n".postln;

		~verbOrb0 = VSTPluginController( Synth(\vst_insert, [ \in, 2, \out, 2 ], ~fxGroupO0, addAction: \addToTail));
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
		// ~verbOrb0.info;
		s.sync;
		*/

		~fxGroupOrb1 = Group.after(1);
		0.1.wait;
		s.sync;
		/*

		~eqOrb1 = VSTPluginController( Synth(\vst_insert, [ \in, 4, \out, 4 ], ~fxGroupOrb1, addAction: \addToTail));
		0.1.wait;
		~eqOrb1.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, gui: \vst );
		2.wait;
		~eqOrb1.readProgram("/home/gilfuser/vst/orb1eqPedras.fxp");
		s.sync;
		~eqOrb1.showGui;
		" \n nova at orb 1 loaded \n ".postln;
		~verbOrb1.close
		*/

		~verbOrb1 = VSTPluginController( Synth(\vst_insert, [ \in, 4, \out, 4 ], ~fxGroupOrb1, addAction: \addToTail));
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
		~verbOrb2.close
		*/

		~fxGroupOrb2 = Group.after(1);
		0.1.wait;
		s.sync;

		~eqOrb2 = VSTPluginController( Synth(\vst_insert, [ \in, 6, \out, 6 ], ~fxGroupOrb2, addAction: \addToTail));
		0.1.wait;
		~eqOrb2.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, editor: true );
		1.wait;
		~eqOrb2.readProgram("/home/gilfuser/vst/orb2eqPedras.fxp");
		s.sync;
		~eqOrb2.editor;
		"nova at orb 3 loaded".postln;
		/*
		~verbOrb2.close
		*/

		~verbOrb2 = VSTPluginController( Synth(\vst_insert, [ \in, 6, \out, 6 ], ~fxGroupOrb2, addAction: \addToTail));
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

		/*~eqOrb3 = VSTPluginController( Synth(\vst_insert, [ \in, 8, \out, 8 ], ~fxGroupOrb3, addAction: \addToTail));
		0.1.wait;
		~eqOrb3.open( "/home/gilfuser/.wine/drive_c/Program Files/Steinberg/VSTPlugins/TDR Nova.so",  info: true, gui: \vst );
		1.wait;
		~eqOrb3.readProgram("/home/gilfuser/vst/orb3eqPedras.fxp");
		s.sync;
		~eqOrb3.showGui;
		"nova at orb 3 loaded".postln;
		~verbOrb3.close
		*/

		~verbOrb3 = VSTPluginController( Synth(\vst_insert, [ \in, 8, \out, 8 ], ~fxGroupOrb3, addAction: \addToTail));
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
				OffsetOut.ar(out, VSTPlugin.ar(nil, ~dirt.numChannels));
			}).add;
		);
		0.1.wait;
		/*~talnoise = VSTPluginController( Synth(\vst_istrument) );
		~talnoise.open( "/home/gilfuser/vst/TAL-noiseMaker/TAL-NoiseMaker-64.so",  info: true, editor: true );
		~talnoise.editor;*/

		// "/home/gilfuser/.wine/drive_c/Program Files/VstPlugins/AudioRealism/ABL3/ABL3(x64).so"

		~acid = VSTPluginController( Synth(\vst_istrument, [\out, Ndef(\orb3).bus]) );
		0.1.wait;
		~acid.open( "/home/gilfuser/.wine/dosdevices/c:/users/gilfuser/Downloads/D16 Group 201805 NO INSTALL/C/Program Files/VstPlugins/D16 Group x64/Phoscyon x64.so",  info: true, editor: true );
		10.wait;
		/*
		~acid.gui;
		*/
		~acid.readProgram("/home/gilfuser/vst/phosycon.fxp");
		~acid.editor;
		~acid.setTempo(90);
		0.1.wait;
		~dirt.soundLibrary.addMIDI(\acid, ~acid.midi);

		///////////////////////////////////////////////////////////////////////////////////

		q=q ? ();
		q.fx = q.fx ? ();
		q.views = q.views ? ();

		// for pitch:
		{(
			Pdefn(\scaleA, Scale.choose(7, 12).tuning_(Tuning.choose(12)));
			Pdefn(\scaleA).source.name;
			Pdefn(\scaleA).source.tuning;
			q.deltas = Bus.control(s, 4).setn(1!4);
			q.busses = ~dirt.orbits.collect { |x| x.outBus };
			s.sync;
		);
		}.fork;

		(
			q.fx.fxLib = IdentityDictionary [

				'00_in' -> { arg in, level=0.85, llag=0.2;
					LeakDC.ar( in * level.lag(llag) )
					+ (BrownNoise.ar(0.000001) ! 2/*q.numChans*/);
				},

				'pitch' -> { | in /*scl*/ pideg = 0 pdisp = 0.05 tdisp = 0.2 slide = 0.4 |
					var wSize, timeDisp, pitchRatio;
					// scl = Scale.choose(7, 12).tuning_(Tuning.choose(12));
					var scl = { Pdefn(\scaleA).source }.value;
					pitchRatio = Select.kr( pideg + 14, [
						scl.degreeToRatio(-14, 0).lag(slide), scl.degreeToRatio(-13, 0).lag(slide), scl.degreeToRatio(-12, 0).lag(slide), scl.degreeToRatio(-11, 0).lag(slide), scl.degreeToRatio(-10, 0).lag(slide), scl.degreeToRatio(-9, 0).lag(slide), scl.degreeToRatio(-8, 0).lag(slide), scl.degreeToRatio(-7, 0).lag(slide), scl.degreeToRatio(-6, 0).lag(slide), scl.degreeToRatio(-5, 0).lag(slide), scl.degreeToRatio(-4, 0).lag(slide), scl.degreeToRatio(-3, 0).lag(slide), scl.degreeToRatio(-2, 0).lag(slide), scl.degreeToRatio(-1, 0).lag(slide), scl.degreeToRatio(0, 0).lag(slide), scl.degreeToRatio(1, 0).lag(slide), scl.degreeToRatio(2, 0).lag(slide), scl.degreeToRatio(3, 0).lag(slide), scl.degreeToRatio(4, 0).lag(slide), scl.degreeToRatio(5, 0).lag(slide), scl.degreeToRatio(6, 0).lag(slide), scl.degreeToRatio(7, 0).lag(slide), scl.degreeToRatio(8, 0).lag(slide), scl.degreeToRatio(9, 0).lag(slide), scl.degreeToRatio(10, 0).lag(slide), scl.degreeToRatio(11, 0).lag(slide), scl.degreeToRatio(12, 0).lag(slide), scl.degreeToRatio(13, 0).lag(slide), scl.degreeToRatio(14, 0).lag(slide)
					]
					);
					wSize =  0.15;
					timeDisp = LFDNoise3.ar( 0.0626).range(0, wSize) * tdisp;
					PitchShift.ar( in, wSize, pitchRatio, pdisp, timeDisp );
				},

				'tape' -> { |in /*tempo */ trate=1 tphase=1.5 tdepth = 1 toffset = 1 |
					var curve = SinOsc.ar(( trate * {TempoClock.default.tempo})/*.reciprocal.lag(0.2)*/, ( /*trate **/ tphase.lag(0.1) * 2pi + 1.5pi) % 2pi, tdepth, toffset.lag(0.1) );
					DelayC.ar(in, 2, curve/*, in*/);
				},

				// Greyhole is beautifull but too CPU expensive
				/*
				'hole' -> {  | in , hrate = 0.1, damp = 0.1, hsize = 1, hdif = 0.707, hfb = 0.1, cps /*, hhpf, hlpf*/ |
				var delayTime = (hrate * {TempoClock.default.tempo}).reciprocal.lag(0.2);
				Greyhole.ar( in, delayTime, damp, hsize.lag(0.2), hdif, hfb, modDepth: 0.2 );
				},
				*/

				// needs some love too. duck is a reference
				'llfo' -> { | in  sisap=0/*tempo */ lrate=1 iphase=0 lwidth=0.5, midfreq=60 , hifreq=20000 |
					var tempo = (lrate * {TempoClock.default.tempo}).reciprocal.lag(0.2);
					var mod = Select.ar(sisap, [
						SinOsc.ar( tempo, ( /*lrate * */iphase * 2pi + 1.5pi) % 2pi),
						LFSaw.ar( tempo, iphase % 2, lwidth ), // change to LFTri
						LFPulse.ar(tempo, (lrate * iphase) % 1, lwidth.clip(0.02, 0.998) )*2-1,
					]);
					BLowPass.ar(in, mod.lag2(0.05).exprange(midfreq.lag(0.1), hifreq.lag(0.1)));
				},

				'wah' -> { |in wrate = 1 depth = 0.5 sinsaw = 0 /*wphase = 0 */jfreq = 1 jdepth = 0 |
					var  wring = 0.002, wrq = 0.8,  ggain = 1 ;
					var jitter = LFNoise2.ar(jfreq, jdepth);
					var mod = Select.kr(sinsaw, [
						SinOsc.ar( wrate, ( jitter * 2pi) % 2pi, depth).exprange(100, 5000),
						VarSaw.kr(wrate, jitter, 0.1, depth).lag(0.1).exprange(100, 5000),
					]);
					var ringz = Ringz.ar( in, mod, wring );
					var sig = RLPF.ar(ringz, mod, wrq.lag(0.1)) * ggain.tanh.lag(0.0003) / ggain.sqrt;
					Limiter.ar(sig, 0.9);
				},

				'comp' -> { | in cctrl = 0 thresh = 0.25 slopea = 0.5 clamp = 0.001 relax = 0.1 deltas = 0 |
					var deltaSel = Select.kr(deltas, q.deltas);
					var bus = Select.kr(cctrl, q.busses);
					var comp = Compander.ar( in, In.ar( bus, ~dirt.numChannels), thresh.linexp(0, 1, 0.001, 1), 1, slopea, clamp, relax * deltas );
					Limiter.ar( comp );
				},

				'ampFin' -> { |in, limDrive = 1.25, ampLimit = 0.95, postAmp = 1 |
					Limiter.ar(in * limDrive, ampLimit) * postAmp;
				},
			];
		);


		(
			Spec.add( \wet10, [0.0, 1.0]);
			Spec.add( \wet20, [0.0, 1.0]);
			Spec.add( \wet30, [0.0, 1.0]);
			Spec.add( \wet40, [0.0, 1.0]);
			Spec.add( \wet50, [0.0, 1.0]);
			Spec.add( \wet60, [0.0, 1.0]);
			Spec.add( \wet70, [0.0, 1.0]);
			Spec.add( \wet80, [0.0, 1.0]);
			Spec.add( \wet90, [0.0, 1.0]);
			Spec.add( \wet100, [0.0, 1.0]);
			Spec.add( \wet110, [0.0, 1.0]);
			Spec.add( \wet120, [0.0, 1.0]);

			// comp
			Spec.add(\cctrl, [0, 3, \lin, 1, 1]);
			Spec.add(\thresh, [-60.dbamp, 1, \amp]);
			// Spec.add(\slopeb, [0.5, 4]);
			Spec.add(\slopea, [0.05, 1]);
			Spec.add(\clamp, [0.001, 0.4]);
			Spec.add(\relax, [0.1, 1]);
			Spec.add(\deltas, [0, 4, 1, 1]);
			Spec.add(\delta, [0.01, 10]);

			//hole
			/*
			Spec.add(\damp, [0, 1]);
			Spec.add(\hrate, [0, 2]);
			Spec.add(\hsize, [0.5, 3]);
			Spec.add(\hdif, [0, 1]);
			Spec.add(\hfb, [0, 1]);
			*/

			//ampFin
			Spec.add( \limDrive, \ampx4 );
			Spec.add( \ampLimit, \amp );
			Spec.add( \postAmp, \ampx4 );

			//pitch
			Spec.add(\pideg, [-12, 12, \lin, 1]);
			Spec.add(\pdisp, [0, 0.5]);
			Spec.add(\tdisp, [0, 1]);
			Spec.add(\slide, [0.02, 2]);

			//wah
			Spec.add(\wrate, [0, 10, \lin]);
			Spec.add(\depth, [0, 1]);
			Spec.add(\jdepth, [0, 1]);
			Spec.add(\wring, [0.001, 1, \exp]);
			Spec.add(\sinsaw, [0, 1, \lin, 1, 0]);
			Spec.add(\jfreq, [0.1, 10, \exp]);
			// Spec.add(\wphase, [0, 1]);

			//tape
			Spec.add(\toffset, [0, 1]);
			Spec.add(\tdepth, [0.001,1, \lin]);
			Spec.add( \trate, [ 0.25, 4, \lin, 0.25, 1 ]);
			Spec.add( \tphase, [ 0, 2]);
			Spec.add( \cps, [ 0.1, 10]);

			// lLFO
			Spec.add( \iphase, [ 0.001, 1, \exp, 0, 0.5 ]);
			Spec.add(\hifreq, [200, 20000, \exp, 0, 220, units: " Hz"]);
			Spec.add( \lwidth, [ 0, 1 ]);
			Spec.add(\sisap, [0, 2, \lin, 1, 1]);
			Spec.add( \lrate, [ 0, 16, \lin, 0.125, 1 ]);

			q.fx.fxLib.keysValuesDo({ |key,val|
				ProxyChain.add(key.asSymbol, \filterIn -> val);
			});
		);

		"Effects Library - LOADED".postString;

		0.1.wait;
		//////////////////////////////////////////////////////////////////////////////

		[ Ndef(\orb1), Ndef(\orb1), Ndef(\orb2), Ndef(\orb3) ].do(_.addSpec(
			/* tape --*/ \trate, [ 0.125, 4, \lin, 0.125, 0.25 ],  \tphase, [ 0, 2], \toffset, [0, 1],
			\tdepth, [0, 1],
			/* hole --*/ // \hrate, [0, 1],  \damp, [0, 1],  \hsize, [0.5, 3],  \hdif, [0, 1],  \hfb, [0, 1],
			/* pitch -*/ \pideg,  [-12, 12, \lin, 1],  \pdisp,  [0, 0.5],  \tdisp, [0, 1],  \slide, [0.02, 2],
			/* wah ---*/ \wrate,  [0, 10, \lin],  \depth, [0, 1], \jdepth, [0, 1], \jfreq, [0.1, 10, \exp],
			\sinsaw, [0, 1, \lin, 1, 0],  \ggain, [0.001, 1, \lin/*\amp*/],\wring, [0.001, 1, \exp],
			/* llfo --*/ \lrate, [ 0, 16, \lin, 0.125, 1 ],  \hifreq, [200, 20000, \exp, 0, 20000],
			\lwidth, [ 0, 1 ], \sisap, [0, 2, \lin,1, 1],  \iphase, [ 0.001, 1, \exp, 0, 0.5 ],
			\offtime, [0.16, 16],  \sphase, [0.16, 16],
			/* comp --*/ \cctrl, [0, 3, \lin, 1, 1], \thresh, [-60.dbamp, 1, \amp], \slopea, [0.05, 1],
			\clamp, [0.002, 0.4], \relax, [0.005, 2], \delta, [0.01, 10],
			/* ampFin */ \limDrive, \ampx4,  \ampLimit, \amp,  \postAmp, \ampx4,
			\cps, [0.1,1]
		) );

		0.1.wait;

		q.fx.orb0 = ProxyChain.from( Ndef(\orb0),
			[ 'tape','wah', 'llfo', 'comp', 'ampFin' ]
		);
		q.fx.orb1 = ProxyChain.from( Ndef(\orb1),
			[ 'tape', 'wah', 'llfo', 'comp', 'ampFin' ]
		);
		q.fx.orb2 = ProxyChain.from( Ndef(\orb2),
			[ 'tape', 'wah', 'llfo', 'comp','ampFin' ]
		);
		q.fx.orb3 = ProxyChain.from( Ndef(\orb3),
			[ 'pitch', 'tape', 'wah', 'llfo', 'comp', 'ampFin' ]
		);

		0.1.wait;

		[ Ndef(\orb0), Ndef(\orb1), Ndef(\orb2), Ndef(\orb3) ].do(_.set(
			/* tape */ \trate, 0.25, \tphase, 0, \tdepth, 0.5, \toffset, 0.5,
			/* wah */ \wrate, 1, \depth, 0.75, \sinsaw, 0, \jdepth, 0.1, \jfreq, 1,
			/* llfo */ \lrate, 0, \iphase, 0.5, \lwidth, 0.5, \sisap, 0, \midfreq, 60, \hifreq, 20000,
			/* comp */ \cctrl, 1, \thresh, 0.5, \slopea, 1, \clamp, 0.002, \relax, 0.02, \delta, 1,
			/* ampFin */ \limDrive, 1.25, \ampLimit, 1, \postAmp, 1,
			\cps, 1
		) );

		Ndef(\orb2).set(
			/* comp */ \cctrl, 3, \thresh, -60.dbamp, \slopea, 0.1, \clamp, 0.002, \relax, 0.5,
			/* tape */ \trate, 0.5, \tphase, 0, \tdepth, 0.25, \toffset, 0.5
		);

		Ndef(\orb3).set(
			/* pitch */ \pideg, 0, \pdisp, 0.001, \tdisp, 0.1, \slide, 0.2,
		);

		0.1.wait;
		(
			// q.fx.orb0.remove(\tape)
			[ 'tape', 'wah', 'llfo', 'comp', 'ampFin' ].do(
				{ |i| q.fx.orb0.add(i) }
			);
			[ 'tape', 'wah', 'llfo', 'comp', 'ampFin' ].do(
				{ |i| q.fx.orb1.add(i) }
			);
			[ 'tape', 'wah', 'llfo', 'comp', 'ampFin' ].do(
				{ |i| q.fx.orb2.add(i) }
			);
			[ 'pitch', 'tape', 'wah', 'llfo', 'comp', 'ampFin' ].do(
				{ |i| q.fx.orb3.add(i) }
			);
		);
		q.fx.orb0.add('tape', 0.2);
		/*
		[q.fx.orb0, q.fx.orb1, q.fx.orb2, q.fx.orb3].do{|i| i.add('hole', 0)};
		*/

		//////////////////////////////////////////////////////////////////////

		// q.fxDir = thisProcess.nowExecutingPath.dirname;
		0.1.wait;
		(
			{
				// var fxDir = thisProcess.nowExecutingPath.dirname

				q.guiOrb0 = q.fx.orb0.gui(33).moveTo(0, 570);
				q.guiOrb1 = q.fx.orb1.gui(33).moveTo(500, 570);
				q.guiOrb2 = q.fx.orb2.gui(33).moveTo(1000, 570);
				q.guiOrb3 = q.fx.orb3.gui(38).moveTo(1500, 570);

				// q.guiOrb4 = q.fx.orb4.gui(8).moveTo(0, 0);
				q.o0Pset = NdefPreset( Ndef(\orb0) );
				/*
				q.o0Pset.loadSettings( q.fxDir ++ "/orb0.pxpreset.scd");
				q.o0PsetGui = NdefPresetGui(q.o0Pset, 40).moveTo(0, 570);*/

				q.o1Pset = NdefPreset( Ndef(\orb1) );
				/*
				q.o1Pset.loadSettings( q.fxDir ++ "/orb1.pxpreset.scd");
				q.o1PsetGui = NdefPresetGui(q.o1Pset, 40).moveTo(500, 570);
				*/

				q.o2Pset = NdefPreset( Ndef(\orb2) );
				/*
				q.o2Pset.loadSettings( q.fxDir ++ "/orb2.pxpreset.scd");
				q.o2PsetGui = NdefPresetGui(q.o2Pset, 40).moveTo(1000, 570);
				*/

				q.o3Pset = NdefPreset( Ndef(\orb3) );
				/*
				q.o3Pset.loadSettings( q.fxDir ++ "/orb3.pxpreset.scd");
				q.o3Psetgui = NdefPresetGui(q.o3Pset, 40).moveTo(1500, 570);
				*/

			}.defer;
		);
		0.5.wait;

		//////////////////////////////////////////////////////////////////////////////////////////////

		(
			OSCdef(\oscFromTidal, { |msg|
				MFdef(\theHub).value(msg);
			}, '/play2').permanent_(true)
		);

		MFdef(\theHub).add(\post, {|msg| msg.postln});
		/*
		MFdef(\theHub).enable(\post);
		MFdef(\theHub).disable(\post);
		*/

		q.orbz = Ndef(\orb0);
		q.vstorb = 0;

		// q.allOrbs = [q.fx.orb0.proxy, q.fx.orb1.proxy, q.fx.orb2.proxy, q.fx.orb3.proxy];

		MFdef(\theHub).add(\setOrb,
			{ |msg|
				var orbz;
				if ( ( msg.indexOf( \orbit ).notNil ) and: ( orbz != q.orbz ) ) {
					q.orbz = Ndef( "orb%".format( msg.at( msg.indexOf( \orbit ).asInteger + 1 ) ).asSymbol );
					orbz = q.orbz;
					// q.orbz.postln;
				};
			}
		);
		MFdef(\theHub).add(\setVst,
			{ |msg|
				var vstorbz;
				if ( ( msg.indexOf( \orbit ).notNil ) and: ( vstorbz != q.vstorb ) ) {
					q.vstorb = msg.at( msg.indexOf( \orbit ).asInteger + 1 );
					vstorbz = q.vstorb;
				};
			}
		);

		MFdef(\theHub).add( \tidalSetOrbs, { |msg|
			msg.collect { |key, i|
				switch ( key )
				{ \wet10 } { q.orbz.set( key, msg[i+1] ) }
				{ \wet20 } { q.orbz.set( key, msg[i+1] ) }
				{ \wet30 } { q.orbz.set( key, msg[i+1] ) }
				{ \wet40 } { q.orbz.set( key, msg[i+1] ) }
				{ \wet50 } { q.orbz.set( key, msg[i+1] ) }
				{ \wet60 } { q.orbz.set( key, msg[i+1] ) }
				// { \wet70 } { q.orbz.set( key, msg[i+1] ) }
				// { \wet80 } { q.orbz.set( key, msg[i+1] ) }

				/* pitch -*/
				{ \pideg } { q.orbz.set( key, msg[i+1] ) }
				{ \pdisp } { q.orbz.set( key, msg[i+1] ) }
				{ \tdisp } { q.orbz.set( key, msg[i+1] ) }
				{ \slide } { q.orbz.set( key, msg[i+1] ) }

				/* tape, */
				{ \trate } { q.orbz.set( key, msg[i+1] ) }
				{ \tphase } { q.orbz.set( key, msg[i+1] ) }
				{ \tdepth } { q.orbz.set( key, msg[i+1] ) }
				{ \toffset } { q.orbz.set( key, msg[i+1] ) }

				/* comp, */
				{ \ctrl } { q.orbz.set( key, msg[i+1] ) }
				{ \thresh } { q.orbz.set( key, msg[i+1] ) }
				{ \slopea } { q.orbz.set( key, msg[i+1] ) }
				{ \clamp } { q.orbz.set( key, msg[i+1] ) }
				{ \relax } { q.orbz.set( key, msg[i+1] ) }

				/* wah, */
				{ \wrate } { q.orbz.set( key, msg[i+1] ) }
				{ \depth } { q.orbz.set( key, msg[i+1] ) }
				{ \sinsaw } { q.orbz.set( key, msg[i+1] ) }
				{ \jfreq } { q.orbz.set( key, msg[i+1] ) }
				{ \jdepth } { q.orbz.set( key, msg[i+1] ) }

				/* lfo,*/
				{ \sisap} { q.orbz.set( key, msg[i+1] ) }
				{ \lrate} { q.orbz.set( key, msg[i+1] ) }
				{ \iphase } { q.orbz.set( key, msg[i+1] ) }
				{ \lwidth } { q.orbz.set( key, msg[i+1] ) }
				{ \midfreq } { q.orbz.set( key, msg[i+1] ) }
				{ \hifreq } { q.orbz.set( key, msg[i+1] ) }

				/* ampFin */
				{ \postAmp } { q.orbz.set( key, msg[i+1] ) }

				{ \cps } { q.orbz.set( key, msg[i+1] ) }
				{ \delta } { q.orbz.set( key, msg[i+1] );
					q.deltas.setPairs( q.vstorb, msg[i+1].asFloat )
				}

				/* ---------------- vst stuff --------------------- */

				/* reverb */
				{ \vwet } { ~vwet.setPairs( q.vstorb.asInteger, msg[i+1].asFloat ) }
				{ \vdry } { ~vdry.setPairs( q.vstorb.asInteger, msg[i+1].asFloat ) }
				{ \vdelay } { ~vdelay.setPairs(q.vstorb.asInteger, msg[i+1].asFloat ) }
				{ \vsize } { ~vsize.setPairs( q.vstorb.asInteger, msg[i+1].asFloat ) }
				{ \vlocut } { ~vlocut.setPairs(q.vstorb.asInteger, msg[i+1].asFloat ) }
				{ \vhicut } { ~vhicut.setPairs( q.vstorb.asInteger, msg[i+1].asFloat ) }
			}
		})

	}
);
);