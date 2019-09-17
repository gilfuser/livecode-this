q = q ? ();
{
    if (~dirt !== nil, { ~dirt.freeAllSoundFiles; ~dirt.stop; ~dirt.free });
    0.1.wait;
	~dirt = SuperDirt(2, s);
	s.sync;
    0.1.wait;
	~dirt.start(57120, 0!4);
	// ~dirt.start(57120, ([8, 10, 12, 14]));
	s.sync;
	0.1.wait;
	~dirt.loadSoundFiles("~/tidal-samples/*/*");
    s.sync;
    0.1.wait;
    ~dirt.loadSoundFiles("~/CAMPO/samples/*"); // your own samples directory
    s.sync;
	0.1.wait;
    ~dirt.loadSoundFiles("~/Trabalho/Flou/Airstrip/samples/*");
    s.sync;
	0.1.wait;
    "./synths/tidalInstruments.scd".asRelativePath.load;
	// if you are using SCNvim uncomment above and comment the line below: (more of those changes down)
    // "../synths/tidalInstruments*".loadRelative;
    0.1.wait;
	~dirt.loadSynthDefs("../synths/tidalInstruments.scd");
    s.sync;
	0.1.wait;
    // ~dirt.loadSynthDefs("../synths/vstInstr.scd");
	0.1.wait;

~dirt.orbits.do { |each i|
    Ndef( "orb%".format(i).asSymbol ).ar(~dirt.numChannels);
    each.outBus = Ndef( "orb%".format(i).asSymbol ).bus;
    Ndef( "orb%".format(i).asSymbol ).play;
};
	0.1.wait;
    ~dirt.loadSynthDefs("./crossorb-routing.scd");
    "interface/crossorb-routing.scd".asRelativePath.load;
    "FX/myTidalFx.scd".asRelativePath.load;
    // (
    //     Ndef(\allOrbs, { | speak0 = 1 speak1 = 1 speak2 = 1 speak3 = 1 |
    //     var in0 = InFeedback.ar(8,2) * speak0;
    //     var in1 = InFeedback.ar(10,2) * speak1;
    //     var in2 = InFeedback.ar(12,2) * speak2;
    //     var in3 = InFeedback.ar(14,2) * speak3;
    //     [OffsetOut.ar(0, in0 + in1 + in2 + in3)]
    // }).play;
    // );
    // Ndef(\allOrbs).addSpec(\speak0, [0, 1, \lin, 1, 1]);
    // Ndef(\allOrbs).addSpec(\speak1, [0, 1, \lin, 1, 1]);
    // Ndef(\allOrbs).addSpec(\speak2, [0, 1, \lin, 1, 1]);
    // Ndef(\allOrbs).addSpec(\speak3, [0, 1, \lin, 1, 1]);
    // {Ndef(\allOrbs).gui;}.defer;
	// ... and these
	// "../FX/myTidalFx.scd".loadRelative;
	" \n super-dirt prepared \n ".postln;
}.fork;
