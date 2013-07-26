function [group]=testSingleSVM_2(svmStruct,fileName,nMinFrame)
data = wavread(fileName);
data = data(:,1);

Tw = 25;           % analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 1500 4500 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
Fs = 44100;        
            % hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
              
             % Feature extraction (feature vectors as columns)
[ MFCCs, FBEs, frames ] = mfcc( data, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
nFrame = size(MFCCs,2);
 cutMFCCs = MFCCs(:,floor((nFrame - nMinFrame)/2)+1:floor((nFrame - nMinFrame)/2)+nMinFrame);
    f = reshape(cutMFCCs,1,13*nMinFrame);
group = svmclassify(svmStruct,f);
end