// this is an always-changing file. Adapt it for your own use
{

    (
		q.orb0 = ProxyChain.from( Ndef(\orb0),  [ 'tape', 'modelay', 'wah' ] );
        q.orb1 = ProxyChain.from( Ndef(\orb1),  [ 'tape', 'llfo' ] );
        q.orb2 = ProxyChain.from( Ndef(\orb2),  [ 'wah', 'compT' ] );
        q.orb3 = ProxyChain.from( Ndef(\orb3),  [ 'llfo', 'compT' ] );
    );

    [ q.orb0.proxy, q.orb1.proxy, q.orb2.proxy, q.orb3.proxy ].do( _.fadeTime_(0.2) );

	0.1.wait;

	q.orb0.set(
		/*modelay*/ \mdfb, 0.5, \mdtime, 1, \mdtimel, 1.5, \mdtimer, 1, \mdlock, 0, \cps, 1, \mdff, 800, \mdfq, 3, \mdamp, 1,
		/* tape */ \trate, 0.5, \tphase, 0, \tdepth, 0.25, \toffset, 0.5, \cps, 1,
		/* wah ---*/ \wrate, 1, \wdepth, 0.5, \sinsaw, 0, \wphase, 0, \jrate, 1, \jdepth, 0
	);

	q.orb1.set(
		/* tape */ \trate, 0.5, \tphase, 0, \tdepth, 0.25, \toffset, 0.5, \cps, 1,
		/* llfo --*/ \lrate, 0, \iphase, 0.5, \lwidth, 0.5, \sisap, 0, \midfreq, 60, \hifreq, 20000, \cps, 1
	);

	q.orb2.set(
		/* wah ---*/ \wrate, 1, \wdepth, 0.5, \sinsaw, 0, \wphase, 0, \jrate, 1, \jdepth, 0,
        /* comp --*/ \cctrl, 1, \thresh, 0.5, \slopea, 0.5, \clamp, 0.02, \relax, 0.2, \deltas, 4,
	);

	q.orb3.set(
		/* llfo --*/ \lrate, 0, \iphase, 0.5, \lwidth, 0.5, \sisap, 0, \midfreq, 60, \hifreq, 20000, \cps, 1,
        /* comp --*/ \cctrl, 1, \thresh, 0.5, \slopea, 0.5, \clamp, 0.02, \relax, 0.2, \deltas, 4,
	);

    0.2.wait;
	[ q.orb0, q.orb1 ].do(_.add(\tape));
	q.orb0.add(\modelay);
	[ q.orb0, q.orb2 ].do(_.add(\wah));
	[ q.orb1, q.orb3 ].do(_.add(\llfo));
	[ q.orb2, q.orb3 ].do(_.add(\compT));

	//////////////////////////////////////////////////////////////////////

	// q.dir = thisProcess.nowExecutingPath.dirname;
	0.2.wait;
	(
		{
            q.guiOrb0 = q.orb0.gui(24).moveTo(0, 570);
            q.guiOrb1 = q.orb1.gui(24).moveTo(500, 570);
            q.guiOrb2 = q.orb2.gui(24).moveTo(1000, 570);
            q.guiOrb3 = q.orb3.gui(24).moveTo(1500, 570);

			// q.guiOrb4 = q.orb4.gui(8).moveTo(0, 0);
			q.o0Pset = NdefPreset( q.orb0.proxy );
            /* q.o0Pset.namesToStore */
            // add the current state of the envir as a setting
            // q.o0Pset.addSet(\lfoOpened);

            // q.o0Pset.xfadeTo(\lfoClosed, 16);
			/*
			q.o0Pset.loadSettings( q.ir ++ "/orb0.pxpreset.scd");
			q.o0PsetGui = NdefPresetGui(q.o0Pset, 40).moveTo(0, 570);
			*/

			q.o1Pset = NdefPreset( q.orb1.proxy );
			/*
			q.o1Pset.loadSettings( q.ir ++ "/orb1.pxpreset.scd");
			q.o1PsetGui = NdefPresetGui(q.o1Pset, 40).moveTo(500, 570);
			*/

			q.o2Pset = NdefPreset( q.orb2.proxy );

			/*
			q.o2Pset.loadSettings( q.ir ++ "/orb2.pxpreset.scd");
			q.o2PsetGui = NdefPresetGui(q.o2Pset, 40).moveTo(1000, 570);
			*/

			q.o3Pset = NdefPreset( q.orb3.proxy );

			/*
			q.o3Pset.loadSettings( q.ir ++ "/orb3.pxpreset.scd");
			q.o3Psetgui = NdefPresetGui(q.o3Pset, 40).moveTo(1500, 570);
			*/

		}.defer;
	);

" \n PxChain > Orbs - LOADED \n".postln;
}.fork;

