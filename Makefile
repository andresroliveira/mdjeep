################################################################################################################
# Name:       MD-jeep
#             the Branch & Prune algorithm for discretizable Distance Geometry - makefile
# Author:     A. Mucherino, D.S. Goncalves, C. Lavor, L. Liberti, J-H. Lin, N. Maculan
# Sources:    ansi C
# License:    GNU General Public License v.3
# History:    May 01 2010  v.0.1    first release
#             May 10 2014  v.0.2    second release (no files added)
#             Jul 28 2019  v.0.3.0  third release (added files vertex.c, distance.c, objfun.c, spg.c, splitime.c)
#             Mar 21 2020  v.0.3.1  no new files added
#             May 19 2020  v.0.3.2  file readfile.c added
#             Apr 13 2022  v.0.3.2  patch
#################################################################################################################


TARGET = mdjeep

SRC_DIR = src
OBJ_DIR = build
BIN_DIR = bin

SOURCES = $(wildcard $(SRC_DIR)/*.c)

OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SOURCES))

CC = gcc
CFLAGS = -Wall -Wextra -O3 -ggdb -Iinc
CLIBS = -lm

EXECUTABLE = $(BIN_DIR)/$(TARGET)

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@ $(CLIBS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@ $(CLIBS)

$(shell mkdir -p $(OBJ_DIR) $(BIN_DIR))

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all clean
