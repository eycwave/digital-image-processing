clear all, close all; clc

% Adım 1: Resmi oku ve grayscale'e çevir.
I = imread('surface_cracks.png');
if size(I, 3) == 3
    Igry = rgb2gray(I);
else
    Igry = I; % İlgilendiğimiz görsel gri formatta olduğu için otomatik olarak bu kullanılacak.
end

% Adım 2: Tuz-Biber gürültüsünü kaldırmak için Medyan filtre uygula. 
Imed = medfilt2(Igry, [5, 5]);

% Adım 3: Adaptive thresholding uygula.
Ibw = imbinarize(Imed, 'adaptive', 'Sensitivity', 0.5, 'ForegroundPolarity', 'dark');

% Adım 4: Binary resmi Invert et. (black ↔ white)
Iinv = ~Ibw;

% Adım 5: Opening - Resimde nesneler arası kesişmeyi kaldır, gürültüleri temizle.
se = strel('disk', 3); % YAPISAL ELEMAN SEÇİMİ
I_cls = imopen(Iinv, se);

% Adım 6: bwareaopen - Küçük nesneleri kaldır, en büyük çatlağı koru.
I_bwopen = bwareaopen(I_cls, 5700);

% Adım 7: Çatlağın tüm resme oranını hesapla
[height, width] = size(I);
total_area = height * width;
crack_area = sum(I_bwopen(:));
crack_percentage = crack_area / total_area;
res = labeloverlay(I, I_bwopen);
figure;
subplot(1, 1, 1), imshow(res, []), title('Overlay');

% Adım 8: Oranı ve alanı ekrana yazdır
fprintf('Çatlağın kapladığı alan: %d piksel\n', crack_area);
fprintf('Toplam görüntü alanı: %d piksel\n', total_area);
fprintf('Çatlağın tüm resme oranı: %.2f%%\n', crack_percentage);

% Adım 10: Sonuçları ekrana bas.
figure;
subplot(2, 3, 1), imshow(Igry, []), title('Grayscale Image');
subplot(2, 3, 2), imshow(Imed, []), title('After Median Filter');
subplot(2, 3, 3), imshow(Ibw, []), title('Adaptive Thresholding');
subplot(2, 3, 4), imshow(Iinv, []), title('Inverted Image');
subplot(2, 3, 5), imshow(I_cls, []), title('After Opening');
subplot(2, 3, 6), imshow(I_bwopen, []), title('After bwareaopen');