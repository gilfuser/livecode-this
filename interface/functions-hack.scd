// function-hacks

~dirt.soundLibrary.addSynth(\orbo, (play:
    { | n = 4 |
        case
        { ~n == 0} { Ndef(\allOrbs).set(\speak0, 0) }
        { ~n == 1} { Ndef(\allOrbs).set(\speak1, 0) }
        { ~n == 2} { Ndef(\allOrbs).set(\speak2, 0) }
        { ~n == 3} { Ndef(\allOrbs).set(\speak3, 0) };
    }
));

~dirt.soundLibrary.addSynth(\orbi, (play:
    { | n = 4 |
        case
        { ~n == 0} { Ndef(\allOrbs).set(\speak0, 1) }
        { ~n == 1} { Ndef(\allOrbs).set(\speak1, 1) }
        { ~n == 2} { Ndef(\allOrbs).set(\speak2, 1) }
        { ~n == 3} { Ndef(\allOrbs).set(\speak3, 1) };
    }
));
