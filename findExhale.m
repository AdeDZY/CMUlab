[sample,Fs,nBit] = wavread('F:\CMUlab\trainData\exhale24.wav');
d = wavread('F:\CMUlab\trainData\stream3.wav');
sample = abs(sample(20000:60000,1));
data = abs(d(:,1));

lenD = length(data)
lenS = length(sample)
step = 5000;
s = 1;
i = 1;
res = zeros(lenD/step,1);
while s + lenS<=lenD
    res(i)=dot(sample,data(s:s+lenS-1));
    e = s + lenS - 1;
    i = i + 1;
    s = s + step;
end
res = res(1:i-1);
d = d(1:e);
data = data(1:e);
figure
subplot(2,1,1),plot(d,'b');
hold on;
subplot(2,1,2),plot(res,'g');
hold on;

Q3 = prctile(res,75);
I = find(res>Q3);
subplot(2,1,2),plot(I,res(I),'r.');


I2 = zeros(lenD,1);
%ith group: [(i-1)*step+1, (i-1)*step+lenS]
for j = 1:length(I)
    i = I(j);
    for t = (i-1)*step+1:(i-1)*step+lenS
        I2(t)=1;
    end
end
I2 = find(I2==1);

subplot(2,1,1),plot(I2,d(I2),'r.');


