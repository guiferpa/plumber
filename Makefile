BIN_DIR ?= $(HOME)/Projects/bin
binary = plumber

install:
	@chmod +x ./$(binary)
	@cp $(binary) $(BIN_DIR)/$(binary)
