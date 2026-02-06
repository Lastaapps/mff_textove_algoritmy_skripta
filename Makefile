.PHONY: build

build:
	@ git log -1 --format=%h > version.txt
	typst compile main.typ "Text Algorithms.pdf"
	@ echo local > version.txt
