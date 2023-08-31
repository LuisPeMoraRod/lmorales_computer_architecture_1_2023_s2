.data
  buffer: .space 256

.text
.globl _start

_start:
  # Read from stdin
  li a0, 0   # File descriptor (stdin)
  la a1, buffer # Buffer address
  li a2, 256    # Number of bytes to read
  li a7, 63     # Syscall number for read
  ecall
  
  # Write to console
  li a0, 1 # File descriptor (stdout)
  la a1, buffer # Buffer address
  li a2, 256   # Number of bytes to write
  li a7, 64    # Syscall number for write
  ecall

  # Exit the program
  li a0, 0     # Exit code
  li a7, 93    # Syscall number for exit
  ecall

