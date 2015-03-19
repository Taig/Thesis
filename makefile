project = bachelor-thesis

build_image = docker build -f docker/$(1) -t $(project)/$(1) .

# Compile thesis to build/main.pdf
all:
	$(prepare)
	cd src/ && pdflatex -output-directory=../build main.tex

# Remove build/directory
clean:
	rm -r build/ 2> /dev/null

# Prepare directory structure, to prevent latex from complaining
prepare:
	mkdir -p build/
	cd build/ && (cd ../src; find . -type d ! -name .) | xargs -i mkdir -p "{}"

# Run Docker container in interactive development mode
develop:
	$(call build_image,base)
	$(call build_image,develop)
	docker run -v $(shell pwd):/root -d $(project)/develop
	open build/main.pdf

# Create build/main.pdf via Docker container
build:
	$(call build_image,base)
	docker run -v $(shell pwd):/root $(project)/base make
	open build/main.pdf

# Enter interactive shell mode
debug:
	$(call build_image,base)
	docker run -v $(shell pwd):/root -i -t $(project)/base /bin/bash

.PHONY: all clean develop build