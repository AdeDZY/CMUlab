function []=trainFindBreathMFCC()

%-------------------read trainning set----------------
ml = 31519;
N = 18;
for i = 1:N
    file = strcat('F:\CMUlab\trainData\exhale\',num2str(i),'.wav');
    data{i}=wavread(file);
    if(length(data{i})<ml)
    data{i} = [data{i};data{i}];
    end
    data{i}=data{i}(1:ml,1);
end

%-------------------extract Mfcc features-------------
Tw = 100;
Ts = 50;
alpha = 0.97;
R = [200,3000];
Ma = 20;
C = 13;
L = 22;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

for i = 1:N
    [ MFCC, FBEs, frames ] = mfcc( data{i}, 44100, Tw, Ts, alpha, hamming, R, Ma, C, L );
    M{i}=MFCC;
end

%-------------------get mean and variance-------------
sizeMFCC = size(MFCC);
M_bar = zeros(sizeMFCC);
for i = 1:N
    M_bar = M_bar + M{i};
end
M_bar = M_bar/N

M_V = zeros(sizeMFCC);
for i = 1:sizeMFCC(1)
    for j = 1:sizeMFCC(2)
        for t = 1:N
            M_V(i,j)=M_V(i,j)+(M{t}(i,j)-M_bar(i,j))^2;
        end
    end
end
M_V = M_V/(N-1)
%---------------------write back---------------
dlmwrite('F:\CMUlab\breath detect\M_bar.dat',M_bar);
dlmwrite('F:\CMUlab\breath detect\M_V.dat',M_V);

end