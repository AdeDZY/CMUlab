clear
M_bar = dlmread('F:\CMUlab\breath detect\M_bar.dat');
M_V = dlmread('F:\CMUlab\breath detect\M_V.dat');

threshold = 360;
ml = 31519;
windowSize = ml;

data = wavread('F:\CMUlab\trainData\730\7304.wav');
data = data(:,1);

s = 1;
len = length(data);
i = 1;
res = zeros(len/windowSize,1);
while s + windowSize - 1 < len
    subdata = data(s:s+windowSize - 1);
    d = MFCCDistance(subdata,M_bar,M_V);
    res(i)=d;
    i = i + 1;
    s = s + windowSize;
end
figure
subplot(2,1,1),plot(data),title('Input Signal');
hold on;
subplot(2,1,2),plot(res,'b'),title('Distance');
hold on;
subplot(2,1,2),plot(1:length(res),threshold,'r'),text(length(res)/5*4,threshold,strcat('threshold = ',num2str(threshold)),'VerticalAlignment','top');
hold on;

I = find(res<=threshold);
for j = 1:length(I)
    subI = (I(j)-1)*windowSize+1:I(j)*windowSize;
    subplot(2,1,1),plot(subI,data(subI),'g.');
    hold on;
end