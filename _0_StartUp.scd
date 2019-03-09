(
s.waitForBoot({
	q = q ? ();
	"globals/0_loadGlobalUtils.scd".loadRelative;
	0.1.wait;
	if(p == Ndef.dictFor(s) ) {p=nil} {p = Ndef.dictFor(s).quant_(4)};
	0.1.wait;
	"interface/superDirt_startup*".loadRelative;
	3.wait;
	"FX/vstPlugin*".loadRelative;
	30.wait;
	"FX/fxLib.scd".loadRelative;
	0.1.wait;
	"FX/FXXX_orbs*".loadRelative;
	0.5.wait;
	s.meter;
	"interface/tidal_set_FX*".loadRelative;
});
);