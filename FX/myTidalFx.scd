// here you can see the effect order:
/*
~dirt.modules.do{|v|v.postln};
~dirt.orbits[0].globalEffects.do{|v|v.postln};

// OPTIONAL: you can reorder the effects, if you want e.g. the lpf to come after the delay
~dirt.orderModules(['satur', 'hpf', 'klm']);
*/
{
        // Per Pattern FX /////////////////////////////////////////////////////////////////////////////////////

        ~dirt.addModule('saturator', { |dirtEvent|
            dirtEvent.sendSynth('saturator' ++ ~dirt.numChannels,
                // OPTIONAL
                // passing this array of parameters could be left out,
                // but it makes it clear what happens
                /*
                [
                    sind: ~sind,
                    smul: ~smul,
                    satur: ~satur,
                    sustain: ~sustain,
                    out: ~out
                ]
                */
            );
        }, { ~sind.notNil or: { ~satur.notNil } }); // play synth only if at least one of the two was given
        0.1.wait;

        SynthDef( "saturator" ++ ~dirt.numChannels, { | out sind = 4 smul = 0.25 satur = 1 sustain |
            // (smul).poll(Impulse.kr(0.0), label: "smul");
            var signal = In.ar(out, ~dirt.numChannels);
            var saturated = AudioMSG.ar( signal, sind, mul:smul);
            XOut.ar(out, satur, saturated)
        }).add;


        /*
	~dirt.addModule('tape', { |dirtEvent|
            dirtEvent.sendSynth('tape' ++ ~dirt.numChannels,
            );
        }, { ~tape.notNil or: { ~tdepth.notNil } }); // play synth only if at least one of the two was given
        0.1.wait;

    SynthDef("tape" ++ ~dirt.numChannels, { | out, tape = 1, tlock = 1, cps = 1, cycle = 0, trate=0.5, tphase=0.5, tdepth = 0.5, toffset = 0.5 |
        var in, curve, snd;

        in = In.ar(out, ~dirt.numChannels);
        curve = SinOsc.ar(( trate * if(tlock, reciprocal(cps), 1)), ( tphase.lag(0.1) * 2pi + 1.5pi) % 2pi, tdepth, toffset.lag(0.1) /*+ (cycle - (cycle).asInteger)*/ );
        snd = DelayC.ar( in, 2, curve );
        XOut.ar(out, tape, snd)
    }).add;

        ~dirt.addModule('wah', { |dirtEvent|
            dirtEvent.sendSynth('wah' ++ ~dirt.numChannels,
            );
        }, { ~wah.notNil or: { ~wrate.notNil } or: { ~wdepth.notNil } }); // play synth only if at least one of the two was given
        0.1.wait;

    SynthDef('wah' ++ ~dirt.numChannels, { | out, wlock = 0, cps = 1, wah = 1, cycle = 0, wrate = 1, wdepth = 0.5, sinsaw = 0, jrate = 1, jdepth = 0.1 |
        var  in, jitter, mod, ringz, snd, wring = 0.002, wrq = 0.8,  ggain = 1.25;

        in = In.ar(out, ~dirt.numChannels);
        wrate = wrate * if(wlock, reciprocal(cps), 1);
        jitter = LFNoise2.ar(jrate, jdepth);
        mod = Select.kr(sinsaw, [
            SinOsc.ar( wrate, (jitter * 2pi) % 2pi, wdepth, (cycle - (cycle).asInteger) ).exprange(100, 5000),
            VarSaw.kr( wrate, jitter, 0.1, wdepth, (cycle - (cycle).asInteger) ).lag(0.1).exprange(100, 5000),
        ]);
        ringz = Ringz.ar( in, mod, wring );
        snd = RLPF.ar(ringz, mod, wrq.lag(0.1)) * ggain.tanh.lag(0.0003) / ggain.sqrt;
        snd = Limiter.ar(snd);
        XOut.ar(out, wah, snd)
    }).add;
    */

    /*
	// [
	// \wrate, [0, 10, \lin],
	// \depth, [0, 1],
	// \jdepth, [0, 1],
	// \wring, [0.001, 1, \exp],
	// \sinsaw, [0, 1, \lin, 1, 0],
	// \jrate, [0.1, 10, \exp],
	// ]
    */
}.fork;
