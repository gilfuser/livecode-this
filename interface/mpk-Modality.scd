// ************ check if anything is coming, and note the sending address ************
/*
(
f = { |msg, time, addr|
	if( (msg[0] != '/status.reply') &&
		(msg[0] != '/localhostInLevels') &&
		(msg[0] != '/localhostOutLevels') &&
		(msg[0] != '/n_end') &&
		(msg[0] != '/n_go') &&
		(msg[0] != '/done') &&
		(msg[0] != '/synced') &&
		(msg[0] != '/n_move') &&
		(msg[0] != '/n_off') &&
		(msg[0] != '/n_on') &&
		(msg[0] != '/d_removed') &&
		(msg[0] != '/play2') &&
		(msg[0] != '/esp/tempo/r') &&
		(msg[0] != '/esp/person/r') &&
		(msg[0] != '/esp/broadcast/r') &&
		(msg[0] != '/esp/version/r') &&
		(msg[0] != '/esp/clockMode/r') &&
		(msg[0] != '/recordingDuration')
	) {
		"time: % sender: %\nmessage: %\n".postf(time, addr, msg);
} }; thisProcess.addOSCRecvFunc(f);
);
thisProcess.removeOSCRecvFunc(f);   // ******************** stop posting ****************************
*/

/*
m.reload
*/
{
    q = q ? ();
	MKtl.find(\midi);
	s.sync;
	m = MKtl(\mpk, "my-complete-mpkmini2");
	s.sync;

	// m.rebuild("my-akai-mpkmini2"); // this won't work
	// m.gui;
    m.trace(false);
	// m.gui;

	// Elements Groups Naming __________________________________________________________________

	q.mpkGroup = m.elementGroup;
	q.piano = q.mpkGroup.elAt(\p0, \pkey);
	q.pad = q.mpkGroup.elAt(\p0, \pad);
	q.btn = q.mpkGroup.elAt(\p0, \bt);
	q.knobs = q.mpkGroup.elAt(\p0, \kn);

	s.sync;
	// make initial shorter names
	~allNotes = [
		"df0", "d0", "ef0", "e0", "f0", "gf0", "g0", "af0", "a0", "bf0", "b0", "c0",
		"df1", "d1", "ef1", "e1", "f1", "gf1", "g1", "af1", "a1", "bf1", "b1", "c1",
		"df2", "d2", "ef2", "e2", "f2", "gf2", "g2", "af2", "a2", "bf2", "b2", "c2",
		"df3", "d3", "ef3", "e3", "f3", "gf3", "g3", "af3", "a3", "bf3", "b3", "c3",
		"df4", "d4", "ef4", "e4", "f4", "gf4", "g4", "af4", "a4", "bf4", "b4", "c4",
		"cs5", "d5", "ds5", "e5", "f5", "fs5", "g5", "gs5", "a5", "as5", "b5", "c5",
		"cs6", "d6", "ds6", "e6", "f6", "fs6", "g6", "gs6", "a6", "as6", "b6", "c6",
		"cs7", "d7", "ds7", "e7", "f7", "fs7", "g7", "gs7", "a7", "as7", "b7", "c7",
		"cs8", "d8", "ds8", "e8", "f8", "fs8", "g8", "gs8", "a8", "as8", "b8", "c8",
		"cs9", "d9", "ds9", "e9", "f9", "fs9", "g9", "gs9", "a9", "as9", "b9", "c9",
	];
	q.piano.do {|el, i| m.addNamed((~allNotes.at(i)).asSymbol, el ) };
	q.pad.do { |el, i| m.addNamed("pad%".format(i+1).asSymbol, el ) };
	q.btn.do { |el, i| m.addNamed("bt%".format(i+1).asSymbol, el ) };
	q.knobs.do { |el, i| m.addNamed("kn%".format(i+1).asSymbol, el ) };
	s.sync;
	~tidalSocket = NetAddr("127.0.0.1", 6010);
	g = nil;
	q.rhodes = NPVoicer(Ndef(\rhodes));
	q.rhodes.play;
	// NdefMixer(s);
	Ndef(\rhodes).quant_(0);
	q.rhodes.prime(\rhodes);

	/*
    q.test = NPVoicer(Ndef(\test)); // make an NPVoicer with an Ndef in it
	q.test.play;
    Ndef(\test).quant_(0);
    q.test.prime(\stiff);
    */

	// pkeys at note on
	(
		~notes = [];
		~add_notes = "";

		~onAction = {|el|
			var note = el.elemDesc.midiNum; // "on: %\n".postf(note);
			// q.rhodes.put(note, [\freq, note.midicps, \vel, el.value.squared, \amp, el.value.squared]);
			q.rhodes.put(note, [\freq, note.midicps, \vel, el.value.squared, \amp, el.value.squared]);
			// el.value.squared.clip(0, 1.0).postln;
			~notes = ~notes.add(note);
			~add_notes = ~add_notes + ~notes;
			// ~notes.postln;
			~tidalSocket.sendMsg('/ctrl', "notes", (~notes - 60).asString);
		};
		q.piano.elAt(\all, \on).do(_.action_(~onAction));

		// and noteOff
		~offAction = {|el|
			var note = el.elemDesc.midiNum;
			~notes.remove(note);
			// q.rhodes.release(note, 0.2);
			q.rhodes.release(note, 0.2);
			// ~notes.postln;
			~add_notes = ~add_notes + ~notes;
			~tidalSocket.sendMsg('/ctrl', "notes", (~notes - 60).asString);
		};
		q.piano.elAt(\all, \off).do(_.action_(~offAction));
	);

/*
// bending
m.elAt(\p0, \bX ).action_{|el|
	Ndef(\rhodes).set(\bendFac, el.value.lag(0.4));
};

m.elAt(\kn1).action_{|el|
		//el.value.postln
		Ndef(\rhodes).set(\distort, el.value.linlin(0,1,0.1,2));
		// Ndef(\test).set(\c3, el.value.linlin(0,1,1,1400));
};
m.elAt(\kn2).action_{|el|
		//el.value.postln
		Ndef(\rhodes).set(\fold, el.value.linlin(0,1,0.01,2));
};
Spec.add(\fold, [0.01, 2]);
*/
}.fork;

// convert into this form to send gain together with notes
// ngain "[0:0.4, 5:0.6, 8:0.8, 12:1]"
