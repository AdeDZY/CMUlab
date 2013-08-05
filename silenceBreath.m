function [noBreath,sTime,eTime]=silenceBreath(data)
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
   %Q1 = prctile(e,25);
   Q3 = prctile(2,75);
   threshold = max(0.005,1.3*mean(e(e<Q3)));
   for i = 1:length(e)
       if(e(i)>threshold)
           n = n + 1;
           if(n==8)
             for t = 0:n-1
                res(i-t)=1;
             end
           elseif(n>8)
               res(i)=1;
           end
       else
           n = 0;
       end
   end
   I = find(res == 1);
   
   figure
   subplot(2,1,1),plot(data,'b'),title('Data');
   hold on;
   subplot(2,1,2),plot(e,'g'),title('Short-time Energy');
   hold on;
   subplot(2,1,2),plot(I,e(I),'r.')
   if(isempty(I))
       noBreath = 1;
       sTime = -1;
       eTime = -1;
   else
       noBreath = 0;
       sTime = (I(1)-1)*windowSize+1;
       for i = 1:length(I)-1
           if(I(i)==I(i+1)-1)
               continue;
           else
               break;
           end
       end
       eTime = I(i)*windowSize;
       subplot(2,1,1),plot(sTime,data(sTime),'r*'),text(sTime,data(sTime),num2str(sTime/44100.0),'VerticalAlignment','top');
       hold on;
       subplot(2,1,1),plot(eTime,data(eTime),'r*'),text(eTime,data(eTime),num2str(eTime/44100.0),'VerticalAlignment','bottom');
   end
end