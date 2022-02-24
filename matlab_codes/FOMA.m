%function Oimg = FOMA(Ipath)
img = imread('./img_datasets/standard_256/lake_256.tif');
nimg = imnoise(img,'salt & pepper',0.6);
[r,c] = size(nimg);
p=3;
a=[];
k=1;
Oimg1=0;Oimg2=0;Oimg3=0;Oimg4=0;
pimg = padarray(nimg,[p,p]); % padding is done to cal the w matrix without any errors
Oimg = pimg;
flg= zeros(r,c);
for i = 1+p:r+p
    for j = 1+p:c+p
        if (pimg(i,j)==0)||(pimg(i,j)==255)
            flg(i - p, j - p) = 0;
        else
            flg(i - p, j - p) = 1;
        end
        if (pimg(i,j)==0)||(pimg(i,j)==255)
            w = Oimg(i-k:i+k,j-k:j+k);% forming the matrix window
            w(w==0)=[];
            w(w==255)=[];
            med3 = median(w);
            k=2;
            w = Oimg(i-k:i+k,j-k:j+k);% forming the matrix window
            w(w==0)=[];
            w(w==255)=[];
            med5 = median(w);
            if (med3 ~=0) && (med3 ~=255)
                Oimg1 = med3;
            else
                Oimg1 = med5;
            end
            pixel = Oimg1;
        end
        if (Oimg1==0)||(Oimg1==255)
            k=2;
            w = Oimg(i-k:i+k,j-k:j+k);
             w(w==0)=[];
            w(w==255)=[];
            med5 = median(w);
            Oimg2 = med5;
            pixel = Oimg2;
        end
        if (Oimg2 == 0)||(Oimg2 == 255)
            k=1;
            w = Oimg(i-k:i+k,j-k:j+k);
            w(w==0)=[];
            w(w==255)=[];
            w= w(:)';
            Oimg3 = mean(w);
            pixel = Oimg3;
        end
        if (Oimg3 == 0)||(Oimg3 == 255)
            k=1;
             w = Oimg(i-k:i+k,j-k:j+k);
             if (flg(1, 1) == 1) && (flg(3, 3) == 1) && (flg(1, 3) == 1) && (flg(3, 1) == 1)
                 Oimg4 = (w(1,1)+w(3,3)+w(1,3)+w(3,1))/4;
                 pixel = Oimg4;
             elseif (flg(1, 2) == 1) && (flg(3, 2) == 1)
                 Oimg4 = Oimg(i,j-1);
                 pixel = Oimg4;
             elseif (flg(2, 1) == 1) && (flg(2, 3) == 1)
                 Oimg4 = Oimg(i-1,j);
                 pixel = Oimg4;
             end
        end
        Oimg(i-p,j-p)=uint8(pixel);
    end
end

subplot(1,3,1); imshow(img);
subplot(1,3,2); imshow(nimg);
subplot(1,3,3); imshow(Oimg);
