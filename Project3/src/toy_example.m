function x = toy_example(img_file)
im = imread(img_file);
im = im2double(im);
[imh, imw, nn] = size(im);
im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw; 

A = sparse((imh-1)*imw+(imw-1)*imh+1,imh*imw);
e=0;

for y = 1:imh
    for x = 1:imw-1
        e=e+1;
        A(e, im2var(y,x+1))=1;
        A(e, im2var(y,x))=-1;
        b(e) = im(y,x+1)-im(y,x);
    end
end

for x = 1:imw
    for y = 1:imh-1
        e=e+1;
        A(e, im2var(y+1,x))=1;
        A(e, im2var(y,x))=-1;
        b(e) = im(y+1,x)-im(y,x);
    end
end

e=e+1;
A(e, im2var(1,1))=1;
b(e)=im(1,1); 

v = lscov(A,b');

x = reshape(v,[size(im,1) size(im,2)]);
end