function []=testStreamSVM_3(fileName,svmStruct)
windowSize = 30000;
overlapSize = 10000;

data = wavread(fileName);
data = data(:,1);

%-----------------------parameters------------------------------------
Tw = 200;           % analysis frame duration (ms)
Ts = 100;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 1500 4500 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
Fs = 44100;        
            % hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
%---------------------------------------------------------------------

             % Feature extraction (feature vectors as columns)

start = 1;
i = 1;
while start + windowSize - 1 <= length(data)
subData = data(start:start+windowSize-1,1);
[ MFCCs, FBEs, frames ] = mfcc( subData, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
len = size(MFCCs,1)*size(MFCCs,2);
f = reshape(MFCCs,1,len);
groups(i) = svmclassify(svmStruct,f);   
i = i + 1;
start = start + windowSize - overlapSize;
end
groups

figure
plot(data,'b');
hold on;

start = 1;
i = 1;
while start + windowSize - 1 <= length(data)
    e = start + windowSize -1;
    subData = data(start:e,1);
    if(groups(i)==1)
        plot(start:e,subData,'r');
        hold on;
    end
    i = i + 1;
    start = start + windowSize - overlapSize;
end


end
 