(
SynthDef(\acid4, { | out = 0 freq gate = 1 pan = 0 width = 2 acof = 2000 arez = 0.5 adist = 0.5 lagt = 0.5 wform = 0 attack = 0.04 decay = 0.2 amp = 1 sustain = 1 |
    var waves = [ DPW4Saw.ar( freq.lag2(lagt), 0.75  ),  Pulse.ar( freq.lag2(lagt)  )  ];
    var snd = SelectX.ar( wform, waves  ); //!( s.options.numOutputBusChannels  );
    var env = EnvGen.kr(Env.adsr(attack, decay, amp * 0.5, 0.2), gate, doneAction: Done.freeSelf);
    var noise = { LFDNoise3.ar(0.3,0.0156,1)  };
    // snd = (snd*1.25).softclip; //.fold(-0.75, 0.75); // clip2(0.5);
    snd = snd * noise * env;
    snd = ( RLPFD.ar( snd, acof, arez, adist  ) * 0.5  ) + ( RLPF.ar(snd, acof) * 0.5  );
    snd = snd + ( HPF.ar(snd, 400, 10).softclip * 0.50);
    // snd = snd + PitchShift.ar(snd, 0.1, 1.0, 0.02, 0.2) * 0.5;
    snd = PanAz.ar(2, snd, pan, 1, width);
    OffsetOut.ar(out, snd * amp);
}).add;
);
(
Pdef(\acidFunk,
    PmonoArtic(
       \acid4,
		\dur, Pseq([0.25, 0.125, 0.125, 0.25, 0.125, 0.125, 0.125, 0.25, 0.125, 0.25, 0.125], inf) * 1,
		// \root, -7,
		\scale, Scale.ritusen,
		\degree, Pseq([0, 0, 5, -7, -7, -7, -7, -7], inf) - 12,
        // \freq, Pseq([200, 200, 500], inf),
        // \pan, Pfunc({8.0.rand}),
		// \acof, Pbrown(1, 10, 0.2).linexp(1, 10, 60, 4000),
		\rez, Pfunc({ 1.0.rand }),
        \amp, 1,
		\legato, Pwrand([0.1, 0.5, 1.2, 1.8], [0.1, 0.5, 0.2, 0.2], inf),
		\adist, 1, // Pfunc({ 0.75.rand }),
        \wform,Pfunc({1.0.rand}),
        // \attack, 0.04,
        \decay, 0.2,
        \width, Phprand(1.0, 4.0),
        \amp, 0.2,
        \out, 0 //Pseq([Ndef(\orb0).bus, 0, Ndef(\orb1).bus, 0, Ndef(\orb2).bus, 0, Ndef(\orb3).bus, 0], inf)
    )
);
);
Spec.add(\attack, [0.04,1]);
Spec.add(\acof, [50, 5000, \exp]);
Spec.add(\adist, [0,1]);
Spec.add(\arez, [0,0.7]);


Pdef(\acidFunk).set(\attack, 0.04, \acof, 200, \adist, 0.5, \arez, 0.5)

Pdef(\acidFunk).play(quant:4)

Pdef(\acidFunk).gui

Pdef(\test,
    Pbind()
);

Pdef(\test).play(quant:4)

s.latency = 0.3

(l, quant:4)

p = PmonoArtic(\acid3,
    \dur, 0.25,
    \legato, 0.125
).play(l, quant:4)

p.stop

Pdef(\acidFunk).gui
