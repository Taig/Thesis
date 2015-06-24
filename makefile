project = bachelor-thesis

build_image = docker build -f docker/$(1) -t $(project)/$(1) .

# Compile thesis to build/main.pdf
all: prepare
	find . -wholename "./src/*.tex" \
		! -path "./src/section/cover/*" \
		! -path "./src/section/affidavit/*" \
		! -path "./src/main.bib" \
		-exec aspell --lang=en --mode=tex check "{}" \;
	# Issue two compilation runs, because latex..
	cp -r ./src/* ./build/
	cd ./build && pdflatex -shell-escape main.tex
	cd ./build && bibtex main
	cd ./build && pdflatex -shell-escape main.tex

# Remove build/directory
clean:
	-@rm -r ./build 2> /dev/null

# Prepare directory structure, to prevent latex from complaining
prepare:
	mkdir -p ./build

# Run Docker container in interactive development mode
develop:
	$(call build_image,base)
	$(call build_image,develop)
	docker run -v $(shell pwd):/root/thesis -d $(project)/develop
	open build/main.pdf

# Create build/main.pdf via Docker container
build:
	$(call build_image,base)
	docker run -i -t -v $(shell pwd):/root/thesis $(project)/base make
	open build/main.pdf

# Enter interactive shell mode
debug:
	$(call build_image,base)
	docker run -v $(shell pwd):/root/thesis -i -t $(project)/base /bin/bash

.PHONY: all clean prepare develop build debug