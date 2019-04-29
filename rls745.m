close all;
clear all;
clc;

input_signal = audioread('input.wav'); 

n=length(input_signal) ; 
P=fft(input_signal,n);   
figure;
subplot(2,1,1);
plot(input_signal);
axis([0 250000 -2 2]);
ylabel('Amplitude');
xlabel('time');
title('Expected (original noise free) speech signal 1','fontweight','bold');
grid;
subplot(2,1,2);
plot(abs(P));
axis([0 1000 0 2000]);
title('Expected (raw noiseless) speech signal spectrum1','fontweight','bold');
grid;
noise = 0.4*max(input_signal(:,1))*randn(length(input_signal),1); 
input_with_noise = input_signal + noise; 
audiowrite('RLSrefns.wav',noise,44100) ;   
audiowrite('RLSprimsp.wav',input_with_noise,44100);
clc;
[primary,fs]=audioread('RLSprimsp.wav');
n1=length(primary) ; 
P1=fft(primary,n1);                              
figure;
subplot(2,1,1);
plot(primary);
axis([0 250000 -2 2]);
ylabel('amplitude');
xlabel('time');
title('main microphone (noisy) voice signal ','fontweight','bold');
grid;
subplot(2,1,2);
plot(abs(P1));
axis([0 1000 0 2000]);
title('primary microphone (noise) speech signal spectrum','fontweight','bold');
grid;
[fref,fs]=audioread('RLSrefns.wav');
n1=length(fref) ; 
F=fft(fref,n1);  
figure;
subplot(2,1,1);
plot(fref);grid;

ylabel('amplitude');
xlabel('time');
title ('reference microphone (single noise) noise signal 1 ', 'fontweight', 'bold');
subplot(2,1,2);
plot(abs(F));
title('reference microphone (single noise) noise signal spectrum 1', 'fontweight', 'bold');
grid;
rxs=primary -fref;
rxn =primary ;                  % Input signal sequence
rdn = rxs ;                      % Expected result sequence
    
rls = dsp.RLSFilter(12);
[ren,ryn] = rls(rxn(:,1),rdn(:,1));
figure();
plot(ren)
title('RLS error')
grid;
figure();
ky= ryn;
subplot(2,1,1)
plot(ky);
title('output signal');

grid;
axis([0 250000 -2 2]);

subplot(2,1,2)
Ryy= fft(ryn,n1);

plot(abs(Ryy));
grid;
axis([0 1000 0 2000]);
title('output signal spectrum');


