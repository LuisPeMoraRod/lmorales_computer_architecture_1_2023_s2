.data
  buffer_orig: .space 307200
  buffer_new: .space 307200

.equ IMG_SIZE, 307200
.equ STDIN, 0
.equ STDOUT, 1
.equ SYS_READ, 63
.equ SYS_WRITE, 64
.equ SYS_EXIT, 93

.text
.globl _start

_start:
  # Read from stdin
  li a0, STDIN   # File descriptor (stdin)
  la a1, buffer_orig # Buffer address
  li a2, IMG_SIZE     # Number of bytes to read
  li a7, SYS_READ     # Syscall number for read
  ecall
  
  # Write to console
  li a0, STDOUT   # File descriptor (stdout)
  la a1, buffer_new # Buffer address
  li a2, IMG_SIZE   # Number of bytes to write
  li a7, SYS_WRITE    # Syscall number for write
  ecall

_exit:
  # Exit the program
  li a0, 0     # Exit code
  li a7, SYS_EXIT  # Syscall number for exit
  ecall

