    // function-hacks
    (
        var diversions = ();  // make a dictionary of functions
        ~diversions = diversions; // make it available out of scope
        ~diversions[\lfoOpen] = {
            q.o0Pset.xfadeTo(\lfoOpened, 16);
        };
        // use the "diversion" key as a hook for playing the synth
        q.orb0.defaultParentEvent[\diversion] = { diversions[~s].value };
    );

