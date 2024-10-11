
CC = g++

SRC_DIR = src
LIB_DIR = libs
INC_DIR = include
BUILD_DIR = build

# Add extra external libs here
LIBS = -L$(INC_DIR)

# Add extra compiler flags here
CCFLAGS = -I$(INC_DIR) -I$(SRC_DIR) -Wall -Wextra

# Find all .cpp files in SRC_DIR and subdirectories
SRCS = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/*/*.cpp)

# Create object files in the build directory corresponding to the source files
OBJS = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRCS))

TARGET = output

all: $(TARGET)

libs:
	cd libs

# Create build dir
$(BUILD_DIR):
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)

# Linking
$(TARGET): $(OBJS) | $(BUILD_DIR)
	$(CC) -o $(BUILD_DIR)/$@ $^ $(LIBS)

# Compiling - ensure the build directory structure is replicated
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	@if not exist $(dir $@) mkdir $(subst /,\,$(dir $@))
	$(CC) $(CCFLAGS) -c $< -o $@

# Run the program
run: $(TARGET)
	$(BUILD_DIR)/$(TARGET)

# Clean up
clean:
	-del /Q $(BUILD_DIR)\*.o $(BUILD_DIR)\$(TARGET)

.PHONY: all clean run

