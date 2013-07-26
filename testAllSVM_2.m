function [g]=testAllSVM_2(svmStruct,nMinFrame)
nSl = 1;
nExhale = 14;
nInhale = 14;
% read all the audio files
for i = 1:nExhale
    fileNames{i} = strcat('F:\CMUlab\breath detect\trainData\exhale',num2str(i+8),'.wav');
end

for i = 1:nInhale
    fileNames{i+nInhale} = strcat('F:\CMUlab\breath detect\trainData\inhale',num2str(i+8),'.wav');
end

for i = 1:nSl
    fileNames{i+nInhale+nExhale} = strcat('F:\CMUlab\breath detect\trainData\sl',num2str(i+9),'.wav');
end

nTestData =  1:nExhale+nInhale+nSl;
g = zeros(nTestData,1);

for i = nTestData
    g(i) = testSingleSVM_2(svmStruct,fileNames{i},nMinFrame);
end

end