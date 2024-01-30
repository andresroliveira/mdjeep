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


# Nome do seu programa
TARGET = mdjeep

# Diretórios de origem, objeto e binário
SRC_DIR = src
OBJ_DIR = build
BIN_DIR = bin

# Lista de arquivos-fonte
SOURCES = $(wildcard $(SRC_DIR)/*.c)

# Gera a lista de arquivos-objeto com base nos arquivos-fonte
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SOURCES))

# Compilador e opções
CC = gcc
CFLAGS = -Wall -Wextra -O3 -ggdb -Iinc
CLIBS = -lm

# Nome do arquivo executável final
EXECUTABLE = $(BIN_DIR)/$(TARGET)

# Regra principal para a construção do executável
all: $(EXECUTABLE)

# Regra para a construção do executável
$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@ $(CLIBS)

# Regra para a construção dos arquivos-objeto
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@ $(CLIBS)

# Criação dos diretórios se não existirem
$(shell mkdir -p $(OBJ_DIR) $(BIN_DIR))

# Regra para limpar arquivos temporários e o executável
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Aviso para o usuário
.PHONY: all clean
