function [success]=InhalePush(dInhale,dPush,dOrigin)
Fs = 44100;

dMul = dInhale.*dPush;



windowSize = 1000;

s = 1;
i = 1;
len = length(dInhale);
e = zeros(len/windowSize + 1,1);
while s + windowSize - 1 <= len
    subD = dMul(s:s+windowSize-1,1);
    e(i)= dot(subD,subD);
    i = i + 1;
    s = s + windowSize;
end

figure;
subplot(5,1,1),plot(dInhale,'r'),title('Breath(300Hz-600Hz)');
subplot(5,1,2),plot(dPush,'b'),title('Inhaler(1500Hz-1700Hz)');
subplot(5,1,3),plot(dMul,'g'),title('Breath * Inhaler');
subplot(5,1,4),plot(e,'b.'),title('Short-time Energy');
hold on;

ma = max(abs(e));
threshold = max(4*10^-7,ma/10);
res = zeros(length(e),1);
i = 1;
n = 0;
while i <= length(e)
    if(e(i)>threshold)
        n = n + 1;
        if(n == 3)
            for t = 0:n-1
            res(i-t)=1;
            end
        elseif(n>3)
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
subplot(5,1,5),plot(dOrigin),title('Overlapping Period');
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

startTime = (I(1)-2)*windowSize;
edge = (I(i-1)+10)*windowSize;

%sOverlap = startTime/44100.0
%eOverlap = edge/44100.0


subplot(5,1,5),plot(startTime,dOrigin(startTime),'r*'),text(startTime,dOrigin(startTime),num2str(startTime/44100.0),'VerticalAlignment','top');
hold on;
subplot(5,1,5),plot(edge,dOrigin(edge),'r*'),text(edge,dOrigin (edge),num2str(edge/44100.0),'VerticalAlignment','bottom');

% figure
% plot(dOrigin),title('Overlapping Period');
% hold on;
% plot(I2,dOrigin(I2),'r.');
% hold on;
% plot(startTime,dOrigin(startTime),'r*'),text(startTime,dOrigin(startTime),num2str(startTime/44100.0),'VerticalAlignment','top');
% hold on;
% plot(edge,dOrigin(edge),'r*'),text(edge,dOrigin(edge),num2str(edge/44100.0),'VerticalAlignment','bottom');


if(isempty(I))
    success = 0;
    return;
end

%whether hold breath for 3s
edgeEnd = min(len,edge+Fs*9);
[success,s,e] = silenceBreath(dInhale(edge:edgeEnd));
%if(success == 0)
%    sBreath = (edge+s)/44100.0
%    eBreath = (sBreath + s)/44100.0
%end
end
