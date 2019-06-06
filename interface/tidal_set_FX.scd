(
OSCdef(\oscFromTidal, { |msg|
	MFdef(\theHub).value(msg);
}, '/play2').permanent_(true)
);

/*
MFdef(\theHub).add(\post, {|msg| msg.postln});
MFdef(\theHub).enable(\post);
MFdef(\theHub).disable(\post);
*/

q.orbz = Ndef(\orb0);
q.vstorb = 0;
q.verbs = [~verbOrb0, ~verbOrb1, ~verbOrb2, ~verbOrb3];

MFdef(\theHub).add(\setOrb,
	{ |msg|
		var orbz;
		if ( ( msg.indexOf( \orbit ).notNil ) and: ( orbz != q.orbz ) ) {
			q.orbz = Ndef( "orb%".format( msg.at( msg.indexOf( \orbit ).asInteger + 1 ) ).asSymbol );
			orbz = q.orbz;
			// q.orbz.postln;
		};
	}
);
MFdef(\theHub).add(\setVst,
	{ |msg|
		var vstorbz;
		if ( ( msg.indexOf( \orbit ).notNil ) and: ( vstorbz != q.vstorb ) ) {
			q.vstorb = msg.at( msg.indexOf( \orbit ).asInteger + 1 );
			vstorbz = q.vstorb;
		};
	}
);
(
MFdef(\theHub).add( \tidalSetOrbs,
	{ |msg|
		msg.collect { |key, i|
			switch ( key )
			{ \wet10 } { q.orbz.set( key, msg[i+1] ) }
			{ \wet20 } { q.orbz.set( key, msg[i+1] ) }
			{ \wet30 } { q.orbz.set( key, msg[i+1] ) }
			{ \wet40 } { q.orbz.set( key, msg[i+1] ) }
			{ \wet50 } { q.orbz.set( key, msg[i+1] ) }
			{ \wet60 } { q.orbz.set( key, msg[i+1] ) }
			// { \wet70 } { q.orbz.set( key, msg[i+1] ) }
			// { \wet80 } { q.orbz.set( key, msg[i+1] ) }

			/* pitch -*/
			{ \pideg } { q.orbz.set( key, msg[i+1] ) }
			{ \pdisp } { q.orbz.set( key, msg[i+1] ) }
			{ \tdisp } { q.orbz.set( key, msg[i+1] ) }
			{ \slide } { q.orbz.set( key, msg[i+1] ) }

			/* tape, */
			{ \trate } { q.orbz.set( key, msg[i+1] ) }
			{ \tphase } { q.orbz.set( key, msg[i+1] ) }
			{ \tdepth } { q.orbz.set( key, msg[i+1] ) }
			{ \toffset } { q.orbz.set( key, msg[i+1] ) }

			/* comp, */
			{ \cctrl } { q.orbz.set( key, msg[i+1] ) }
			{ \thresh } { q.orbz.set( key, msg[i+1] ) }
			{ \slopea } { q.orbz.set( key, msg[i+1] ) }
			{ \clamp } { q.orbz.set( key, msg[i+1] ) }
			{ \relax } { q.orbz.set( key, msg[i+1] ) }
			{ \deltas } { q.orbz.set( key, msg[i+1] ) }

			/* wah, */
			{ \wrate } { q.orbz.set( key, msg[i+1] ) }
			{ \depth } { q.orbz.set( key, msg[i+1] ) }
			{ \sinsaw } { q.orbz.set( key, msg[i+1] ) }
			{ \jfreq } { q.orbz.set( key, msg[i+1] ) }
			{ \jdepth } { q.orbz.set( key, msg[i+1] ) }

			/* lfo,*/
			{ \sisap} { q.orbz.set( key, msg[i+1] ) }
			{ \lrate} { q.orbz.set( key, msg[i+1] ) }
			{ \iphase } { q.orbz.set( key, msg[i+1] ) }
			{ \lwidth } { q.orbz.set( key, msg[i+1] ) }
			{ \midfreq } { q.orbz.set( key, msg[i+1] ) }
			{ \hifreq } { q.orbz.set( key, msg[i+1] ) }

			/* ampFin */
			{ \postAmp } { q.orbz.set( key, msg[i+1] ) }

			{ \cps } { q.orbz.set( key, msg[i+1] ) }
			{ \delta } {
				q.orbz.set( key, msg[i+1] );
				q.deltas.setPairs( q.vstorb, msg[i+1].asFloat )
			}

			/* ---------------- vst stuff --------------------- */

			/* reverb */
			{ \vwet } { q.verbs[q.vstorb].synth.set( key, msg[i+1].asFloat ) }
			{ \vdry } { q.verbs[q.vstorb].synth.set( key, msg[i+1].asFloat ) }
			{ \vdelay } { q.verbs[q.vstorb].synth.set( key, msg[i+1].asFloat ) }
			{ \vsize } { q.verbs[q.vstorb].synth.set( key, msg[i+1].asFloat ) }
			{ \vlocut } { q.verbs[q.vstorb].synth.set( key, msg[i+1].asFloat ) }
			{ \vhicut } { q.verbs[q.vstorb].synth.set( key, msg[i+1].asFloat ) }
			/* tal-noisemaker */
			{ \tvolume } { ~talnoise.synth.set(key, msg[i+1].asFloat ) }
			{ \tcutoff } { ~talnoise.synth.set(key, msg[i+1].asFloat ) }
			{ \lfo1rate } { ~talnoise.synth.set(key, msg[i+1].asFloat ) }
			/*phosycon*/
			{ \acutoff } { ~acid.synth.set(key, msg[i+1].asFloat ) }
			{ \areson } { ~acid.synth.set(key, msg[i+1].asFloat ) }
			{ \asweept } { ~acid.synth.set(key, msg[i+1].asFloat ) }
			{ \aenvmod } { ~acid.synth.set(key, msg[i+1].asFloat ) }
			{ \aenvatt } { ~acid.synth.set(key, msg[i+1].asFloat ) }
			{ \aenvdec } { ~acid.synth.set(key, msg[i+1].asFloat ) }
			{ \aaccdec } { ~acid.synth.set(key, msg[i+1].asFloat ) }
			{ \aenvacc } { ~acid.synth.set(key, msg[i+1].asFloat ) }
		}
	})
);
