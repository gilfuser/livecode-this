{

	[ Ndef(\orb0), Ndef(\orb2) ].do(_.addSpec(
        // [> orbx -<] \redir, [0, 4, \lin, 1, 1],
		// [> tape --<] \trate, [ 0.125, 4, \lin, 0.125, 0.25 ],  \tphase, [ 0, 2], \toffset, [0, 1],
		//              \tdepth, [0, 1],
		// [> wah ---<] \wrate,  [0, 10, \lin],  \depth, [0, 1], \jdepth, [0, 1], \jfreq, [0.1, 10, \exp],
		//              \sinsaw, [0, 1, \lin, 1, 0],  \ggain, [0.001, 1, \lin[>\amp<]],\wring, [0.001, 1, \exp],
		/* comp --*/ \cctrl, [0, 3, \lin, 1, 1], \thresh, [-60.dbamp, 1, \amp], \slopea, [0.05, 1],
		             \clamp, [0.002, 0.4], \relax, [0.005, 2], \deltas, [0, 4, \lin, 1, 4],
		/* ampFin */ \limDrive, \ampx4,  \ampLimit, \amp,  \postAmp, \ampx4,
		\cps, [0.1,1], \delta, [0.01, 10],
	) );

	[ Ndef(\orb1), Ndef(\orb3) ].do(_.addSpec(
        // [> orbx -<] \redir, [0, 4, \lin, 1, 1],
		// [> pitch -<] \pideg,  [-12, 12, \lin, 1],  \pdisp,  [0, 0.5],  \tdisp, [0, 1],  \slide, [0.02, 2],
		// [> llfo --<] \lrate, [ 0, 16, \lin, 0.125, 1 ],  \hifreq, [200, 20000, \exp, 0, 20000],
		//              \lwidth, [ 0, 1 ], \sisap, [0, 2, \lin,1, 1],  \iphase, [ 0.001, 1, \exp, 0, 0.5 ],
		//              \offtime, [0.16, 16],  \sphase, [0.16, 16],
		/* comp --*/ \cctrl, [0, 3, \lin, 1, 1], \thresh, [-60.dbamp, 1, \amp], \slopea, [0.05, 1],
		             \clamp, [0.002, 0.4], \relax, [0.005, 2], \deltas, [0, 4, \lin, 1, 4],
		/* ampFin */ \limDrive, \ampx4,  \ampLimit, \amp,  \postAmp, \ampx4,
		\cps, [0.1,1], \delta, [0.01, 10],
	) );

	0.1.wait;

    (
        q.fx.orb0 = ProxyChain.from( Ndef(\orb0),
            [ /* 'orbx', 'tape','wah',  */'comp', 'ampFin' ]
        );
        q.fx.orb1 = ProxyChain.from( Ndef(\orb1),
            [ /* 'orbx', 'pitch', 'llfo', */ 'comp', 'ampFin' ]
        );
        q.fx.orb2 = ProxyChain.from( Ndef(\orb2),
            [ /* 'orbx', 'tape', 'wah', */ 'comp', 'ampFin' ]
        );
        q.fx.orb3 = ProxyChain.from( Ndef(\orb3),
            [ /* 'orbx', 'pitch', 'llfo', */ 'comp', 'ampFin' ]
        );
    );

	0.1.wait;

	[ Ndef(\orb0), Ndef(\orb2) ].do(_.set(
        // [> orbx <] \redir, 4,
		// [> tape <] \trate, 0.25, \tphase, 0, \tdepth, 0.5, \toffset, 0.5,
		// [> wah <] \wrate, 1, \depth, 0.75, \sinsaw, 0, \jdepth, 0.1, \jfreq, 1,
		/* comp */ \cctrl, 0, \thresh, 0.5, \slopea, 0.5, \clamp, 0.02, \relax, 0.2, \deltas, 4,
		/* ampFin */ \wet50, 1, \limDrive, 1, \ampLimit, 1, \postAmp, 1,
		\cps, 1,
	) );

	[ Ndef(\orb1), Ndef(\orb3) ].do(_.set(
        // [> orbx <] \redir, 4,
        // [> pitch <] \pideg, 0, \pdisp, 0.02, \tdisp, 0.5, \slide, 0.2,
		// [> llfo <] \lrate, 0, \iphase, 0.5, \lwidth, 0.5, \sisap, 0, \midfreq, 60, \hifreq, 20000,
		/* comp */ \cctrl, 1, \thresh, 0.5, \slopea, 0.5, \clamp, 0.02, \relax, 0.2, \deltas, 4,
		/* ampFin */ \wet50, 1, \limDrive, 1, \ampLimit, 1, \postAmp, 1,
		\cps, 1,
	) );
    0.1.wait;

	Ndef(\orb2).set(
        // [> tape <] \trate, 0.5, \tphase, 0, \tdepth, 0.25, \toffset, 0.5,
		/* comp */ \cctrl, 2, \thresh, -60.dbamp, \slopea, 0.1, \clamp, 0.002, \relax, 0.5,
	);

    Ndef(\orb3).set(
        /* comp */ \cctrl, 3, \thresh, 0.33, \slopea, 0.33, \cctrl, 3, \clamp, 0.02, \relax, 0.2,
    );
	0.1.wait;
	(
	// q.fx.orb0.remove(\tape)
		[ /* 'orbx', 'tape', 'wah', */ 'comp', 'ampFin' ].do(
			{ |i| q.fx.orb0.add(i); q.fx.orb2.add(i) }
		);
		[ /* 'orbx', 'pitch', 'llfo', */'comp',  'ampFin' ].do(
			{ |i| q.fx.orb1.add(i); q.fx.orb3.add(i);}
		);
	);
	// q.fx.orb0.add('tape', 0.2);
	/*
	[q.fx.orb0, q.fx.orb1, q.fx.orb2, q.fx.orb3].do{|i| i.add('hole', 0)};
	*/

	//////////////////////////////////////////////////////////////////////

	// q.fxDir = thisProcess.nowExecutingPath.dirname;
	0.1.wait;
	(
		{
			// var fxDir = thisProcess.nowExecutingPath.dirname

            q.guiOrb0 = q.fx.orb0.gui(14).moveTo(0, 570);
			q.guiOrb1 = q.fx.orb1.gui(14).moveTo(500, 570);
            q.guiOrb2 = q.fx.orb2.gui(14).moveTo(1000, 570);
            q.guiOrb3 = q.fx.orb3.gui(14).moveTo(1500, 570);

			// q.guiOrb4 = q.fx.orb4.gui(8).moveTo(0, 0);
			q.o0Pset = NdefPreset( Ndef(\orb0) );
            /* q.o0Pset.namesToStore */
            // add the current state of the envir as a setting
            // q.o0Pset.addSet(\lfoOpened);

            // q.o0Pset.xfadeTo(\lfoClosed, 16);
			/*
			q.o0Pset.loadSettings( q.fxDir ++ "/orb0.pxpreset.scd");
			q.o0PsetGui = NdefPresetGui(q.o0Pset, 40).moveTo(0, 570);*/

			q.o1Pset = NdefPreset( Ndef(\orb1) );
			/*
			q.o1Pset.loadSettings( q.fxDir ++ "/orb1.pxpreset.scd");
			q.o1PsetGui = NdefPresetGui(q.o1Pset, 40).moveTo(500, 570);
			*/

			q.o2Pset = NdefPreset( Ndef(\orb2) );
			/*
			q.o2Pset.loadSettings( q.fxDir ++ "/orb2.pxpreset.scd");
			q.o2PsetGui = NdefPresetGui(q.o2Pset, 40).moveTo(1000, 570);
			*/

			q.o3Pset = NdefPreset( Ndef(\orb3) );
			/*
			q.o3Pset.loadSettings( q.fxDir ++ "/orb3.pxpreset.scd");
			q.o3Psetgui = NdefPresetGui(q.o3Pset, 40).moveTo(1500, 570);
			*/

		}.defer;
	);

}.fork;
