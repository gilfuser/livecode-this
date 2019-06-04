
MFdef(\theHub).add(\post, {|msg| msg.postln});
/*
MFdef(\theHub).disable(\post);
MFdef(\theHub).enable(\post);
*/

	~dirt.stop;
    /*
    ~dirt.freeAllSoundFiles;
	*/
    0.1.wait;
	~dirt.free;
	0.1.wait;
	~dirt = SuperDirt(2, s);
	s.sync;
	~dirt.start(57120, ([2, 4, 6, 8]));
	s.sync;
	0.1.wait;
	~dirt.loadSoundFiles("~/CAMPO/samples/led9a9a");
    // ~dirt.loadSoundFiles("~/tidal-samples/*/*" );
	0.1.wait;

s.stop
