(
s.waitForBoot({
	q = q ? ();
	if(p == Ndef.dictFor(s) ) {p=nil} {p = Ndef.dictFor(s).quant_(4)};
	0.1.wait;
	"interface/superDirt_startup.scd".load; // this will load "synths/tidalInstruments.scd" and myTidalFx.scd
	10.wait;
	"FX/vstPlugin.scd".load;
    // s.sync;
	30.wait;
	"FX/fxLib.scd".load;
	0.1.wait;
	"FX/FXXX_orbs.scd".load;
	0.5.wait;
	s.meter;
	"interface/tidal_set_FX.scd".load;
});
);

s.meter;

s.boot;

s.quit;

r = Recorder(s)

.numChannels_(10);

r.record

r.record("/media/gilfuser/TOSHIBA EXT/TRABALHO/CAMPO/Recordings/2019-05-25_SescInterL.aiff", numChannels:2)

r.stopRecording

().play
