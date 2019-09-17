(
OSCdef(\oscFromTidal, { |msg|
	MFdef(\theHub).value(msg);
}, '/play2').permanent_(true)
);

/*
MFdef(\theHub).add(\post, {|msg| msg.postln});
MFdef(\theHub).enable(\post);
MFdef(\theHub).disable(\post);
MFdef(\theHub).disable(\tidalSetOrbs);
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
			// { \wet60 } { q.orbz.set( key, msg[i+1] ) }
			// { \wet70 } { q.orbz.set( key, msg[i+1] ) }
			// { \wet80 } { q.orbz.set( key, msg[i+1] ) }

			// [> pitch -<]
			// { \pideg } { q.orbz.set( key, msg[i+1] ) }
			// { \pdisp } { q.orbz.set( key, msg[i+1] ) }
			// { \tdisp } { q.orbz.set( key, msg[i+1] ) }
			// { \slide } { q.orbz.set( key, msg[i+1] ) }
            //
			// [> tape, <]
			// { \trate } { q.orbz.set( key, msg[i+1] ) }
			// { \tphase } { q.orbz.set( key, msg[i+1] ) }
			// { \tdepth } { q.orbz.set( key, msg[i+1] ) }
			// { \toffset } { q.orbz.set( key, msg[i+1] ) }
            //
			// [> wah, <]
			// { \wrate } { q.orbz.set( key, msg[i+1] ) }
			// { \depth } { q.orbz.set( key, msg[i+1] ) }
			// { \sinsaw } { q.orbz.set( key, msg[i+1] ) }
			// { \jfreq } { q.orbz.set( key, msg[i+1] ) }
			// { \jdepth } { q.orbz.set( key, msg[i+1] ) }
            //
			// [> lfo,<]
			// { \sisap} { q.orbz.set( key, msg[i+1] ) }
			// { \lrate} { q.orbz.set( key, msg[i+1] ) }
			// { \iphase } { q.orbz.set( key, msg[i+1] ) }
			// { \lwidth } { q.orbz.set( key, msg[i+1] ) }
			// { \midfreq } { q.orbz.set( key, msg[i+1] ) }
			// { \hifreq } { q.orbz.set( key, msg[i+1] ) }

			/* comp, */
			{ \cctrl } { q.orbz.set( key, msg[i+1] ) }
			{ \thresh } { q.orbz.set( key, msg[i+1] ) }
			{ \slopea } { q.orbz.set( key, msg[i+1] ) }
			{ \clamp } { q.orbz.set( key, msg[i+1] ) }
			{ \relax } { q.orbz.set( key, msg[i+1] ) }
			{ \deltas } { q.orbz.set( key, msg[i+1] ) }

			/* ampFin */
			{ \postAmp } { q.orbz.set( key, msg[i+1] ) }

			{ \cps } { q.orbz.set( key, msg[i+1] ) }
			{ \delta } {
				q.orbz.set( key, msg[i+1] );
				q.deltas.setPairs( q.vstorb, msg[i+1].asFloat )
			}

			/* ---------------- vst stuff --------------------- */

			/* reverb */
			{ \vwet } { q.verbs[q.vstorb].set( 'Wet', msg[i+1].asFloat ) }
			{ \vdry } { q.verbs[q.vstorb].set( 'Dry', msg[i+1].asFloat ) }
			{ \vdelay } { q.verbs[q.vstorb].set( 'Delay', msg[i+1].asFloat ) }
			{ \vsize } { q.verbs[q.vstorb].set( 'Size', msg[i+1].asFloat ) }
			{ \vlocut } { q.verbs[q.vstorb].set( 'High Pass', msg[i+1].asFloat ) }
			{ \vhicut } { q.verbs[q.vstorb].set( 'Low Pass', msg[i+1].asFloat ) }
			/* tal-noisemaker */
			{ \tvol } { ~talnoise.set('volume', msg[i+1].asFloat ) }
			{ \tftype } { ~talnoise.set('filtertype', msg[i+1].asFloat ) }
			{ \tcut } { ~talnoise.set('cutoff', msg[i+1].asFloat ) }
			{ \tres } { ~talnoise.set('resonance', msg[i+1].asFloat ) }
			{ \tkfol } { ~talnoise.set('keyfollow', msg[i+1].asFloat ) }
			{ \tfcon } { ~talnoise.set('filtercontour', msg[i+1].asFloat ) }
			{ \tfatt } { ~talnoise.set('filterattack', msg[i+1].asFloat ) }
			{ \tfdec } { ~talnoise.set('filterdecay', msg[i+1].asFloat ) }
			{ \tfsus } { ~talnoise.set('filtersustain', msg[i+1].asFloat ) }
			{ \tfrel } { ~talnoise.set('filterrelease', msg[i+1].asFloat ) }
			{ \tampa } { ~talnoise.set('ampattack', msg[i+1].asFloat ) }
			{ \tampd } { ~talnoise.set('ampdecay', msg[i+1].asFloat ) }
			{ \tamps } { ~talnoise.set('ampsustain', msg[i+1].asFloat ) }
			{ \tampr } { ~talnoise.set('amprelease', msg[i+1].asFloat ) }
			{ \tosc1v } { ~talnoise.set('osc1volume', msg[i+1].asFloat ) }
			{ \tosc2v } { ~talnoise.set('osc2volume', msg[i+1].asFloat ) }
			{ \tosc3v } { ~talnoise.set('osc3volume', msg[i+1].asFloat ) }
			{ \tosc1wf} { ~talnoise.set('osc1waveform', msg[i+1].asFloat ) }
			{ \tosc2wf} { ~talnoise.set('osc2waveform', msg[i+1].asFloat ) }
			{ \tlfo1r} { ~talnoise.set('lfo1rate', msg[i+1].asFloat ) }
			{ \tlfo2r} { ~talnoise.set('lfo2rate', msg[i+1].asFloat ) }
			{ \tlfo1a} { ~talnoise.set('lfo1amount', msg[i+1].asFloat ) }
			{ \tlfo2a} { ~talnoise.set('lfo2amount', msg[i+1].asFloat ) }
			/*phosycon*/
			{ \acutoff } { ~acid.set('Cutoff', msg[i+1].asFloat ) }
			{ \areson } { ~acid.set('Resonance', msg[i+1].asFloat ) }
			{ \asweept } { ~acid.set('Sweep Time', msg[i+1].asFloat ) }
			{ \aenvmod } { ~acid.set('Env Mod', msg[i+1].asFloat ) }
			{ \aenvatt } { ~acid.set('Env Attack', msg[i+1].asFloat ) }
			{ \aenvdec } { ~acid.set('Env Decay', msg[i+1].asFloat ) }
			{ \aaccdec } { ~acid.set('Accent Decay', msg[i+1].asFloat ) }
			{ \aenvacc } { ~acid.set('Env Accent', msg[i+1].asFloat ) }
			{ \buz } { ~acid.synth.set('buz', msg[i+1].asInteger ) }
		}
	})
);
" \n Tidal set FX loaded \n ".postln;
