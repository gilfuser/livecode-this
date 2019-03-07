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
	'hole' -> {  | in , hrate = 0.1, damp = 0.1, hsize = 1, hdif = 0.707, hfb = 0.1, cps /*, hhpf, hlpf*/ |
		var delayTime = (hrate * {TempoClock.default.tempo}).reciprocal.lag(0.2);
		Greyhole.ar( in, delayTime, damp, hsize.lag(0.2), hdif, hfb, modDepth: 0.2 );
	},

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
Spec.add(\damp, [0, 1]);
Spec.add(\hrate, [0, 2]);
Spec.add(\hsize, [0.5, 3]);
Spec.add(\hdif, [0, 1]);
Spec.add(\hfb, [0, 1]);

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