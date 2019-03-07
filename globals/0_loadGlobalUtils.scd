// RUN this entire file from elsewhere to have convenience functions //

q = q ? ();

// helpful things to find all the files in this setup folder:
q.utilDir = thisProcess.nowExecutingPath.dirname;
q.topDir = q.utilDir.dirname;
q.fulldirnames = (q.topDir +/+ "*/").pathMatch;
q.dirnames = q.fulldirnames.collect { |path| path.basename };

"/// q.topDir: %\n".postf(q.topDir);
"/// q.dirnames: ".postln;
q.dirnames.printAll;

q.warnWin = { |q, string="?!?", title="?!?"|
	var w = Window("Warning: %".format(title)).front.alwaysOnTop_(true);
	var tv = StaticText(w, w.view.bounds);
	tv.background_(Color(1, 0.75));
	tv.align_(\center);
	w.alpha_(0.9);
	tv.string_(string).font_(Font("Arial", 24));
};

// limit to sounding ndefs  // commented
q.getNdefs = { Ndef.dictFor(s).envir.select({ |ndef| ndef.rate == \audio }).asArray.sort { |px1, px2| px1.key < px2.key } };
q.getCtrNdefs = { Ndef.dictFor(s).envir.select({ |ndef| ndef.rate == \control }).asArray.sort { |px1, px2| px1.key < px2.key } };
q.getTdefs = { Tdef.all.values.asArray.sort { |px1, px2| px1.key < px2.key } };
q.getPdefs = { Pdef.all.values.asArray.sort { |px1, px2| px1.key < px2.key } };

q.getInfluxDestins = {
	// automagically attach all existing proxies to GUI Buttons. (max. 5 for now..)
	q.getNdefs ++ q.getTdefs ++ q.getPdefs
};

"global utils loaded".postln; // dont post q
