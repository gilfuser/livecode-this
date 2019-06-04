q = q ? ();
{
	~dirt.stop;
    /*
    ~dirt.freeAllSoundFiles;
	*/
    0.1.wait;
	~dirt.free;
	0.1.wait;
	~dirt = SuperDirt(2, s);
	s.sync;
	~dirt.start(57120, 0!4);
	s.sync;
	0.1.wait;
	~dirt.loadSoundFiles; //("~/CAMPO/samples/*"); // your own samples directory
	0.1.wait;

	// "./synths/tidalInstruments.scd".asRelativePath.load;
	// if you are using SCNvim uncomment above and comment the line below: (more of those changes down)
    "../synths/tidalInstruments*".loadRelative;

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

	q.orb0.outBus = Ndef(\orb0).bus;
	q.orb1.outBus = Ndef(\orb1).bus;
	q.orb2.outBus = Ndef(\orb2).bus;
	q.orb3.outBus = Ndef(\orb3).bus;
	0.1.wait;

	Ndef(\orb0).play;
	Ndef(\orb1).play;
	Ndef(\orb2).play;
	Ndef(\orb3).play;

	1.wait;

	// "../synths/tidalInstruments.scd".asRelativePath.load;
	// SCNvim users: swap these lines above and below too ...
	"../synths/tidalInstruments*".loadRelative;

	~dirt.loadSynthDefs("../synths/tidalInstruments.scd");

	0.2.wait;

	// "FX/myTidalFx.scd".asRelativePath.load;
	// ... and these
	"../FX/myTidalFx.scd".loadRelative;

	"super-dirt prepared".postln;
}.fork;

