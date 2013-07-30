function []=silenceExhale(data)
    windowSize = 1000;
   s = 1;
   len = length(data);
   i = 1;
   e = zeros(len/windowSize+1,1);
   while s + windowSize - 1 <len
       e(i)=dot(data(s:s+windowSize-1),data(s:s+windowSize-1));
       i = i + 1;
       s = s + windowSize;
   end
   I = find(e>0.01);
   figure
   subplot(2,1,1),plot(data,'b');
   subplot(2,1,2),plot(e,'g');
   hold on;
   subplot(2,1,2),plot(I,e(I),'r.')
end