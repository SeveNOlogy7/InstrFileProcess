function [ I_l,I_r,Tw ] = findFWHM( X,Y )
%FINDFWHM ¼ÆËã°ë¸ßÈ«¿í

[Max,Max_I] = max(Y);
I_l = find(abs(Y(1:Max_I) - Max/2) == min(abs(Y(1:Max_I) - Max/2)));
I_r = find(abs(Y(Max_I:end) - Max/2) == min(abs(Y(Max_I:end) - Max/2)))+Max_I;
Tw = mean(X(I_r))-mean(X(I_l));

end

