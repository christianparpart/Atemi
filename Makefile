
VERSION=0.2.0
PREFIX=${HOME}/World of Warcraft/Interface/AddOns/Atemi

FILES=embeds.xml Atemi.lua Atemi.toc AtemiCooldown.lua FreeUniversal-Regular.ttf README TODO

dist:
	rm -rf Atemi
	mkdir -p Atemi
	cp -rvp ${FILES} Atemi/
	cp -rvp locale Atemi/
	cp -rvp libs Atemi/
	zip -9 Atemi-${VERSION}.zip -r Atemi
	rm -rf Atemi

copy:
	@echo "Installing into ${PREFIX} ..."
	rm -rf "${PREFIX}"/*
	mkdir -p "${PREFIX}"
	cp -rp * "${PREFIX}"

.PHONY: dist copy
