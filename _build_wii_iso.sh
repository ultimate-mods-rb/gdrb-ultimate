dependencies/wit/wit extract ./iso ./_build/wii
rm ./_build/wii/sys/main.dol
rm ./_build/wii/setup.txt
cp ./dependencies/patch/main.dol ./_build/wii/sys
cp ./dependencies/patch/setup.txt ./_build/wii

cp ./_build/wii_rebuild_files/main_wii.hdr ./_build/wii/files/gen
rm ./_build/wii/files/gen/main_wii_10.ark
dependencies/arkhelper patchcreator -a ./_ark -o ./_build/wii/files/gen ./_build/wii/files/gen/main_wii.hdr
mv ./_build/wii/files/gen/gen/main_wii.hdr ./_build/wii/files/gen
mv ./_build/wii/files/gen/gen/main_wii_10.ark ./_build/wii/files/gen
rmdir ./_build/wii/gen/gen

rm ./iso/GDRB\ Ultimate.iso
dependencies/wit/wit copy ./_build/wii ./iso/GDRB\ Ultimate.iso

echo "GDRB ultimate should've successfully built. copy the iso to your console to play. enjoy :)"