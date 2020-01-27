q = q ? ();

{
	q.mixHpf = ProxySubmix(\mixHpf);
	q.mixHpf.ar(s.options.numOutputBusChannels);

	q.mixHpf.addMix( q.orb0.proxy );
	q.mixHpf.addMix( q.orb2.proxy );
	// q.mixHpf.play;
	q.mixHpf.addLevel;
	q.mixHpf.play;
	// Ndef(\submix).ar(s.options.numOutputBusChannels);
	// Ndef(\subMixHpf, {q.mixHpf});

	q.subHpf = ProxyChain.from( q.mixHpf, [\hpf] );
	// q.submix.slotNames = [\hpf, \verb];
	// q.submix.add(\verb,1);
	q.subHpf.add(\hpf, 1);
	// q.submix.add(\verbPan, 1);

	{q.subHpf.gui(9).moveTo(0,0)}.defer;

	q.mixHpf.set('lev_ALL', 1.0, 'snd_orb0', 0.25, 'fadeTime', 0.2, 'snd_orb1', 0.4, 'snd_orb2', 0.4, 'snd_orb3', 0.25);

	0.2.wait;

	/*q.mixVerb = ProxySubmix(\mixVerb);
	q.mixVerb.ar(s.options.numOutputBusChannels);

	q.mixVerb.addMix( q.orb0.proxy );
	q.mixVerb.addMix( q.orb1.proxy );
	q.mixVerb.addMix( q.orb2.proxy );
	q.mixVerb.addMix( q.orb3.proxy );
	// q.mixHpf.play;
	q.mixVerb.addLevel;
	q.mixVerb.play;
	// Ndef(\submix).ar(s.options.numOutputBusChannels);
	// Ndef(\subMixHpf, {q.mixHpf});

	q.subVerb = ProxyChain.from( q.mixVerb, [\verb] );
	// q.submix.slotNames = [\hpf, \verb];
	// q.submix.add(\verb,1);
	q.subVerb.add(\verb, 1);
	// q.submix.add(\verbPan, 1);

	{q.subVerb.gui(9)}.defer;

	q.mixVerb.set('lev_ALL', 1.0, 'snd_orb0', 0.25, 'fadeTime', 0.2, 'snd_orb1', 0.4, 'snd_orb2', 0.4, 'snd_orb3', 0.25);*/


	" \n SubMix - LOADED \n".postln;

}.fork;
