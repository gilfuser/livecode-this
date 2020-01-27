q = q ? ();
{
	// create a synchronized clock
	0.02.wait;
	l = LinkClock(1).latency_(Server.default.latency);

	l.tempo = 113/60;

    TempoClock.default.tempo = l.tempo;
	// GUI to watch status and change tempo
	{
		var win = Window("LinkClock", Rect(200, 200, 500, 60)).front,
		peersBox, tempoBox, barsBox, beatsBox,
		font = Font.default.copy.size_(18),
		boldFont = font.boldVariant,
		controller, task;

		win.layout = HLayout(
			StaticText().font_(font).string_("Peers:"),
			peersBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80),
			StaticText().font_(font).string_("Tempo:"),
			tempoBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(120),
			StaticText().font_(font).string_("Now:"),
			barsBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80),
			beatsBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80)
		);

		[peersBox, barsBox, beatsBox].do { |view| view.enabled_(false) };

		tempoBox.action = { |view| l.tempo = view.value / 60 };
		tempoBox.value = l.tempo * 60;
		peersBox.value = l.numPeers;

		task = Routine {
			var bars, beats;
			loop {
				bars = l.bar;
				beats = l.beatInBar;
				{
					barsBox.value = bars;
					beatsBox.value = beats;
				}.defer(l.latency);
				1.0.wait;
			}
		}.play(l, quant: 1);

		controller = SimpleController(l)
		.put(\tempo, {
			defer { tempoBox.value = l.tempo * 60 }
		})
		.put(\numPeers, {
			defer { peersBox.value = l.numPeers }
		})
		.put(\stop, { defer { win.close } });

		win.onClose = { task.stop; controller.remove };
	}.defer
}.fork

