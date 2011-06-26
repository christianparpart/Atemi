
VERSION=0.1.0-r1
PREFIX=${HOME}/World of Warcraft/Interface/AddOns/Atemi

dist:
	mkdir -p Atemi
	cp -rvp libs *.lua *.toc README TODO *.ttf embeds.xml Atemi
	zip -9 Atemi-${VERSION}.zip -r Atemi
	rm -rf Atemi

copy:
	@echo "Installing into ${PREFIX} ..."
	rm -rf "${PREFIX}"
	mkdir -p "${PREFIX}"
	cp -rp * "${PREFIX}"

.PHONY: dist copy
