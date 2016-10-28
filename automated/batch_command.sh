python create.py jamie_rerun.csv
cp linuxapp/exports linuxapp/exports_crop -r
cd linuxapp/exports
find . -name "*.png" -exec mogrify {} -crop +50+50 +repage -crop -50-50 {} \;
