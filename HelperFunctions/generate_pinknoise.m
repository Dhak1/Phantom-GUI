function pn = generate_pinknoise

pn = dsp.ColoredNoise;
x = step(pn);
try
    [b,a] = butter(3,[0.01 0.1],'bandpass');
catch
    [b,a] = butter(3,[0.01 0.1],'pass');
end
y1 = filter(b,a,x);
pn = y1/max(abs(y1));