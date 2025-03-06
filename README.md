# Conway's Game of Life in Assembly

This project implements Conway's Game of Life in x86 Assembly with an additional symmetric encryption system based on the game's evolution patterns.

Conway's Game of Life is a zero-player, two-dimensional cellular automaton. The game simulates a population of cells that evolve according to specific rules, creating a Turing-complete system.

## Game Rules

1. **Underpopulation**: Any live cell with fewer than two live neighbors dies
2. **Survival**: Any live cell with two or three live neighbors continues to live
3. **Overpopulation**: Any live cell with more than three live neighbors dies
4. **Reproduction**: Any dead cell with exactly three live neighbors becomes alive
5. **Continuity of dead cells**: All other dead cells remain dead

## Features

This implementation offers three main functionalities:

### 1. Game Evolution (0x00)
- Simulates k iterations of Conway's Game of Life
- Accepts initial configuration and number of iterations
- Displays the final state of the system

### 2. Symmetric Encryption/Decryption (0x01)
- Uses the Game of Life evolution as a key generation mechanism
- Performs XOR-based encryption and decryption of messages
- Supports plaintext to hexadecimal encryption
- Supports hexadecimal to plaintext decryption

### 3. File-Based Operations (0x02)
- Implements the same evolution functionality as 0x00
- Reads input from `in.txt`
- Writes output to `out.txt`

## Input Format

### For Game Evolution (0x00):
```
m       // Number of rows
n       // Number of columns
p       // Number of live cells
r1 c1   // Position of first live cell
r2 c2   // Position of second live cell
...
rp cp   // Position of last live cell
k       // Number of iterations
```

### For Encryption/Decryption (0x01):
```
m       // Number of rows
n       // Number of columns
p       // Number of live cells
r1 c1   // Position of first live cell
...
rp cp   // Position of last live cell
k       // Number of iterations
0/1     // 0 for encryption, 1 for decryption
message // Message to encrypt/decrypt
```

## Usage

### Running the Program
For standard input:
```bash
./task00 < input.txt
```

For file-based operations:
```bash
./task02
```
(This will read from in.txt and write to out.txt)

## Constraints
- 1 ≤ m ≤ 18
- 1 ≤ n ≤ 18
- p ≤ n·m
- k ≤ 15
- Messages are alphanumeric with maximum 10 characters
- Encrypted messages are in hexadecimal format starting with 0x
