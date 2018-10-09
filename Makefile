binary = plumber

BIN_DIR ?= /usr/local/bin
DIST_DIR ?= $(PWD)/bin

BUILD := $(DIST_DIR)/$(binary)
KOALA := $(BIN_DIR)/koala
PLUMBER := $(BIN_DIR)/$(binary)

.PHONY: clean

all: $(BUILD) $(PLUMBER)

$(PLUMBER):
	ln -s $(BUILD) $(PLUMBER)

$(BUILD):
	koala $(binary) $(BUILD)

clean:
	rm -rf $(PLUMBER)
	rm -rf $(BUILD)
