dInhale = wavread('F:\CMUlab\trainData\filterInhaleLeft5.wav');
dPush = wavread('F:\CMUlab\trainData\filterPushLeft5.wav');
dOrigin = wavread('F:\CMUlab\trainData\stream8.wav');
Fs = 44100;

dInhale = dInhale(:,1);
dPush = dPush(:,1);
dOrigin = dOrigin(:,1);

dDiff = dInhale - dPush;
dMul = dInhale.*dPush;



windowSize = 1000;

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

ma = max(abs(e));
threshold = ma/8;
res = zeros(len,1);
i = 1;
n = 0;
while i <= length(e)
    if(e(i)>threshold)
        n = n + 1;
        if(n == 2)
            res(i)=1;
            res(i-1)=1;
            %res(i-2)=1;
        elseif(n>2)
            res(i)=1;
        end
    else
        n = 0;
    end
    i= i + 1;
end

I = find(res==1);
subplot(5,1,4),plot(I, e(I),'r.');
I2 = zeros(length(I)*windowSize,1);
for i = 1:length(I)
    for j = 1:windowSize
        I2((i-1)*windowSize+j)=(I(i)-1)*windowSize+j;
    end
end
subplot(5,1,5),plot(dOrigin);
hold on;
subplot(5,1,5),plot(I2,dOrigin(I2),'r.');
hold on;

%edge detection
i = 2;
while i < length(I)
    if(I(i)==I(i-1)+1)
        i = i + 1;
        continue;
    else
        break;
    end
end
edge = (I(i)+10)*windowSize;
subplot(5,1,5),plot(edge,dOrigin(edge),'g*');

%whether hold breath for 3s
edgeEnd = min(len,edge+Fs*3);
silenceExhale(dInhale(edge:edgeEnd))
