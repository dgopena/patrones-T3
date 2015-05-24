function [p] = getRandomPerm(x, c)
    s = size(x,2);
    perm = randperm(s);
    sel = perm(1:min(c, s));
    
    p=x(:,sel);
end