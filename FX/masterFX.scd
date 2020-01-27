q = q ? ();
{
	(
		// MasterFX.clear('localhost')
		// The order in slotNames determines order of execution of the efx.

		q.masta = MasterFX.new(server: s,
			numChannels: s.options.numOutputBusChannels,
			slotNames: [\leakDC, \ampFin],
			busIndex: 0
		);
		q.masta.add(\leakDC, 1);
		q.masta.add(\ampFin, 1);  // limit output
		{q.mastaGui = q.masta.gui('Masta!', 10)}.defer;
		{s.scope(s.options.numOutputBusChannels)}.defer;
	);

	" \n Master FX - LOADED \n".postln;

}.fork;
