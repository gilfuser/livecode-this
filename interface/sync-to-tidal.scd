(
var quant = 1.0;
~dirt.receiveAction = { |e|
	var cycle = e[\cycle];
	var cps = e[\cps];
	var latency = e[\latency];
	cycle !? {
		if(cycle % quant == 0) { // set clock only quant in cycle
			TempoClock.default.beats = cycle;
		};
	};
	cps !? {
		TempoClock.default.tempo = cps;
	};
	latency !? {
		Server.default.latency = latency;
	}
};
)