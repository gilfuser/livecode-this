(
var busses = ~dirt.orbits.collect { |x| x.dryBus };

SynthDef(\xorb, { |out, amp = 1, n = 0| // number
	var bus, sound;

	bus = Select.kr(n, busses);
	sound = In.ar(bus, ~dirt.numChannels);

	Out.ar(out,
		sound * (amp * 2.5)
	)
}).add;
)
