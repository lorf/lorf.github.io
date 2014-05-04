all: android-package-list.html

android-package-list.html: android-package-list.txt android-package-list-2html.sh
	sh -x ./android-package-list-2html.sh < $< > $@

clean:
	-rm -f android-package-list.html

upload:
	adb push android-package-list.html /mnt/sdcard/
