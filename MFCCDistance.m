function [dis] = MFCCDistance(wav,M_bar,M_V)

%-------------------fit length------------------------
ml = 31519;
wav = wav(:,1);
if(length(wav)<ml)
    wav = [wav;wav];
end
wav = wav(1:ml);

%-------------------extract Mfcc features-------------
Tw = 100;
Ts = 50;
alpha = 0.97;
R = [200,3000];
M = 20;
C = 13;
L = 22;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

[ MFCC, FBEs, frames ] = mfcc( wav, 44100, Tw, Ts, alpha, hamming, R, M, C, L );

%-------------------get distance matrix---------------
D = ((MFCC - M_bar).^2)./M_V;
d = reshape(D,169,1);
dis = sum(d);
end