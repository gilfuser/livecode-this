(
SynthDef(\dummy, { |out, sustain = 1, speed = 1, begin = 0, end = 1, pan, accelerate, offset|
	var sound, rate, phase;
	phase = Line.ar(begin, end, sustain);
	rate = (begin + 1) * (speed + Sweep.kr(1, accelerate));
	sound = DC.ar(0);
	OffsetOut.ar(out,
		DirtPan.ar(sound, ~dirt.numChannels, pan)
	)
}).add
);

(
SynthDef(\click, { |out, sustain = 1, speed = 1, begin = 0, end = 1, pan, accelerate, offset|
	var sound, rate, phase;
	phase = Line.ar(begin, end, sustain);
	rate = (begin + 1) * (speed + Sweep.kr(1, accelerate));
	sound = Impulse.ar(0);
	sound = Decay.ar(sound, sustain);
	OffsetOut.ar(out,
		DirtPan.ar(sound, ~dirt.numChannels, pan)
	)
}).add
);

(
SynthDef(\stiff, { |out, sustain = 1, freq, amp=0.5, c3=20, pan, fB = 80, rel= 0.1, offset|

	var env = EnvGen.ar(Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]), timeScale:sustain);
	var inp = amp * LFClipNoise.ar(2000) * env;
	var sound = DWGPluckedStiff.ar(freq, amp, 1,0.14,1,c3,inp,rel,fB);  //here was the problem!... input, release, feedback

	DetectSilence.ar(sound, 0.001, doneAction:2);
	OffsetOut.ar(out,
		DirtPan.ar(sound * 0.1, ~dirt.numChannels, pan)
	)
}).add
);

/*(
SynthDef(\piano, { |out, sustain = 1, freq=440, /*gate, */ amp=0.5, rho=1, pan, offset|
var env = EnvGen.ar( Env.asr(0,1,0.1), /*gate, */ timeScale:sustain, doneAction:2 );
var sound = OteyPianoStrings.ar( freq, amp, rho:rho ) * env;
OffsetOut.ar(out,
DirtPan.ar(sound * 1, ~dirt.numChannels, LinLin.kr(freq,36.midicps,90.midicps,-0.75,0.75), env )
)
}).add;

{
SynthDef(\piano_soundboard,{
var audio = In.ar([20, 21], 2);
audio = OteySoundBoard.ar(audio);
Out.ar(0,audio);
}).add;
s.sync;
//start soundboard effect
Synth.tail(1,\piano_soundboard)
}.fork;
);*/


(
SynthDef(\atari, { | out, freq, freqb=550, freqc=660, vola=15, volb=0, volc=0, chink=1, wobbly=1, pan, amp=0.1, /*gate, */ sustain = 1, offset|
	var ay, chinkenv, wobblyenv, env;

	env = EnvGen.kr(Env.asr(0.01, 1, 0.05), /*gate, */ timeScale:sustain, doneAction:2);
	//chinkenv = if(chink>0, EnvGen.kr(Env.new([0.06125, 0.06125, 1, 1], [0.05, 0, 0.1], 0, 4, 4)), 1);
	chinkenv = if(chink>0, EnvGen.kr(Env.new([2, 2, 1, 1], [0.05, 0, 0.1], 0, 4, 4)), 1);
	wobblyenv = LFPulse.kr(10, 0.5, mul:wobbly).range(0.5, 1);

	# freq, freqb, freqc = [freq, freqb, freqc] * [1, wobblyenv, wobblyenv] * chinkenv;
	ay = AY.ar(AY.freqtotone(freq), AY.freqtotone(freqb), AY.freqtotone(freqc),
		0, 3, vola, volb, volc, mul: amp);
	// ay = ay * env;
	// Out.ar(0, Pan2.ar(ay, pan));
	OffsetOut.ar(out,
		DirtPan.ar(ay, ~dirt.numChannels, pan, env)
	)
}).add;
);

(
SynthDef(\bow, { |out, freq, amp=0.5, force=1, /*gate, */ pos=0.07, c1=0.25, c3=31, pan, offset/*, sustain = 0.1*/|
	var vib = Gendy1.kr(1,1,1,1,0.1, 4,mul:0.003,add:1);
	var son = DWGBowedTor.ar(freq*vib, amp,force, /*gate, */pos,0.1,c1,c3);
	son = DWGSoundBoard.ar(son);
	son = BPF.ar(son,118,1)+son;
	son = BPF.ar(son,430,1)+son;
	son = BPF.ar(son,490,1)+son;
	son = LPF.ar(son,6000);
	// Out.ar(out, Pan2.ar(son * 0.1, pan));
	OffsetOut.ar(out,
		DirtPan.ar(son * 0.1, ~dirt.numChannels, pan)
	)
}).add;
);

(
SynthDef(\windsaw, { | out, offset, sustain = 1, freq, attack = 0.1, release = 5, decay = 3, amp = 0.3, /*maxosc = 20, loosc = 6,*/ maxamp = 2.5, loamp = 0.1, gate = 1, pan, accelerate |
	var snd, env;
	env = Env.adsr(
		attackTime: attack,
		decayTime: decay,
		sustainLevel: 0.75,
		releaseTime: release,
		peakLevel: amp
	).kr(doneAction: 2, /*gate: gate, */ timeScale: sustain);
	snd = LFSaw.ar(
		freq: (freq*[2, 3, 4]/6) * Line.kr(1,accelerate+1, sustain);,
		mul: env /* * SinOsc.kr(freq: XLine.kr(maxosc, loosc, 5).range(maxamp, loamp))*/ );
	snd = snd + LFTri.ar(
		freq: freq * Line.kr(1,accelerate+1, sustain);,
		mul: env * SinOsc.kr(freq: LFTri.kr((sustain * 10).reciprocal, 3).exprange(loamp, maxamp)));
	snd = Splay.ar(snd);
	OffsetOut.ar(out,
		DirtPan.ar(snd, ~dirt.numChannels, pan, env)
	)
}).add;
);

(
SynthDef(\saw, { | freq, amp = 0.1, att = 0.001, rel = 0.2, lofreq = 1000, hifreq = 3000, out, offset, pan |
	var env, snd;
	env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp
	).kr(doneAction: 2);
	snd = Saw.ar(freq: freq * [0.99, 1, 1.001, 1.008], mul: env);
	snd = LPF.ar(
		in: snd,
		freq: LFNoise2.kr(1).range(lofreq, hifreq)
	);
	snd = Splay.ar(snd);
	OffsetOut.ar(out,
		DirtPan.ar(snd, ~dirt.numChannels, pan, env)
	)
}).add;
);

(
SynthDef(\bazz, { | freq, amp=0.01, attack = 0.025, decay = 0.6, release = 0.5, crunchy = 200, /*gate, */ out, pan, offset, sustain = 1 |
	var snd, env, snd2, sum;
	env = Env.adsr(
		attackTime: attack, decayTime: decay, sustainLevel: 0.5, releaseTime: release
	).kr(doneAction:2, timeScale:sustain/*, gate:gate*/);
	env = env/3;
	snd = LFSaw.ar(freq: SinOsc.kr(XLine.kr(7, 2, 1)).range(freq, freq/2), mul: env/2)
	+ LFSaw.ar(freq: freq, mul: env)
	+ LFTri.ar(freq: freq*[3], mul: env/2)
	+ SinOsc.ar(freq: freq*[2, 4, 6], mul: env);
	snd = LPF.ar(
		in: snd,
		freq: XLine.kr( 10000, crunchy, attack * 5 )
	);
	sum = snd;
	sum = Splay.ar(sum);
	OffsetOut.ar(out,
		DirtPan.ar(sum, ~dirt.numChannels, pan, env)
	)
}).add;
);

(
SynthDef(\rhodes, { | out freq pan vel = 0.8 modind = 0.2 mix = 0.2 lfospeed = 0.4 lfodepth = 0.1 sustain = 1 gate = 1 |
    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;
    lfospeed = lfospeed * 12;
    freq = freq * 2;
    env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
    env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
    env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
    env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
    osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modind * env4 * vel;
    osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
    osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
    osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
    snd = snd * (SinOsc.ar(lfospeed) * lfodepth + 1);
    // using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
    snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
    snd = Pan2.ar(snd, pan);
    OffsetOut.ar(out,
		DirtPan.ar(snd, ~dirt.numChannels, pan)
	)
}).add;
);
