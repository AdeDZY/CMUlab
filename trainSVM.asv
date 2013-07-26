function [svmStruct]=trainSVM()

Fs = 44100;

nFile = 32;
% read all the audio files
for i = 1:nFile/2
    fileName = strcat('exhale',num2str(i+4),'.wav');
    w=wavread(fileName);
    wav{i}=w(:,1);
end

for i = (nFile/2+1):nFile
    fileName = strcat('inhale',num2str(i-nFile/2+4),'.wav');
    w=wavread(fileName);
    wav{i}=w(:,1);
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
nComp = 60;        
%------------------------------------------------------


trainning = zeros(nFile,13*nComp);
for i = 1 : nFile
    [MFCCs, FBEs, frames] = mfcc( wav{i}, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
    c = princomp(MFCCs);
    m = MFCCs * c(:,1:nComp);
    trainning(i,:) = reshape(m,1,13*nComp);
end
            
group = zeros(nFile,1);
for i = nFile/2 + 1 : nFile
    group(i)=1;
end
             
svmStruct = svmtrain(trainning,group);
            
end
      

        
       