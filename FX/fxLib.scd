q = q ? ();
q.fx = q.fx ? ();
// q.views = q.views ? ();

{
	q.scale = Scale.chromatic;
	q.deltas = Bus.control(s, 5).setn(1!5);
	0.2.wait;



	ProxyChain.add3( 'tape', \filter -> { |in trate=1 tphase=1.5 tdepth = 1 toffset = 1 |
		var curve = SinOsc.ar(( trate * {TempoClock.default.tempo})/*.reciprocal.lag(0.2)*/, ( /*trate **/ tphase.lag(0.1) * 2pi + 1.5pi) % 2pi, tdepth, toffset.lag(0.1) );
		DelayC.ar(in, 2, curve/*, in*/);
	},
	1,
	(
		[
			\toffset: [0, 1],
			\tdepth: [0.001,1, \lin],
			\trate: [ 0.25, 4, \lin, 0.25, 1 ],
			\tphase: [ 0, 2],
			\cps: [ 0.1, 10],
		]
	)
	);

	ProxyChain.add3( 'wah', \filter -> { |in, wrate = 1, wdepth = 0.5, sinsaw = 0, wphase = 0, jrate = 1, jdepth = 0 |
		var  wring = 0.002, wrq = 0.8,  ggain = 1.25 ;
		var jitter = LFNoise2.ar(jrate, jdepth);
		var mod = Select.kr(sinsaw, [
			SinOsc.ar( wrate, ( jitter * 2pi) % 2pi, wdepth).exprange(100, 5000),
			VarSaw.kr(wrate, jitter, 0.1, wdepth).lag(0.1).exprange(100, 5000),
		]);
		var ringz = Ringz.ar( in, mod, wring );
		var sig = RLPF.ar(ringz, mod, wrq.lag(0.1)) * ggain.tanh.lag(0.0003) / ggain.sqrt;
		Limiter.ar(sig, 0.9);
	},
	1,
	(
		[
			\wrate, [0, 10, \lin],
			\wdepth, [0, 1],
			\jdepth, [0, 1],
			\wring, [0.001, 1, \exp],
			\sinsaw, [0, 1, \lin, 1, 0],
			\jrate, [0.1, 10, \exp],
			\wphase, [0, 1],
		]
	)
	);

	/*
	// NOT WORKING!
	ProxyChain.add3( 'pitch', \filter -> { | in, pideg = 0, oct = 0, pdisp = 0.005, tdisp = 0.05, slide = 0.4 |
		var wSize, timeDisp, pitchRatio, degree;
		degree = pideg.asInteger;
		pitchRatio = Scale.chromatic.degreeToRatio(degree, oct);
		wSize =  0.15;
		timeDisp = LFDNoise3.ar( 0.0626).range(0, wSize) * tdisp;
		PitchShift.ar( in, wSize, pitchRatio, pdisp, timeDisp );
	},
	1,
	(
		[
			\pdisp: [0, 0.5],
			\tdisp: [0, 1],
			\slide: [0.02, 2],
			\pideg: [-36, 36, \lin, 1, 0],
			\oct: [-4, 4, \lin, 1]
		]
	)
	);
	*/

	ProxyChain.add3( 'llfo', \filterIn -> { | in,  sisap = 0,  cps = 1, lrate = 0, iphase = 0, lwidth = 0.5,  midfreq = 60,  hifreq = 20000 |
		var tempo = (lrate * cps /* TempoClock.default.tempo */).reciprocal;
		var mod = Select.ar(sisap, [
			SinOsc.ar( tempo, (  lrate *  iphase * 2pi + 1.5pi) % 2pi),
			LFSaw.ar( tempo, iphase % 2, lwidth ), // change to LFTri
			LFPulse.ar(tempo, (lrate * iphase) % 1, lwidth.clip(0.02, 0.998) ) * 2 - 1,
		]);
		BLowPass.ar(in, mod.lag2(0.05).exprange(midfreq.lag(0.1), hifreq.lag(0.1)));
	},
	1,
	(
		[
			\iphase, [ 0.001, 1, \exp, 0, 0.5 ],
			\hifreq, [ 200, 20000, \exp, 0, 220, "Hz" ],
			\lwidth, [ 0, 1 ],
			\sisap, [ 0, 2, \lin, 1, 1 ],
			\lrate, [ 0, 16, \lin, 0.125, 1 ],
			\cps, [ 0.05, 2 ]
		]
	)
	);

	ProxyChain.add3( \hpf, \filter -> { |in freq = 80 rq = 1|
		BHiPass.ar( in, freq.lag(0.2), rq.lag(0.2) ); // mul
	},
	1,
	);

	ProxyChain.add3( \compT, \filterIn -> { | in, cctrl = 0, thresh = 0.25, slopea = 0.5, clamp = 0.001, relax = 0.1, deltas = 1 |
		var deltaSel = Select.kr(deltas, q.deltas);
		var bus = Select.kr(cctrl, q.outBusses);
		var comp = Compander.ar( in, In.ar( bus, ~dirt.numChannels), thresh.linexp(0, 1, 0.001, 1), 1, slopea, clamp, relax * deltas );
		Limiter.ar( comp );
	},
	1,
	(
		[
			\cctrl: [0, 3, \lin, 1, 1 ],
			\thresh: [-60.dbamp, 1, \amp ],
			// \slopeb, [0.5, 4]);
			\slopea: [0.05, 1 ],
			\clamp: [0.001, 0.4 ],
			\relax: [0.1, 1 ],
			\deltas: [0, 4, 1, 4 ],
			\delta: [0.01, 10 ]
		]
	)
	);

	ProxyChain.add3( 'orbx', \filterIn -> { |in, redir = 4|
		var bus = Select.ar( redir, [ InFeedback.ar(~dirt.numChannels, ~dirt.numChannels), InFeedback.ar(~dirt.numChannels * 2, ~dirt.numChannels), InFeedback.ar(~dirt.numChannels * 3, ~dirt.numChannels), InFeedback.ar(~dirt.numChannels * 4, ~dirt.numChannels), DC.ar(0) ] );
		in + bus;
	},
	1,
	(
		[
			\redir: [0, 4, \lin, 1, 1],
			// \in1: [0, 3, \lin, 1, 1]
		]
	)
	);

	/* 'hole' -> {  | in , hrate = 0.1, damp = 0.1, hsize = 1, hdif = 0.707, hfb = 0.1, cps , hhpf, hlpf | */
	// var delayTime = (hrate * {TempoClock.default.tempo}).reciprocal.lag(0.2);
	// Greyhole.ar( in, delayTime, damp, hsize.lag(0.2), hdif, hfb, modDepth: 0.2 );
	/* },
	\damp, [0, 1]);
	\hrate, [0, 2]);
	\hsize, [0.5, 3]);
	\hdif, [0, 1]);
	\hfb, [0, 1]);
	*/

	ProxyChain.add3( 'lpf', \filterIn -> { | in, freq = 60, rq = 0.2 |
		BLowPass.ar(in, freq.lag2(0.2), rq.lag2(0.2) );
	},
	1,
	(
		[
			\rq, [0.2, 2],
		]
	)
	);

	ProxyChain.add3( \leakDC,  \filterIn -> { |in, leak=0.99| LeakDC.ar(in, leak) },
		1,
		(\leak: [0.5, 0.999, \exp])
	);

	ProxyChain.add3( \comp, \filterIn -> { | in, thresh = 0.33, slopea = 0.33, clamp = 0.03, relax = 0.35 |
		var comp = Compander.ar( in, in, thresh.linexp(0, 1, 0.001, 1), 1, slopea, clamp, relax );
		Limiter.ar( comp );
	},
	1,
	(
		\thresh: [-60.dbamp, 1, \amp],
		\slopea: [0.05, 1],
		\clamp: [0.001, 0.4],
		\relax: [0.1, 1]
	)
	);

	ProxyChain.add3( \ampFin, \filter -> { |in, drive=1.2, ampLimit=0.8 |
		Limiter.ar(in * drive, ampLimit);
	},
	1,
	(
		\drive: [1, 10, \exp],
		\ampLimit: \amp
	)
	);

	ProxyChain.add3( \verb, \filterIn -> { |in mix = 0.5 room = 0.5 damp = 0.5 |
		FreeVerb.ar(in, mix, room, damp)
	},
	1,
	(
		\mix: [0,1],
		\room: [0,1],
		\damp: [0,1]
	)
	);

	ProxyChain.add3( \verbPan, \filterIn -> { |in mix = 0.5 room = 0.5 damp = 0.5 pan = 0 |
		var sig2v = PanAz.ar( s.options.numOutputBusChannels,  in, pan, 1, s.options.numOutputBusChannels );
		PanAz.ar( s.options.numOutputBusChannels,  FreeVerb.ar(in, mix, room, damp), pan, 1, s.options.numOutputBusChannels );
	},
	1,
	(
		\mix: [0,1],
		\room: [0,1],
		\damp: [0,1]
	)
	);

	ProxyChain.add3(
		\leakDC,  \filter -> { |in, leak=0.99| LeakDC.ar(in, leak) },
		1,
		(\leak: [0.5, 0.999, \exp])
	);

	ProxyChain.add3(
		\analysis,  \filter -> { | in, rate = 60 |
			var freq, hasFreq, in_copy, amp, trig /*trigA, trigHf, trigF*/;
			in_copy = HPF2Casc.ar( in, 40, 8 );
			in_copy = Compander.ar( in_copy, in_copy, 0.05, slopeBelow: 8 );
			amp = Amplitude.kr( in_copy, 0.05, 0.05 );
			# freq, hasFreq = Tartini.kr( in_copy, 0.93, 1024, 512, 512 );
			trig = Impulse.kr(rate);
			/*trigA = Changed.kr( amp );
			trigHf = Changed.kr( hasFreq );
			trigF = Changed.kr( freq );*/
			SendReply.kr( trig, '/amp', amp );
			SendReply.kr( trig, '/hasFreq', hasFreq );
			SendReply.kr( trig, '/freq', freq );
			in;
		},
		1,
		(\rate: [8, 60, \lin, 1, 8])
	);


    (
        ProxyChain.add3(
            \modelay, \filter -> { | in, mdfb = 0.5, mdtime = 1, mdtimel = 1.5, mdtimer = 1, mdlock = 0, cps = 1, mdff = 800, mdfq = 3, mdamp = 1 |
		var decaytime, decaytimeL, decaytimeR, delayL, delayR, timeMod, eqMod;
		var maxDelayTime = 4;
		var signal = in;

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
		delayL = BBandPass.ar( delayL, mdff.lag(0.1) * eqMod, mdfq.lag(0.1) );

		delayR = CombC.ar(signal[1], maxDelayTime, mdtimer + timeMod, decaytimeR );
		delayR = BBandPass.ar( delayR, mdff.lag(0.1) * eqMod, mdfq.lag(0.1) );

		signal = Limiter.ar( [ delayL, delayR] * mdamp.lag(0.01) );
		LocalOut.ar( AllpassN.ar(mdfb * signal, maxDelayTime, delaytime: mdtime /* + timeMod */ , decaytime: decaytime) );
		signal;
            },
            1,
            (
				\mdtime: [0,4],
                \mdtimel: [0,4],
                \mdtimer: [0,4],
                \mdfb: [0,1],
				\mdlock: [0,1,\lin,1],
                \mdff: [42,4200, \exp],
                \mdfq: [0.3, 3],
                \mdamp: \ampx4,
				\cps: [0.25, 5]
            )
        );
    );

	"\n FX Library -> ProxyChain - LOADED \n ".postln;

}.fork;
