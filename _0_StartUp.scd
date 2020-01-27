s.waitForBoot({
	q = q ? ();
    "bridge/superDirt_startup.scd".asRelativePath.load;
    // if you are using SC IDE change the above, and whenever you find a
    // "load" adding the folder within the file is:
    // "livecode-this/bridge/superDirt_startup.scd".asRelativePath.load;
    8.wait;
	// share clock through Esp Grid

    Esp.person = Esp.person ? "skmecs";
	"xfce4-terminal -e /usr/local/bin/espgridd".unixCmd;
	1.wait;
	TempoClock.default = EspClock.new;
    0.2.wait;
	t = TempoClock.default;
    0.2.wait;
	t.start;
	t.tempo = 110/60/4;
    q.tempo =  q.tempo ?? Bus.control(s, 1).set(t.tempo);
	Esp.clockAdjust = -0.1; // slide synced tempo/metre backward/forward in time

	"xfce4-terminal -e /usr/local/bin/tidalvim".unixCmd;
	// share clock with Ableton Link compatible applications
	/* "xfce4-terminal -e ~/builds/carabiner/build/bin/Carabiner".unixCmd;
	1.wait;
	"bridge/link.scd".load;
	1.wait; */

    "FX/fxLib.scd".asRelativePath.load;
	1.wait;
    "FX/FXXX_orbs.scd".asRelativePath.load;
	1.wait;
	"FX/masterFX.scd".asRelativePath.load;
	1.wait;
	"FX/subMix.scd".asRelativePath.load;
	2.wait;
	"vst_fxs/vst_verbs.scd".asRelativePath.load;
	8.wait;
	"vsti/vst_ABL3.scd".asRelativePath.load;
	10.wait;
	s.meter;
	"bridge/tidal_set_FX.scd".asRelativePath.load;
    "/usr/bin/carla".unixCmd;
});
);

/*(
q.scale = Scale.at(\lydianMinor);
q.scale = Scale.choose(7, 12).tuning_(Tuning.choose(12))
);
q.scale.ratios;
q.scale.tuning;*/

/*
r = Recorder(s);
r.record
("/media/skmecs/TOSHIBA EXT/TRABALHO/CAMPO/Recordings/2019-10-01_CAMPO-pedras.aiff");
r.stopRecording;
t.start;
s.boot;
s.quit;
s.meter;
*/
