%In this folder, you will find two images img1.tif and img2.tif that have
%some overlap. Use two different methods to align them - the first based on
%pixel values in the original images and the second using the fourier
%transform of the images. In both cases, display your results. 
clear all
%first method: pixel-value-based
img1=imread('img1.tif');
img2=imread('img2.tif');
diff=zeros(1,500);

for ov=1:length(img1)-1
    pix1=img1((end-ov):end, :);
    pix2=img2(1:(1+ov), :);
    diffs(ov)=sum(sum(abs(pix1-pix2)))/ov;
end
for ov=1:length(img1)-1
    pix1=img1(:,(end-ov):end);
    pix2=img2(:, 1:(1+ov));
    diffs(ov)=sum(sum(abs(pix1-pix2)))/ov;
end
figure(1)
plot(diffs) %doesn't look good (as expected)

[~, overlap]=min(diffs);
img2_align=[zeros(800, size(img2,2)-overlap+1), img2];
figure(2)
imshowpair(img1,img2_align) %total fail

%second method: using fourier transform
img1_ft=fft2(img1);
img2_ft=fft2(img2);
[nr, nc]=size(img2_ft);
CC=ifft2(img2_ft.*conj(img2_ft));
CCabs=abs(CC);

[row_shift, col_shift]=find(CCabs==max(CCabs(:)));
Nr=ifftshift(-fix(nr/2):ceil(nr/2)-1);
Nc=ifftshift(-fix(nc/2): ceil(nc/2)-1);
row_shift=Nr(row_shift);
col_shift=Nc(col_shift);

img_shift=zeros(size(img2)+[row_shift, col_shift]);
img_shift(1:end, 1:end)=img2;
figure(3)
imshowpair(img1, img_shift)


