function im_blend = poissonBlend(im_s,mask_s,im_t)

[imh, imw, nn] = size(im_s);
im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw; 

A = sparse(imh*imw,imh*imw);
e = 0;
b = zeros(imw*imh,3);

for y = 1:imh
    for x = 1:imw
        e=e+1;
        if mask_s(y,x) == 1
            A(e, im2var(y,x))=4;
            A(e, im2var(y,x-1))=-1;
            A(e, im2var(y,x+1))=-1;
            A(e, im2var(y-1,x))=-1;
            A(e, im2var(y+1,x))=-1;
            b(e,:) = 4*im_s(y,x,:)-im_s(y,x-1,:)-im_s(y,x+1,:)-im_s(y-1,x,:)-im_s(y+1,x,:);
        else
            A(e, im2var(y,x))=1;
            b(e,:) = im_t(y,x,:);
        end
    end
end

v = lscov(A,b);

im_blend = reshape(v,size(im_s));
end


