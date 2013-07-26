function [ftr]=getFeature(MFCCs,nComp)
coev = princomp(MFCCs);
ftr = MFCCs * coev(:,1:nComp);
ftr = reshape(ftr,1,13*nComp);
end