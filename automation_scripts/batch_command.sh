python create.py HD-images-from-filming.csv
cp linuxapp/exports linuxapp/exports_crop -r
cd linuxapp/exports_crop
find . -name "1*.png" -exec mogrify {} -crop +380+135 +repage -crop -0-135 {} \;
