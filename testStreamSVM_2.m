function []=testStreamSVM_2(fileName,svmStruct)
windowSize = 18000;
overlapSize = 9000;
nMinFrame = 30;

data = wavread(fileName);
data = data(:,1);

%-----------------------parameters------------------------------------
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

eThreshold = -9;
%---------------------------------------------------------------------

             % Feature extraction (feature vectors as columns)

start = 1;
i = 1;
while start + windowSize - 1 <= length(data)
subData = data(start:start+windowSize-1,1);
[ MFCCs, FBEs, frames ] = mfcc( subData, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
nFrame = size(MFCCs,2);
 cutMFCCs = MFCCs(:,floor((nFrame - nMinFrame)/2)+1:floor((nFrame - nMinFrame)/2)+nMinFrame);
    f = reshape(cutMFCCs,1,13*nMinFrame);
groups(i) = svmclassify(svmStruct,f);   

%not breathing: refined classify with energy
if(groups(i)==1)
    e = log(dot(subData,subData)/length(subData));
    if(e > eThreshold)
        groups(i)=0;
    end
end
i = i + 1;
start = start + windowSize - overlapSize;
end

figure
plot(data,'b');
hold on;

start = 1;
i = 1;
while start + windowSize - 1 <= length(data)
    e = start + windowSize -1;
    subData = data(start:e,1);
    if(groups(i)==0)
        plot(start:e,subData,'r');
        hold on;
    end
    i = i + 1;
    start = start + windowSize - overlapSize;
end


end
 