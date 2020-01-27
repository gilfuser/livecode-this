q = q ? ();
{
    if (~dirt !== nil, { ~dirt.freeAllSoundFiles; ~dirt.stop; ~dirt.free });
    0.2.wait;
	~dirt = SuperDirt(s.options.numOutputBusChannels, s);
	s.sync;
    0.2.wait;
	~dirt.start(57120, 0!4);
	// ~dirt.start(57120, ([(~dirt.numChannels), (~dirt.numChannels * 2), (~dirt.numChannels * 3), (~dirt.numChannels * 4)]));
	s.sync;
	0.2.wait;
	~dirt.loadSoundFiles("~/tidal-samples/*/*");
    s.sync;
    0.3.wait;
    ~dirt.loadSoundFiles("~/CAMPO/samples/*"); // your own samples directory
    s.sync;
	0.3.wait;
	// ~dirt.loadSoundFiles("~/Trabalho/Flou/Airstrip/samples/*");
	// 0.4.wait;
	"synths/tidalInstruments.scd".asRelativePath.load;
    /*
    */
	// s.sync;
	0.3.wait;
	~dirt.loadSynthDefs("../synths/tidalInstruments.scd");
	0.4.wait;

	Ndef(\orb0).ar(~dirt.numChannels);
	Ndef(\orb1).ar(~dirt.numChannels);
	Ndef(\orb2).ar(~dirt.numChannels);
	Ndef(\orb3).ar(~dirt.numChannels);
	0.2.wait;
	~dirt.orbits[0].outBus = Ndef(\orb0).bus;
	~dirt.orbits[1].outBus = Ndef(\orb1).bus;
	~dirt.orbits[2].outBus = Ndef(\orb2).bus;
	~dirt.orbits[3].outBus = Ndef(\orb3).bus;
	0.2.wait;
	Ndef(\orb0).play; //(~dirt.numChannels);
	Ndef(\orb1).play; //(~dirt.numChannels * 2);
	Ndef(\orb2).play; //(~dirt.numChannels * 3);
	Ndef(\orb3).play; //(~dirt.numChannels * 4);
	0.2.wait;

	// "crossorb-routing.scd".loadRelative;
    ~dirt.loadSynthDefs("./crossorb-routing.scd");
	// "../interface/crossorb-routing.scd".asRelativePath.load;
    "FX/myTidalFx.scd".asRelativePath.load;

    // foward OSC from TidalCycles to OpenFrameworks
    q.addr = NetAddr.new("127.0.0.1", 3333);
    OSCdef(\toOF, { |msg, time, tidalAddr|
        var latency = time - Main.elapsedTime;
        msg = msg ++ ["time", time, "latency", latency];
        // msg.postln;
        q.addr.sendBundle(latency, msg)
    }, '/play2');
	// OSCdef(\toOF).free

"\n SuperDirt - LOADED \n ".postln;
}.fork;
