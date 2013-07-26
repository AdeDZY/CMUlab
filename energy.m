
nSl = 9;
for i = 1:nSl
    fileName = strcat('F:\CMUlab\breath detect\trainData\sl',num2str(i),'.wav');
    w = wavread(fileName);
    w = w(:,1);
    e = dot(w,w)/length(w);
    esl(i) = log(e);
end
figure
plot(esl,'b.');
hold on;

nExhale = 22;
for i = 1:nExhale
    fileName = strcat('F:\CMUlab\breath detect\trainData\exhale',num2str(i),'.wav');
    w = wavread(fileName);
    w = w(:,1);
    e = dot(w,w)/length(w);
    exs(i) = log(e);
end
plot(exs,'r.');
hold on;

nInhale = 22;
for i = 1:nInhale
    fileName = strcat('F:\CMUlab\breath detect\trainData\inhale',num2str(i),'.wav');
    w = wavread(fileName);
    w = w(:,1);
    e = dot(w,w)/length(w);
    eis(i) = log(e);
end
plot(eis,'g.');

mean(exs)
mean(eis)