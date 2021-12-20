RPI = berry
RPIVER = 3
PYVER = 3.8

.PHONY: install
install:
	./install.sh $(RPI) $(RPIVER)

.PHONY: build
build:
	./build.sh

.PHONY: fsroot
fsroot:
	./fsroot.sh $(RPI)

.PHONY: cpython
cpython:
	./cpython.sh $(PYVER)

.PHONY: clean
clean:
	-rm -rf build
