function [noExhale]=silenceBreath(data)
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
   res = zeros(length(e),1);
   n = 0;
   for i = 1:length(e)
       if(e(i)>0.01)
           n = n + 1;
           if(n==3)
               res(i)=1;
               res(i-1)=1;
               res(i-2)=1;
           elseif(n>3)
               res(i)=1;
           end
       else
           n = 0;
       end
   end
   I = find(res == 1);
   figure
   subplot(2,1,1),plot(data,'b');
   subplot(2,1,2),plot(e,'g');
   hold on;
   subplot(2,1,2),plot(I,e(I),'r.')
end