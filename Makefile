RPI = berry

.PHONY: install
install:
	./install.sh $(RPI)

.PHONY: build
build:
	./build.sh

.PHONY: build
build:
	./fsroot.sh $(RPI)

.PHONY: clean
clean:
	-rm -rf build
