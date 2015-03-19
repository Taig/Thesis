project = bachelor-thesis

build_image = docker build -f docker/$(1) -t $(project)/$(1) .

# Compile thesis to build/thesis.pdf
all:
	mkdir -p build/
	cd src/ && pdflatex -output-directory=../build thesis.tex

# Remove build/directory
clean:
	rm -r build/ 2> /dev/null

# Run Docker container in interactive development mode
develop:
	$(call build_image,base)
	$(call build_image,develop)
	docker run -v $(shell pwd):/root -d $(project)/develop
	open build/thesis.pdf

# Create build/thesis.pdf via Docker container
build:
	$(call build_image,base)
	docker run -v $(shell pwd):/root $(project)/base make
	open build/thesis.pdf

.PHONY: all clean develop build