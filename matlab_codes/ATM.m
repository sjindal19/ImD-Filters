%function Oimg = ATM(Ipath)
img = imread('./img_datasets/standard_256/lake_256.tif');
nimg = imnoise(img,'salt & pepper',0.3);
[r,c] = size(nimg);
p=3;
k=1;
flg = zeros(r, c);
pimg = padarray(nimg,[p,p]); % padding is done to cal the w matrix without any errors
Oimg = pimg;
for i = 1+p:r+p
    for j = 1+p:c+p
        if (pimg(i,j)==0)||(pimg(i,j)==255)
            flg(i - p, j - p) = 0;
        else
            flg(i - p, j - p) = 1;
        end
    end
end
for i = 1 + p: r + p
    for j = 1 + p:c + p
        if (flg(i - p, j - p) == 1)
            pixel = pimg(i, j);
        else
            w = Oimg(i-k:i+k,j-k:j+k);
            nw = numel(w);
            lw = length(w);
            w(w==0)=[];
            w(w==255)=[];
            mwnf = median(w);
            na = length(w);
            if na > (nw/lw)
                pixel = mwnf;
            else 
                k=2;
                w = Oimg(i-k:i+k,j-k:j+k);
                nw = numel(w);
                lw = length(w);
                w(w==0)=[];
                w(w==255)=[];
                na = length(w);
                if na > (nw/lw)
                   pixel = median(w);
                else
                    k=1;
                    w = Oimg(i-k:i+k,j-k:j+k);
                    if (flg(1, 1) == 1) && (flg(3, 3) == 1)    %PIT 
                       pixel = (w(1,1)+w(3,3))/2;
                    elseif (flg(1, 3) == 1) && (flg(3, 1) == 1)
                       pixel = (w(1,3)+w(3,1))/2;
                    elseif (flg(2, 1) == 1) && (flg(2, 3) == 1)
                       pixel = (w(2,1)+w(2,3))/2; 
                    elseif (flg(1, 2) == 1) && (flg(3, 2) == 1)
                       pixel = (w(1,2)+w(3,2))/2;
                    elseif (flg(1, 1) == 1) && (flg(3, 3) == 1) && (flg(1, 3) == 1) && (flg(3, 1) == 1)
                       pixel = (w(1,1)+w(3,3)+w(1,3)+w(3,1))/4;
                    else
                        if (flg(1, 1) == 1) && (flg(3, 3) == 1) 
                            pixel = mwnf;
                        elseif (flg(1, 3) == 1) && (flg(3, 1) == 1)
                            pixel = Oimg(i,j-1);
                        elseif (flg(2, 1) == 1) && (flg(2, 3) == 1)
                            pixel = Oimg(i-1,j); 
                        else
                            pixel = (Oimg(i-1,j)+Oimg(i-1,j-1)+Oimg(i,j-1)+Oimg(i-1,j+1))/4;
                        end
                    end
                end
            end
        end 
        Oimg(i-p,j-p)=uint8(pixel);
     end
end
subplot(1,3,1); imshow(img);
subplot(1,3,2); imshow(nimg);
subplot(1,3,3); imshow(Oimg);
