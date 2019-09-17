// here you can see the effect order:
/*
~dirt.modules.do{|v|v.postln};
~dirt.orbits[0].globalEffects.do{|v|v.postln};

// OPTIONAL: you can reorder the effects, if you want e.g. the lpf to come after the delay
~dirt.orderModules(['satur', 'hpf', 'klm']);
*/
{
    var numChannels = ~dirt.numChannels;
        (1..SuperDirt.maxSampleNumChannels).do { |numChannels|
            SynthDef("dirt_global_tape" ++ numChannels,
                { |dryBus, effectBus, gate = 1, tape = 1 trate=1 tphase=1.5 tdepth = 1 toffset = 1 |
                var signal = In.ar(dryBus, numChannels);
                var curve = SinOsc.ar(( trate * {TempoClock.default.tempo}), ( tphase.lag(0.1) * 2pi + 1.5pi) % 2pi, tdepth, toffset.lag(0.1) );
                signal = DelayC.ar(signal, 2, curve);
                signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);
                DirtPause.ar(signal, graceTime:4);
                XOut.ar(effectBus, tape, signal)
            }, \ir!2).add;
        };
        0.1.wait;
        // then add the effect to the orbit
        ~dirt.orbits.do { |x|
            x.globalEffects = ~dirt.orbits[0].globalEffects.addFirst(
                GlobalDirtEffect(\dirt_global_tape, [\tape, \trate, \tphase, \tdepth, \toffset])
            )
        };
        0.1.wait;
        // ~dirt.orbits[0].initNodeTree;

        (1..SuperDirt.maxSampleNumChannels).do { |numChannels|
            SynthDef("dirt_global_mypitch" ++ numChannels,
                { |dryBus, effectBus, gate = 1, mypitch = 1 n pdisp = 0.05 tdisp = 0.2 slide = 0.4 |
                var signal = In.ar(dryBus, numChannels);
                var wSize, timeDisp, pitchRatio;
                // scl = Scale.choose(7, 12).tuning_(Tuning.choose(12));
                var scl = Scale.chromatic;
                pitchRatio = Select.kr( n + 12, [
                    scl.degreeToRatio(-12, 0).lag(slide), scl.degreeToRatio(-11, 0).lag(slide), scl.degreeToRatio(-10, 0).lag(slide), scl.degreeToRatio(-9, 0).lag(slide), scl.degreeToRatio(-8, 0).lag(slide), scl.degreeToRatio(-7, 0).lag(slide), scl.degreeToRatio(-6, 0).lag(slide), scl.degreeToRatio(-5, 0).lag(slide), scl.degreeToRatio(-4, 0).lag(slide), scl.degreeToRatio(-3, 0).lag(slide), scl.degreeToRatio(-2, 0).lag(slide), scl.degreeToRatio(-1, 0).lag(slide), scl.degreeToRatio(0, 0).lag(slide), scl.degreeToRatio(1, 0).lag(slide), scl.degreeToRatio(2, 0).lag(slide), scl.degreeToRatio(3, 0).lag(slide), scl.degreeToRatio(4, 0).lag(slide), scl.degreeToRatio(5, 0).lag(slide), scl.degreeToRatio(6, 0).lag(slide), scl.degreeToRatio(7, 0).lag(slide), scl.degreeToRatio(8, 0).lag(slide), scl.degreeToRatio(9, 0).lag(slide), scl.degreeToRatio(10, 0).lag(slide), scl.degreeToRatio(11, 0).lag(slide), scl.degreeToRatio(12, 0).lag(slide)
                ]);
                wSize =  0.15;
                timeDisp = LFDNoise3.ar( 0.0626).range(0, wSize) * tdisp;
                signal = PitchShift.ar( signal, wSize, pitchRatio, pdisp, timeDisp );
                signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);
                DirtPause.ar(signal, graceTime:4);
                XOut.ar(effectBus, mypitch, signal)
            }).add;
        };
        0.1.wait;

        ~dirt.orbits.do { |x|
            x.globalEffects = ~dirt.orbits[0].globalEffects.addFirst(
                GlobalDirtEffect(\dirt_global_mypitch, [ \mypitch, \pdisp, \tdisp, \slide ])
            )
        };
        0.1.wait;
        ~dirt.orbits[0].initNodeTree;

        (1..SuperDirt.maxSampleNumChannels).do { |numChannels|
            SynthDef("dirt_global_llfo" ++ numChannels,
                { |dryBus, effectBus, gate = 1, llfo = 1 sisap=0 lrate=1 iphase=0 lwidth=0.5, midfreq=60 , hifreq=20000 |
                var signal = In.ar(dryBus, numChannels);
                var tempo = (lrate * {TempoClock.default.tempo}).reciprocal.lag(0.2);
                var mod = Select.ar(sisap, [
                    SinOsc.ar( tempo, ( /*lrate * */iphase * 2pi + 1.5pi) % 2pi),
                    LFSaw.ar( tempo, iphase % 2, lwidth ), // change to LFTri
                    LFPulse.ar(tempo, (lrate * iphase) % 1, lwidth.clip(0.02, 0.998) )*2-1,
                ]);
                signal = BLowPass.ar(signal, mod.lag2(0.05).exprange(midfreq.lag(0.1), hifreq.lag(0.1)));
                signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);
                DirtPause.ar(signal, graceTime:4);
                XOut.ar(effectBus, llfo, signal)
            }, \ir!2).add;
        };
        0.1.wait;

        ~dirt.orbits.do { |x|
            x.globalEffects = ~dirt.orbits[0].globalEffects.addFirst(
                GlobalDirtEffect(\dirt_global_llfo, [\llfo, \sisap, \lrate, \iphase, \lwidth, \midfreq, \hifreq])
            )
        };
        0.1.wait;
        ~dirt.orbits[0].initNodeTree;

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
        0.1.wait;

        ~dirt.addModule('wah', { |dirtEvent|
            dirtEvent.sendSynth('wah' ++ ~dirt.numChannels )
        }, { ~wah.notNil or: { ~wrate.notNil } });

        SynthDef( "wah" ++ ~dirt.numChannels, { | out wah = 1 wrate = 1 wdepth = 0.5 sinsaw = 0 jfreq = 1 jdepth = 0 |
            var signal = In.ar(out, ~dirt.numChannels);
            var  wring = 0.002, wrq = 0.8, ggain = 1.25;
            var jitter = LFNoise2.ar(jfreq, jdepth);
            var mod = Select.kr(sinsaw, [
                SinOsc.ar( wrate, ( jitter * 2pi) % 2pi, wdepth).exprange(100, 5000),
                VarSaw.kr(wrate, jitter, 0.1, wdepth).lag(0.1).exprange(100, 5000),
            ]);
            var ringz = Ringz.ar( signal, mod, wring );
            var sig = RLPF.ar(ringz, mod, wrq.lag(0.1)) * ggain.tanh.lag(0.0003) / ggain.sqrt;
            Limiter.ar(sig, 0.9);
            XOut.ar(out, wah, sig)
        }).add;
}.fork;
