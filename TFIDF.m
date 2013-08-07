function [RES]=TFIDF(M)
    S = sum(M,2);
    h = size(M,1);
    w = size(M,2);
    TF = zeros(h,w);
    for i = 1:h
        TF(i,:)= double(M(i,:))/S(i);
    end

    IDF = zeros(1,w);
    for i = 1:w
        IDF(i)=log(double(h)/length(find(M(:,i)~=0)));
    end
    
    RES = zeros(h,w);
    for i = 1:h
        for j = 1:w
            RES(i,j)=TF(i,j)*IDF(j);
        end
    end
end