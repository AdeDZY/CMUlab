dInhale = wavread('F:\CMUlab\trainData\filterInhaleLeft.wav');
dPush = wavread('F:\CMUlab\trainData\filterPushLeft.wav');
dOrigin = wavread('F:\CMUlab\trainData\stream5.wav');

dInhale = dInhale(:,1);
dPush = dPush(:,1);
dOrigin = dOrigin(:,1);

dDiff = dInhale - dPush;
dMul = dInhale.*dPush;



windowSize = 1500;
overlapSize = 1000;

s = 1;
i = 1;
len = length(dInhale);
while s + windowSize - 1 <= len
    subD = dMul(s:s+windowSize-1,1);
    e(i)= dot(subD,subD);
    i = i + 1;
    s = s + windowSize;
end

figure;
subplot(5,1,1),plot(dInhale,'r');
subplot(5,1,2),plot(dPush,'b');
subplot(5,1,3),plot(dMul,'g');
subplot(5,1,4),plot(e,'b.');
hold on;

I = find(e>10^(-4));
subplot(5,1,4),plot(I, e(I),'r.');
I2 = zeros(length(I)*windowSize,1);
for i = 1:length(I)
    for j = 1:windowSize
        I2((i-1)*windowSize+j)=(I(i)-1)*windowSize+j-1;
    end
end
subplot(5,1,5),plot(dOrigin);
hold on;
subplot(5,1,5),plot(I2,dOrigin(I2),'r.');

