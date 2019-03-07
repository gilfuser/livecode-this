q = q ? ();
{
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
	"sync-to-tidal*".loadRelative;

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
	"../synths/tidalInstruments*".loadRelative;

	~dirt.loadSynthDefs("../synths/tidalInstruments*");

	1.wait; // wait for samples to be read
	"../FX/myTidalFx*".loadRelative;

	Ndef(\allOrbs, {
		var in = [ InFeedback.ar( [2, 4, 6, 8] ,1), InFeedback.ar( [3, 5, 7, 9] ,1) ];
		OffsetOut.ar(0, in)
	}).play;

	"super-dirt prepared".postln;
}.fork;



	/*(
		(
			 ~dirt.orbits.do { |x|
				//{
				var event = x.defaultParentEvent /*q.orb3*/;
				var pitchEvent = Event.partialEvents.pitchEvent.copy;
				[\freq, \midinote, \octave].do(event.removeAt(_));
				event.parent = pitchEvent;
				};
		);


		// if we want to pick scales and tunings by name
		// this works only when synths use \freq as argument
		(
			 ~dirt.orbits.do { |x|
			//{
				var event = x.defaultParentEvent;/*q.orb3*/
				var pitchEvent = Event.partialEvents.pitchEvent.copy;
				var scale, tuning;
				pitchEvent.use {
					~freq = {
						if(~note != 0) { ~degree = ~note }; // interpret n as note (might be also degree)
						~scaleName !? {
							scale = Scale.at(~scaleName);
							scale !? {
								~scale = scale;
								~tuningName !? {
									tuning = Tuning.at(~tuningName);
									tuning !? { ~scale = ~scale.copy; ~scale.tuning = tuning };
								}
							}
						};
						(~midinote.value + ~ctranspose).midicps * ~harmonic;
					};

					[\freq, \midinote, \octave].do(event.removeAt(_));

					event.parent = pitchEvent;
				}
			};
		)
	);*/