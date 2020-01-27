{

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
	q.orbI = 0;

	MFdef(\theHub).add(\setOrb,
		{ |msg|
			var orbz;
			if ( ( msg.indexOf( \orbit ).notNil ) and: ( orbz != q.orbz ) )
			{ q.orbz = Ndef( "orb%".format( msg.at( msg.indexOf( \orbit ).asInteger + 1 ) ).asSymbol );
				orbz = q.orbz; }
			{ q.orbz = Ndef(\orb0); };
		}
	);

	// MFdef(\theHub).enable(\setOrb);

	MFdef(\theHub).add(\getOrbIndex,
		{ |msg|
			var orbIz;
			if ( ( msg.indexOf( \orbit ).notNil ) and: ( orbIz != q.orbI ) ) {
				q.orbI = msg.at( msg.indexOf( \orbit ).asInteger + 1 );
				orbIz = q.orbI;
			}
			{ q.orbI = 0 };
		}
	);

	// MFdef(\theHub).enable(\getOrbIndex);

	q.pxChainz = [q.orb0, q.orb1, q.orb2, q.orb3];
	q.fx.orbs = ();
	q.fx.names = Array.newClear(q.pxChainz.size); // array of arrays with the fxs names of each orb

	q.pxChainz.do{|v i|
		// filter out the ones we don't want to do anything with
		// v.slotNames.remove(\comp);
		// put fxs names arrays
		q.fx.names.put(i, v.slotNames);
		// start creating the dictonary with keys and empty new dicts. as values
		q.fx.orbs.put(v.key, () );

		// for each array of fx names...
		q.fx.names[i].do{ |j k|
			// take all their params names...
			var params = ProxyChain.atSrcDict(j).paramNames.copy;
			// filter out the ones we dont want to do anything with
			// params.remove(\cps);
			// ... and populate the empty dicts at each proxy (orb) key with fx name as the key and fx params names as value

			q.fx.orbs.at(v.key).put( j, () );
			q.fx.orbs.at(v.key).at(j).put( \index, k );
			q.fx.orbs.at(v.key).at(j).put( \params, params );
		}
	};

    (
        q.addAndSet = { | q, msg, key, val, orb |
            if ( q.pxChainz[q.orbI].slotsInUse.indexOf(key).isNil )
            { q.pxChainz[q.orbI].add(key, (val).lag2(0.2)) }
            {
                q.orbz.set( "wet%".format( q.fx.orbs.at(orb).at(key).at(\index) ).asSymbol, (val).lag2(0.2) );
                q.fx.orbs.at(orb).at(key).at(\params).do { |x|
                    if ( msg.indexOf(x).notNil) // if there is an incoming msg with that key
                    { // and the incomming msg value to that paramenter is not equal to the actual parameter value:
                        if ( msg.at(msg.indexOf(x) + 1).round(0.01) !== q.pxChainz[q.orbI].proxy.getKeysValues( [x] )[0][1].round(0.01) )
                        { // set the parameter value with the incoming value
                            q.orbz.set( x, msg[ msg.indexOf(x) + 1 ] )
                        };
                    }
                };
            };
        };
    );

	(
		MFdef(\theHub).add(\setFXs,
			{ |msg|
				q.theOrb = q.pxChainz[q.orbI].key; // the ProxyChain being used: orb0
				msg.collect { |key, i|
					['tape', 'wah', 'compT', 'modelay', 'llfo'].do{ |x|
					if ( msg.indexOf(x).isNil ) {
						q.pxChainz[q.orbI].remove(x);
					}};
					switch ( key )
					{ 'tape' } { q.addAndSet(msg, key, msg[i+1], q.theOrb) }
					{ 'wah' } { q.addAndSet(msg, key, msg[i+1], q.theOrb) }
					{ 'modelay' } { q.addAndSet(msg, key, msg[i+1], q.theOrb) }
					{ 'llfo' } { q.addAndSet(msg, key, msg[i+1], q.theOrb) }
					{ 'compT' } { q.addAndSet(msg, key, msg[i+1], q.theOrb) }
				};
			}
		);
		// { 0.2.wait; MFdef(\theHub).enable(\setFXs) }.fork;
	);


	(
		/*
		MFdef(\theHub).remove( \tidalSetVSTs);
		MFdef(\theHub).disable( \tidalSetVSTs);
		MFdef(\theHub).enable( \tidalSetVSTs);
		*/

		q.verbs = [~verbOrb0, ~verbOrb1, ~verbOrb2, ~verbOrb3]; // from vst_verbs.scd

		MFdef(\theHub).add( \tidalSetVSTs,
			{ |msg|
				msg.collect { |key, i|
					switch ( key )
					/* reverb */
					{ \vwet } { q.verbs[q.vstorb].set( 'Wet Amou', msg[i+1] ) }
					{ \vdry } { q.verbs[q.vstorb].set( 'Dry Amou', msg[i+1] ) }
					{ \vdelay } { q.verbs[q.vstorb].set('Decay ti',msg[i+1] ) }
					{ \vsize } { q.verbs[q.vstorb].set( 'Room siz',msg[i+1] ) }
					{ \vlocut } { q.verbs[q.vstorb].set('Bass Cut',msg[i+1] ) }
					{ \vhicut } { q.verbs[q.vstorb].set('Treble C',msg[i+1] ) }
					/*
					/* tal-noisemaker */
					{ \tvol } { ~taln.set('volume', msg[i+1] ) }
					{ \tftype } { ~taln.set('filtertype', msg[i+1] ) }
					{ \tcut } { ~taln.set('cutoff', msg[i+1] ) }
					{ \tres } { ~taln.set('resonance', msg[i+1] ) }
					{ \tkfol } { ~taln.set('keyfollow', msg[i+1] ) }
					{ \tfcon } { ~taln.set('filtercontour', msg[i+1] ) }
					{ \tfatt } { ~taln.set('filterattack', msg[i+1] ) }
					{ \tfdec } { ~taln.set('filterdecay', msg[i+1] ) }
					{ \tfsus } { ~taln.set('filtersustain', msg[i+1] ) }
					{ \tfrel } { ~taln.set('filterrelease', msg[i+1] ) }
					{ \tampa } { ~taln.set('ampattack', msg[i+1] ) }
					{ \tampd } { ~taln.set('ampdecay', msg[i+1] ) }
					{ \tamps } { ~taln.set('ampsustain', msg[i+1] ) }
					{ \tampr } { ~taln.set('amprelease', msg[i+1] ) }
					{ \tosc1v } { ~taln.set('osc1volume', msg[i+1] ) }
					{ \tosc2v } { ~taln.set('osc2volume', msg[i+1] ) }
					{ \tosc3v } { ~taln.set('osc3volume', msg[i+1] ) }
					{ \tosc1wf} { ~taln.set('osc1waveform', msg[i+1] ) }
					{ \tosc2wf} { ~taln.set('osc2waveform', msg[i+1] ) }
					{ \tlfo1r} { ~taln.set('lfo1rate', msg[i+1] ) }
					{ \tlfo2r} { ~taln.set('lfo2rate', msg[i+1] ) }
					{ \tlfo1a} { ~taln.set('lfo1amount', msg[i+1] ) }
					{ \tlfo2a} { ~taln.set('lfo2amount', msg[i+1] ) }
					*/
					/*abl*/
					{ \acut } { ~abl.set('Cutoff', msg[i+1] ) }
					{ \ares }  { ~abl.set('Resonance', msg[i+1] ) }
					{ \amod } { ~abl.set('Envmod', msg[i+1] ) }
					{ \adec } { ~abl.set('Decay', msg[i+1] ) }
					{ \aacc } { ~abl.set('Env Accent', msg[i+1] ) }
					{ \avol } { ~abl.set('Volume', msg[i+1] ) }
					{ \awave } { ~abl.set('Waveform', msg[i+1] ) }
					{ \aenva } { ~abl.set('Env Attack', msg[i+1] ) }
					{ \aaccd } { ~abl.set('Accent Decay', msg[i+1] ) }
					{ \buz }   { ~abl.synth.set('buz', msg[i+1].asInteger ) }
				}
		})
	);

	"\n Tidal Set FXs - LOADED \n ".postln;
	/*
	MFdef(\theHub).enable(\setFXs);
	MFdef(\theHub).disable(\setFXs);
	*/
}.fork;

/*
MFdef(\theHub).add(\post, {|msg| msg.postln});
MFdef(\theHub).enable(\post);
MFdef(\theHub).disable(\post);
*/

/*
(
////////////////////////////////////////////
////////////////////////////////////////////
MFdef(\theHub).add(\setFXs,
{ |msg|
var theOrb = q.pxChainz[q.orbI].key; // the ProxyChain being used
var theFx = q.fx.orbs.at(q.pxChainz[q.orbI].key).keys; // the FXs names

theFx.do { |fx|
var ind = q.fx.orbs.at(theOrb).at(fx).at(\index); // fx indexes...
var fxSymbol = "wet%".format(ind).asSymbol; // to format ProxyChain slot to that
var px = q.pxChainz[q.orbI].proxy; // the Ndefs
var delta = msg[msg.indexOf('delta') + 1];

if (
( q.pxChainz[q.orbI].slotNames.indexOf(fx).notNil ) // check the fxs in that ProxyChain
and: ( msg.indexOf(fx).notNil ) // check if there is an incomming msg with that fx name
)

{
var value = msg[msg.indexOf(fx)+1].round(0.001);
if ( q.pxChainz[q.orbI].slotsInUse.indexOf(fx).isNil ) // check if the fx is disabled (by .remove)
{
q.pxChainz[q.orbI].add( fx );
q.orbz.set( fxSymbol, value.lag2(0.2) );
} // enable it

{
// check if the incoming value is not equal the actual fx dry-wet value
if ( msg[ msg.indexOf(fx)+1 ].round(0.01) !== px.getKeysValues( [fxSymbol] )[0][1].round(0.01) )
{
// set the fx dry-wet value with the incoming value.
q.orbz.set( fxSymbol, value.lag2(0.2) );
}
};

// for each parameter from that fx
q.fx.orbs.at(theOrb).at(fx).at(\params).do { |x|

if ( msg.indexOf(x).notNil /* if there is an incoming msg with that key*/ )
{
// and the incomming msg value to that paramenter is not equal to the actual parameter value
if ( msg.at(msg.indexOf(x) + 1).round(0.01) !== px.getKeysValues( [x] )[0][1].round(0.01) )
{
// set the parameter value with the incoming value
q.orbz.set( x, msg[ msg.indexOf(x) + 1 ] )
};
}
};
}
// if the fx is not in that ProxyChain or there is not an incomming msg with that key, disable the fx
{
{
// q.pxChainz[q.orbI].proxy.set( fxSymbol, 0 );
(delta * 0.9).wait;
// if ( msg.indexOf(fx).isNil ) {
q.pxChainz[q.orbI].remove(fx);
// };
}.fork
};
};
}
);

{ 0.2.wait; MFdef(\theHub).enable(\setFXs) }.fork;
)*/
