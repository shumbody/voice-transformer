% Voice Transformer
% Sharang Phadke
% Sameer Chocotaco
% 
% Looking at things

TSPpath = '../../TSPspeech/48k/';

MAsoundFiles = dir(strcat(TSPpath, 'MA/*.wav'));
FAsoundFiles = dir(strcat(TSPpath, 'FA/*.wav'));

[signal1M, fs] = wavread(strcat(TSPpath,'MA/', MAsoundFiles(1).name));
[signal1F, ~] = wavread(strcat(TSPpath,'FA/', FAsoundFiles(1).name));

% figure(1)
% subplot(211);
% spectrogram(signal1M, triang(512), 0, 512, fs, 'yaxis');
% subplot(212);
% spectrogram(signal1F, triang(512), 0, 512, fs, 'yaxis');

nFFT = 512;
winTime = 0.001;
soundsc(signal1M,fs);
% mfcc1 = melfcc(signal1M,fs,'wintime',winTime,'hoptime',winTime);
% x = invmelfcc(mfcc1,fs,'wintime',winTime,'hoptime',winTime);
freqs1M = real(fft(buffer(signal1M,winTime*fs),nFFT));
freqs1F = real(fft(buffer(signal1F,winTime*fs),nFFT));

mu1M = mean(freqs1M,2);
var1M = std(freqs1M,[],2);
mu1F = mean(freqs1F,2);
var1F = std(freqs1F,[],2);

freqs1FN = bsxfun(@rdivide, bsxfun(@minus, freqs1F , mu1F), var1F);
freqs1FtoM = bsxfun(@plus, bsxfun(@times, freqs1FN, var1M), mu1M);

x = ifft(freqs1FtoM,nFFT);
x = x(winTime*fs,:);
x = reshape(smooth(real(x)),1,numel(x));
soundsc(x,fs);