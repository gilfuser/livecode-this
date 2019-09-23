OSCdef(\oscFromTidal, { |msg|
	MFdef(\theHub).value(msg);
}, '/play2').permanent_(true);

/*
MFdef(\theHub).add(\post, {|msg| msg.postln});
MFdef(\theHub).enable(\post);
MFdef(\theHub).disable(\post);
MFdef(\theHub).disable(\tidalSetOrbs);
*/

q.orbz = Ndef(\orb0);
q.orbI = 0;
q.verbs = [~verbOrb0, ~verbOrb1, ~verbOrb2, ~verbOrb3];
q.pxChainz = [q.fx.orb0, q.fx.orb1, q.fx.orb2, q.fx.orb3];
q.fx.orbs = ();
q.fx.names = Array.newClear(q.pxChainz.size); // array of arrays with the fxs names of each orb

q.pxChainz.do{|v i|
	// filter out the ones we don't want to do anything with
	v.slotNames.remove(\ampFin);
	v.slotNames.remove(\comp);
	// put fxs names arrays
	q.fx.names.put(i, v.slotNames);
	// start creating the dictonary with keys and empty new dicts. as values
	q.fx.orbs.put(v.key, () );

	// for each array of fx names...
	q.fx.names[i].do{ |j k|
		// take all theirs params names...
		var params = q.fx.fxLib.at(j).argNames.copy;
		// filter out the ones we dont want to do anything with
		params.remove(\in);
		params.remove(\n);
		params.remove(\cps);
		// ... and populate the empty dicts at each proxy (orb) key with fx name as the key and fx params names as value

		q.fx.orbs.at(v.key).put( j, () );
		q.fx.orbs.at(v.key).at(j).put( \index, k );
		q.fx.orbs.at(v.key).at(j).put( \params, params );
	}
};

MFdef(\theHub).add(\setOrb,
	{ |msg|
		var orbz;
		if ( ( msg.indexOf( \orbit ).notNil ) and: ( orbz != q.orbz ) )
		{ q.orbz = Ndef( "orb%".format( msg.at( msg.indexOf( \orbit ).asInteger + 1 ) ).asSymbol );
			orbz = q.orbz; }
		{ q.orbz = Ndef(\orb0); };
	}
);
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

MFdef(\theHub).add(\setFXs,
	{ |msg|
		var theOrb = q.pxChainz[q.orbI].key; // the ProxyChain being used
		var theFx = q.fx.orbs.at(theOrb).keys; // the FXs names

		theFx.do { |fx|
			var ind = q.fx.orbs.at(theOrb).at(fx).at(\index); // fx index...
			var fxSymbol = "wet%".format(ind).asSymbol; // to form ProxyChain slot to it
			var px = q.pxChainz[q.orbI].proxy; // the Ndefs

			if (
				( q.pxChainz[q.orbI].slotNames.indexOf(fx).notNil ) // check the fxs in that ProxyChain
				and: ( msg.indexOf(fx).notNil ) // check if there is an incomming msg with that fx name
			)

			{
				if ( q.pxChainz[q.orbI].slotsInUse.indexOf(fx).isNil ) // check if the fx is disabled (by remove)
				{ q.pxChainz[q.orbI].add( fx, msg[msg.indexOf(fx)+1].round(0.001) ) } // enable it
				{
					// check if the incomming value is not equal the actual fx dry-wet value
					if ( msg[ msg.indexOf(fx)+1 ].round(0.01) !== px.getKeysValues( [fxSymbol] )[0][1].round(0.01) )
					{
						// set the fx dry-wet value with the incomming value.
						q.orbz.set( fxSymbol, msg[msg.indexOf(fx)+1].round(0.01) );
					}
				};

				// for each parameter from that fx
				q.fx.orbs.at(theOrb).at(fx).at(\params).do { |x|

					if ( msg.indexOf(x).notNil /* if there is an incomming msg with that key*/ )
					{
						// and the incomming msg value to that paramenter is not equal to the actual parameter value
						if ( msg.at(msg.indexOf(x) + 1).round(0.01) !== px.getKeysValues( [x] )[0][1].round(0.01) )
						{
							// set the paramenter value with the incomming value
							q.orbz.set( x, msg[ msg.indexOf(x) + 1 ] )
						};
					}
				};
			}
			// if the fx is not in that ProxyChain or there is not an incomming msg with that key, disable the fx
			{ q.pxChainz[q.orbI].remove(fx) };
		};
	}
);
