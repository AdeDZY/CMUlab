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

v = zeros(2,nInhale);
for i = 1:nInhale
    v(1,i)=std(wav{i});
end
for i = 1:nExhale
    v(2,i)=std(wav{i+nInhale});
end
figure
plot(v(1,:),'r.');
hold on;
plot(v(2,:),'b*');