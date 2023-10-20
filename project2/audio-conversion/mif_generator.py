def generate_mif_file(file_name, data_width, depth):
    with open(file_name, 'w') as mif_file:
        mif_file.write(f"DEPTH = {depth};\n")
        mif_file.write(f"WIDTH = {data_width};\n")
        mif_file.write("ADDRESS_RADIX = HEX;\n")
        mif_file.write("DATA_RADIX = HEX;\n")
        mif_file.write("CONTENT\n")
        mif_file.write("BEGIN\n")
        
        for address in range(depth):
            # Generate some sample data 
            data = address & 0xFF  # 8 bit data
            mif_file.write(f"{address:05X} : {data:04X};\n")
        
        mif_file.write("END;\n")

if __name__ == "__main__":
    file_name = "ram_example.mif"
    data_width = 8  # Width of each memory location in bits
    depth = 0x40000  # 3FFFF in hexadecimal

    generate_mif_file(file_name, data_width, depth)
