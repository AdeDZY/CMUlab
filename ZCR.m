function [zcr]=ZCR(data)
len = length(data);
% m = mean(data);
% data = data - m;


zcr = 0;
sgn = sign(data);
for i = 1:len-1
   zcr = zcr + abs(sgn(i+1)-sgn(i)); 
end
zcr = double(zcr)/length(data);

end