(
s.waitForBoot({
	q = q ? ();
	/*
	"interface/superDirt_startup.scd".loadRelative;
	*/
	// if you are using SCNvim change loadRelative to load, like this:
    "interface/superDirt_startup.scd".load;
	8.wait;
	// "FX/vstPlugin.scd".loadRelative;
    // "interface/link.scd".load;
    // 0.2.wait;
	"FX/vstPluginFX.scd".load;
	10.wait;
	"synths/vstInstr.scd".load;
	8.wait;
	/*
	"FX/fxLib.scd".loadRelative;
	*/
	"FX/fxLib.scd".load;
	1.wait;
	/*
	"FX/FXXX_orbs.scd".loadRelative;
	*/
	"FX/FXXX_orbs.scd".load;
	0.1.wait;
	s.meter;
	/*
	"interface/tidal_set_FX.scd".loadRelative;
	*/
	"interface/tidal_set_FX.scd".load;
    // 0.1.wait;
    // "interface/mpk-Modality.scd".load;
    // 0.2.wait;
    // "interface/midi_LoopStation.scd".load;
});
);

/*
r = Recorder(s);
r.record; //("/media/gilfuser/TOSHIBA EXT/TRABALHO/Flou/AirStrip/Recordings/Airstrip_drums5.aiff");
r.stopRecording;
s.meter;
s.boot;
s.quit;
*/
