binary = plumber
binaryalias = plr

BIN_DIR ?= /usr/local/bin
DIST_DIR ?= $(PWD)/bin

BUILD := $(DIST_DIR)/$(binaryalias)
PLUMBER := $(BIN_DIR)/$(binaryalias)

.PHONY: clean all test

all: $(BUILD) $(PLUMBER) test

test:
	bats $(shell find ./lib/*.test.sh -type f)
	rm -rf ./tmp

$(PLUMBER):
	ln -s $(BUILD) $(PLUMBER)

$(BUILD):
	koala $(binary) $(BUILD)

clean:
	rm -rf $(PLUMBER)
	rm -rf $(BUILD)
