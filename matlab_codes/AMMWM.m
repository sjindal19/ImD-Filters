
%function Oimg = AMMWM(Ipath)
img = imread('./img_datasets/standard_256/lake_256.tif');
nimg = imnoise(img,'salt & pepper',0.3);
[r,c] = size(nimg);
p=3;
a=[];
k=1;
pimg = padarray(nimg,[p,p]); % padding is done to cal the w matrix without any errors
Oimg = pimg;
for i = 1+p:r+p
    for j = 1+p:c+p
        if (pimg(i,j)==0)||(pimg(i,j)==255)
            w = Oimg(i-k:i+k,j-k:j+k);% forming the matrix window
            w(w==0)=[];
            w(w==255)=[];
            na = length(w);
            if na ~= 0
               pix = TVL(w);
               pixel = pix; 
            else
                 k=k+1;
                 if k > 3
                     k=1;
                 end
            end 
        end
        Oimg(i-p,j-p)=uint8(pixel);
    end 
end
subplot(1,3,1); imshow(img);
subplot(1,3,2); imshow(nimg);
subplot(1,3,3); imshow(Oimg);



function pix = TVL(a) % two valued logic
na = length(a);
bmax = max(a);
bmin = min(a) ;
dmin = abs(a-bmin);
dmax = abs(bmax-a);
gmax = []; 
gmin = [];
for m = 1:na
    if dmax(m) < dmin(m)
        gmax = [gmax,a(m)]; 
    else
        gmin = [gmin,a(m)];
    end
end
nmax = length(gmax);
nmin = length(gmin);
pmax = nmax/na;
pmin = nmin/na;
if pmax==0
    pix = median(gmax);
elseif pmin == 0 
    pix = median(gmin);
else
    pix = pmax*median(gmax) + pmin*median(gmin) ;
end
end