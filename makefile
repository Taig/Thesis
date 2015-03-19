project = bachelor-thesis

# Compile thesis to build/thesis.pdf
all:
	mkdir -p build/
	cd src/ && pdflatex -output-directory=../build thesis.tex

# Remove build/directory
clean:
	rm -r build/ 2> /dev/null

# Run Docker container in interactive development mode
develop:
	docker build -t $(project) .
	docker run -v $(shell pwd):/root -i -t $(project)

# Create build/thesis.pdf via Docker container
build:
	docker build -t $(project) .
	docker run -v $(shell pwd):/root $(project) make all
	open build/thesis.pdf

.PHONY: all clean develop build