
Fs = 44100;

nSl = 8;
nExhale = 10;
nInhale = 10;
% read all the audio files
for i = 1:nExhale
    fileName = strcat('F:\CMUlab\breath detect\trainData\exhale',num2str(i),'.wav');
    w=wavread(fileName);
    wav{i}=w(:,1);
end

for i = 1:nInhale
    fileName = strcat('F:\CMUlab\breath detect\trainData\inhale',num2str(i),'.wav');
    w=wavread(fileName);
    wav{i+nExhale}=w(:,1);
end

for i = 1:nSl
    fileName = strcat('F:\CMUlab\breath detect\trainData\sl',num2str(i),'.wav');
    w=wavread(fileName);
    wav{i+nExhale+nInhale}=w(:,1);
end

%getting feature

%------------parameters for MFCC-----------------------
Tw = 25;           % analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 1500 4500 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
        
% hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
%------------------------------------------------------


nMinFrame = 500;
nExamples = nSl + nInhale + nExhale;

for i = 1 : nExamples
    [MFCCs, FBEs, frames] = mfcc( wav{i}, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
    MFCCss{i} = MFCCs;
    nFrame = size(MFCCs,2);
    if(nMinFrame > nFrame)
        nMinFrame = nFrame;
    end
end

features = zeros(nExamples, 13 * nMinFrame);
for i = 1:nExamples
    MFCCs = MFCCss{i};
    nFrame = size(MFCCs,2);
    cutMFCCs = MFCCss{i}(:,floor((nFrame - nMinFrame)/2)+1:floor((nFrame - nMinFrame)/2)+nMinFrame);
    f = reshape(cutMFCCs,1,13*nMinFrame);
    features(i,:)=f;
end
            
group = zeros(nExamples,1);
for i = nInhale+nExhale + 1 : nExamples
    group(i)=1;
end
             
svmStruct = svmtrain(features,group);
                        