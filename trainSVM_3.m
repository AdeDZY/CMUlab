clear
Fs = 44100;

nInhale = 25;
nExhale = 25;
% read all the audio files
for i = 1:nInhale
    fileName = strcat('F:\CMUlab\breath detect\trainData\inhale',num2str(i),'.wav');
    w=wavread(fileName);
    wav{i}=w(:,1);
end

for i = 1:nExhale
    fileName = strcat('F:\CMUlab\breath detect\trainData\exhale',num2str(i),'.wav');
    w=wavread(fileName);
    wav{i+nInhale}=w(:,1);
end

%getting feature

%------------parameters for MFCC-----------------------
Tw = 200;           % analysis frame duration (ms)
Ts = 100;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 1500 4500 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
        
% hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));  

windowSize = 30000;
overlapSize =10000;
%------------------------------------------------------

for i = 1 : nInhale + nExhale
    w = wav{i};
    s = 1;
    nFrame = 1;
    while s + windowSize - 1 <= length(w)
        frame = w(s:s + windowSize - 1);
        [MFCCs, FBEs, frames] = mfcc( frame, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
        MFCCss{nFrame}=MFCCs;
        s = s + windowSize - overlapSize;
        nFrame = nFrame + 1;
    end
    
    nFrame = nFrame - 1;
    
    len = size(MFCCs,1)*size(MFCCs,2);
    mMFCCs = zeros(1,len);
    
    for t = 1:nFrame
        mMFCCs = mMFCCs + reshape(MFCCss{t},1,len);
    end
    mMFCCs = mMFCCs / nFrame;
    features(i,1:len) = mMFCCs;
end
            
group = zeros(nInhale+nExhale,1);
for i = 1 : nInhale
    group(i)=1;
end
             
svmStruct = svmtrain(features,group);
            
      

        
       