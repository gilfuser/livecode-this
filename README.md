# livecode-this

<https://github.com/gilfuser/livecode-this>  
By Gil Fuser

This is a setup for [livecoding](https://toplap.org/about/).
Here are the files needed to use [SuperCollider](https://supercollider.github.io/) together with [TidalCycles](https://tidalcycles.org) in a flexible way of controling parameters of effects and synths both from Tidal and SuperCollider (SC).

## and more

* VSTs instruments and effects hosted by SuperCollider.
* Free GUIs to monitor effects states.
* Snippets and key-combos to livecode faster.
* Extra synths and effects.

### **Check it in-depth in the [wiki](https://github.com/gilfuser/livecode-this/wiki)**

### note

If you love Tidal but you don't know anything or almost anything about SuperCollider but you use already Tidal, maybe you should learn it. Take a look at some [learning resources](#learning-resouces). You will get some extra power. Then come back, download or clone this and have fun.
  
### where this comes from

The initial idea of seting this all up was to have continuous control of parameters in Tidal, which works mostly in a *per event* basis. This have been changing and thanks to [smooth](#https://tidalcycles.org/index.php/smooth) its easier to control things continuously inside Tidal now a days, but some advantages of the approach you will find here remains, e.g. the GUIs to monitor effects states and all the flexibility that [JitLib](http://doc.sccode.org/Overviews/JITLib.html) offers.

## Use it

> If you want to test this setup as is follow the next steps.  
If you want to use specific parts of it, take a look at the [wiki](https://github.com/gilfuser/livecode-this/wiki) to see how the details of how the files interrelate.

---

### Prerequisites

#### JitLibExtensions

If you are not sure if already have this Quark, evalluate in SuperCollider  
`Quarks.isInstalled("JITLibExtensions");`  
If you don't have it yet, evalluate this to install it:  
`Quarks.checkForUpdates(); Quarks.install("JITLibExtensions");`

#### VSTPlugin Extension into SC

[Go here](https://git.iem.at/pd/vstplugin/tree/develop) and follow the instructions in that repo to install it.

#### Windows VSTs inside Linux

If you want to use Windows VSTs on Linux use [LinVst](https://github.com/osxmidi/LinVst). Go to the link and follow the instructions on that repo. It's easyer than you might think.
  
#### The VSTs

**Molot** - Compressor. Its a colored old school compressor that is used as a glue to all of that samples and synths from Tidal.  
[Get it here](https://vladgsound.wordpress.com/downloads/)

> I dream about a better SC native compressor.

**Nova** - 8 Band EQ + Multiband Compressor. Used per orbit to avoid too much low and high frequences clashes and phase issues, when the sounds overlap.  
[Get it here](https://www.tokyodawn.net/tdr-nova/)

**TAL-Reverb-3** - Reverb. Also aplied per orbit, to create depthness in the sound scene.  
[Get it here](https://tal-software.com/products/tal-reverb)

**Phosycon** - 303 emulator - The only VST instrument in this list, to make some acid. Also the only non-free.  
[Get it here](https://d16.pl/phoscyon)

#### SC and VST Effects and Phosycon Parameters inside Tidal

If you are using vim-tidal and don't have your own stuff inside *Tidal.ghci*, you can substitute yours by the one here.  
If you use Atom, VS Studio or emacs, copy from [Tidal.ghci](https://github.com/gilfuser/livecode-this/blob/master/Tidal.ghci) everything from `pideg = pF "pideg"` to `envacc x = ccv x # ccn 9` and paste in your BootTidal.hs file. You may have to put a `let` in front of each parameter. Just follow the way your file is written.

#### Snippets

> This is olny for people using vim-tidal.

Install [Ultisnips](https://github.com/SirVer/ultisnips) following the instructions on that link.  
If you are managing your (neo)vim plugins with Plug, put **tidal.snippets** inside **plugged/ultisnips/UltiSnips**

#### More Vim/Neovim stuff

> This is also for vim-tidal people.  

You will find some key mappings specially for livecoding in the file *init.vim*. Include them in your vim config file.  
I'm using [neovim](https://neovim.io/) instead of vim. In order to do the same you have to change a line in 'vim-tidal/bin/tidalvim':  
change `VIM=${VIM:-"vim"}` into `VIM=${VIM:-"nvim"}`

---
  
### **You are good to go!**

If you haven't done it so far, clone or download this repo using the green **Clone or Download** button in <https://github.com/gilfuser/livecode-this>

Open **_0_StartUp.scd** in Supercollider and evaluate the whole block. All the needed files must be loaded in the right order.  
Open Tidal and have fun.  
Check the effects and synths that you now have and the related parameters. Use different orbits.

---

## The files

* **_0_StartUp.scd**  
  Load other SC files in sush an order that interdependent files won't miss anything necessary.

* **globals/0_loadGlobalUtils.scd**  
Do some path-naming and other - not so necessary a.t.m - stuff.

* **interface/superDirt_startup.scd**  
Start SuperDirt (~dirt), load the samples, load the files **synths/tidalInstruments.scd** and **FX/myTidalFx.scd**, create Ndefs from which SuperDirt's orbits output goes through, much like following the paths of [**SuperDirt/hacks/jitlib-hack.scd**](#https://github.com/musikinformatik/SuperDirt/blob/develop/hacks/jitlib-hacks.scd).

* **FX/vstPlugin.scd**  
Create Control-Busses to control parameters from the reverbs (you will see them again in **interface/tidal_set_FX.scd**), create the necessary SynthDefs containing VstPlugin instances, and VstPluginController (learn more about it in CS Help System) in which the actual VSTs are opened.

* **FX/fxLib.scd**  
Create a ProxyChain with all the effects that will be injected (in the file **FX/FXXX_orbs.scd**) in the Ndefs from which ```~dirt``` will output, create one *Spec* ("input datatype specification") for each effect parameter.

* **FX/FXXX_orbs.scd**  
Set Ndefs up, inject from the ProxyChain in them and create the respective GUIs.
**TODO:** Everything is already setup to NdefPresets to be available, so implement this functionality to be used together with **function-hacks.scd**, so you can change lots of parameters at once.

* **interface/tidal_set_FX.scd**  
Create OSCDef to get OSC messages from Tidal with an MFdef in it, the MFdef is constantly updated with the incoming OSC messages, add functions to the MFdef to control the effects parameters whenever they change.

* **synths/tidalInstruments.scd**  
Create synths to be used in Tidal. Appart from the normal sounding ones there is **dummy**, a silent instrument, and *click*, a transient instrument with a controlable decay, used mostly as signal control in the effect *comp* (take a look at *FX/fxLib.scd*) to duck other sounds.

* **FX/myTidalFx.scd**  
Curently there is only one effect there: **saturator**  
Its an effect to be used in Tidal in **per-event** fashion. It works well to bring some harmonics of low frequencies as well to make some sounds harsher.

> A better control of wich frequencies are affected wouldn't be bad. Suggestions and/or PRs about it are very welcome.

* **Tidal.ghci**  
The config file for vim-tidal. It contains the definitions for all the parameters of effects and synths, including VSTs, that lives in SuperCollider. It can be seen as the **tidal_set_FX.scd** Tidal counterpart.

* **tidal.snippets**  
The snippets to livecode faster. There are a lot of snippets for samples that you probably won't need because they refer to my custom samples library.

* **init.vim**  
A Neovim config file with some special control-mappings for live-coding. If have already one, don't substitute yours for this one. Simply take what interest you.

---

## Learning references

I strongly recomend these public sources to learn both SuperCollider and Tidal. The communities are truly welcomming and there's no prerequisite or knowledge entry barrier.  
Make use of SuperCollider Help System to learn more about any of the UGens or methods you may encounter here and are curious about.

### SuperCollider

* [sc-users mailing-list](http://www.birmingham.ac.uk/facilities/ea-studios/research/supercollider/mailinglist.aspx).
* [sc-forum](https://scsynth.org).
* [Lurk channel](https://talk.lurk.org/channel/supercollider).

### Tidal Cycles

* [Tidal mailing-list](tidal@we.lurk.org).
* [Lurk channel](https://talk.lurk.org/channel/tidal).
* [Tidal Cycles website](https://tidalcycles.org/index.php/Userbase).

---

## Contribute

Make Pull Requests if you see something wrong or have suggestions to be included.  
File issues if you have some problem using this.  
Fork it if you want to change it your own way.  
You are always welcome to participate.
