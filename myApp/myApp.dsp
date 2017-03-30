import("stdfaust.lib");
import("reverbs.lib");

declare interface "SmartKeyboard{
    'Number of Keyboards':'1',
    'Max Keyboard Polyphony':'0',
}";

vibFreq = nentry("vibFreq[acc: 1 0 10 10 40]",10,0,10,0.01) : si.smoo;
vibAmp = nentry("vibAmp[acc: 1 0 0 10 20]",0,0,1,0.01) : si.smoo;
hoverAmp = abs(nentry("hoverAmp[acc: 1 0 0 10 20]",0,0,1,0.01)) : si.smooth(0.9999);

vibrato = 300*os.osc(vibFreq);

//del = nentry("del[acc: 0 0 -10 0 10]",0.5,0.01,1,0.01) : si.smoo;
del = 0.1;
//fb = nentry("fb[acc: 1 0 -10 0 10]",0.5,0,1,0.01) : si.smoo;
fb = 0.5;

echo = +~(de.delay(65536,del*ma.SR)*fb);

fc = 100 + (os.osc(vibFreq) + 1)*5000;
Q = 5;
gain = 0.5;

process = (10*(no.pink_noise : fi.resonbp(fc,Q,vibAmp)) , os.sawtooth(vibAmp*440 + vibAmp*vibrato) :> _ ),(hoverAmp*5*no.noise : fi.resonbp(100+hoverAmp*5000,Q,gain) : echo) :> _, vibAmp*5*os.osc(440+vibrato) :> echo <: _,_;
