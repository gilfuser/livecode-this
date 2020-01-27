// I Quit adding my own Tidal Global FX because they sound like they are in parallel. I'm using my own setup based on ProxyChains. See fxLib.scd, FXXX_orbs.scd and tidal_set_FX.scd

(
var numChannels = ~dirt.numChannels;
(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef( 'dirt_wah' ++ numChannels, { |dryBus, effectBus, wah = 0, gate = 1, wlock = 0, cps = 1, wrate = 1, depth = 0.5, sinsaw = 0, wphase = 0.25, jrate = 1, jdepth = 0.1 |
		var  in, jitter, mod, ringz, snd, wring = 0.002, wrq = 0.8,  ggain = 1.25;

		in = In.ar(dryBus, numChannels);
		wrate = wrate * if(wlock, reciprocal(cps), 1);
		jitter = LFNoise2.ar(jrate, jdepth);
		mod = Select.kr(sinsaw, [
			SinOsc.ar( wrate, ( jitter * 2pi) % 2pi, depth).exprange(100, 5000),
			VarSaw.kr(wrate, jitter, 0.1, depth).lag(0.1).exprange(100, 5000),
		]);
		ringz = Ringz.ar( in, mod, wring );
		snd = RLPF.ar(ringz, mod, wrq.lag(0.1)) * ggain.tanh.lag(0.0003) / ggain.sqrt;
		snd = snd * EnvGen.kr(Env.asr, gate, doneAction:2);
		snd = Limiter.ar(snd);
		DirtPause.ar(snd, graceTime:4);
		XOut.ar(effectBus, wah, snd);
	}, [\ir, \ir]).add;

};
);

(
~dirt.orbits.do { |x|
	x.globalEffects = x.globalEffects.addFirst(
		GlobalDirtEffect(\dirt_wah, [ \wah, \wrate, \depth, \jdepth, \wring, \sinsaw,  \jrate, \wphase ])
	);
	x.initNodeTree
};
);

/*(
var numChannels = ~dirt.numChannels;
(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef('dirt_tape' ++ numChannels, { |dryBus, effectBus, tape = 0, gate = 1, tlock = 0, trate=1, tphase=1.5, tdepth = 1, toffset = 1, cps = 1 |
		var in, curve, snd;

		in = In.ar(dryBus, numChannels);
		trate = trate * if(tlock, reciprocal(cps), 1);
		curve = SinOsc.ar( trate, (tphase * 2pi + 1.5pi) % 2pi, tdepth, toffset );
		snd = DelayC.ar( in, 2, curve, add: 1 );

		snd = snd * EnvGen.kr(Env.asr, gate, doneAction:2);
		DirtPause.ar(snd, graceTime:4);
		XOut.ar(effectBus, tape, snd);

	}, [\ir, \ir]).add;
};
);

(
~dirt.orbits.do { |x|
	x.globalEffects = x.globalEffects.addFirst(
		GlobalDirtEffect(\dirt_tape, [ \tape, \toffset, \tdepth, \trate, \tphase ])
	);
	x.initNodeTree
};
);*/

(
var numChannels = ~dirt.numChannels;
(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef( 'dirt_modelay' ++ numChannels, { |dryBus, effectBus, modelay = 1, gate = 1, mdfb = 0.5, mdtime = 1, mdtimel = 1.5, mdtimer = 1, mdlock = 0, cps = 1, mdfreq = 800, mdq = 3, mdamp = 1 |
		var decaytime, decaytimeL, decaytimeR, delayL, delayR, timeMod, eqMod;
		var maxDelayTime = 4;
		var signal = In.ar(dryBus, numChannels);

		// in = if(numChannels > 2) { in.clump(2).sum } { in.dup };
		mdamp = mdamp.clip(0, 4);
		mdfb = mdfb.clip(0, 0.99);
		mdtime = mdtime * if(mdlock, reciprocal(cps), 1);
		mdtime = mdtime.clip(0.014, maxDelayTime);
		decaytime = log2(-60.dbamp) / log2(mdfb) * mdtime;
		decaytime = decaytime.clip(0, 20);
		mdtimel = mdtimel * if(mdlock, reciprocal(cps), 1);
		mdtimel = mdtimel.clip(0.014, maxDelayTime); // just to be sure
		mdtimer = mdtimer * if(mdlock, reciprocal(cps), 1);
		mdtimer = mdtimer.clip(0.014, maxDelayTime);
		decaytimeL = log2(-60.dbamp) / log2(mdfb) * mdtimel;
		decaytimeL = decaytimeL.clip(0, 20);
		decaytimeR = log2(-60.dbamp) / log2(mdfb) * mdtimer;
		decaytimeR = decaytimeR.clip(0, 20);

		timeMod = { LFDNoise3.ar(5.5, 0.001) };
		eqMod = { LFDNoise3.kr(1, 0.25, 1) };

		signal = signal + ( [ LocalIn.ar(2)[0] * mdtimel.lincurve(0, 4, 0, 1, -16), LocalIn.ar(2)[1] * mdtimer.lincurve(0, 4, 0, 1, -16) ] );

		delayL = CombC.ar( signal[0], maxDelayTime, mdtimel + timeMod, decaytimeL );
		delayL = BBandPass.ar( delayL, mdfreq.lag(0.1) * eqMod, mdq.lag(0.1) );

		delayR = CombC.ar(signal[1], maxDelayTime, mdtimer + timeMod, decaytimeR );
		delayR = BBandPass.ar( delayR, mdfreq.lag(0.1) * eqMod, mdq.lag(0.1) );

		signal = Limiter.ar( [ delayL, delayR] * mdamp.lag(0.01) );
		LocalOut.ar( AllpassN.ar(mdfb * signal, maxDelayTime, delaytime: mdtime /* + timeMod */ , decaytime: decaytime) );

		DetectSilence.ar(signal, time:1, doneAction: 1);
		signal = LeakDC.ar(signal) * EnvGen.kr(Env.asr, gate, doneAction:2);
		signal = Limiter.ar(signal);
		DirtPause.ar(signal, graceTime:4);
		// Out.ar(effectBus, signal);
		XOut.ar(effectBus, modelay, signal)
	}, [\ir, \ir]).add;

};
);

(
~dirt.orbits.do { |x|
	x.globalEffects = x.globalEffects.addFirst(
		GlobalDirtEffect(\dirt_modelay, [ \modelay, \mdfb, \mdtime, \mdtimel, \mdtimer, \mdlock, \mdfreq, \mdq, \mdamp])
	);
	x.initNodeTree
};
);

/*
WON'T  WORK
(
var numChannels = ~dirt.numChannels;
(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

	SynthDef( 'dirt_pitch' ++ numChannels, { |dryBus, effectBus, pitch = 1, gate = 1, cps = 1, pideg = 0, oct = 0, pdisp = 0.01, tdisp = 0.01, pslide = 0.1 |
		var wSize, timeDisp, pitchRatio, signal, in;

		in = In.ar(dryBus, numChannels);
		pitchRatio = Scale.chromatic.degreeToRatio(pideg, oct);
		wSize =  0.15;
		timeDisp = LFDNoise3.ar( 0.0626).range(0, wSize) * tdisp;
		signal = PitchShift.ar( in, wSize, pitchRatio, pdisp, timeDisp );
		signal = LeakDC.ar(signal) * EnvGen.kr(Env.asr, gate, doneAction:2);
		signal = Limiter.ar(signal);
		DirtPause.ar(signal, graceTime:4);
		XOut.ar(0, pitch, signal)
	}, [\ir, \ir]).add;

};
)

(
~dirt.orbits.do { |x|
	x.globalEffects = x.globalEffects.addFirst(
		GlobalDirtEffect(\dirt_pitch, [ \pitch, \pdisp, \tdisp, \pslide, \pideg, \oct ] )
	);
	x.initNodeTree
};
);*/