.PHONY: build

build:
	@ git log -1 --format=%h > version.txt
	typst compile main.typ
	@ echo local > version.txt
