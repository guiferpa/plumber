binary = plumber
binaryalias = plr

BIN_DIR ?= /usr/local/bin
DIST_DIR ?= $(PWD)/bin

BUILD := $(DIST_DIR)/$(binaryalias)
PLUMBER := $(BIN_DIR)/$(binaryalias)

.PHONY: clean all

all: $(BUILD) $(PLUMBER)

$(PLUMBER):
	ln -s $(BUILD) $(PLUMBER)

$(BUILD):
	koala $(binary) $(BUILD)

clean:
	rm -rf $(PLUMBER)
	rm -rf $(BUILD)
