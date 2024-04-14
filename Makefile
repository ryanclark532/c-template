# Define variables
SRC_DIR := ./src
BUILD_DIR := ./build
BIN_DIR := ./bin
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))
LIBS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/lib%.so,$(SRCS))

# Targets
all: $(BIN_DIR)/main

# Compile each .c file to .o and corresponding .so
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	gcc -c $< -o $@

$(BUILD_DIR)/lib%.so: $(BUILD_DIR)/%.o
	gcc -shared $< -o $@

# Compile main.c and link against all shared libraries
$(BIN_DIR)/main: main.c $(LIBS)
	gcc -o $@ $< -Wl,-rpath=$(BUILD_DIR) -L$(BUILD_DIR) $(patsubst $(BUILD_DIR)/lib%.so,-l%,$(LIBS))

# Clean
clean:
	rm -rf $(BUILD_DIR)/*.o $(BUILD_DIR)/*.so $(BIN_DIR)/*

# Phony targets
.PHONY: all clean

