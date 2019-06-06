(
s.waitForBoot({
	q = q ? ();
	// this will load "synths/tidalInstruments.scd" and FX/myTidalFx.scd:
	"interface/superDirt_startup.scd".loadRelative;
	// if you are using SCNvim change loadRelative to load, like this:
	// "interface/superDirt_startup.scd".load;
	10.wait;
	"FX/vstPlugin.scd".loadRelative;
    // s.sync;
	30.wait;
	"FX/fxLib.scd".loadRelative;
	0.1.wait;
	"FX/FXXX_orbs.scd".loadRelative;
	0.5.wait;
	s.meter;
	"interface/tidal_set_FX.scd".loadRelative;
});
);
