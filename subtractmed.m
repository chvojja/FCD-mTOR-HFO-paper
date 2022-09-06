function s = subtractmed(s)
%SUBTRACTMED Summary of this function goes here
%   Detailed explanation goes here
     s = double( s  );
     med_s = median(s);
     s = s-med_s;
end

