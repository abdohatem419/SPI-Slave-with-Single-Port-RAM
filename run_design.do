vlib work
vlog RAM.v SLAVE.v SPI_Wrapper.v SPI_Master_tb.v 
vsim -voptargs=+acc work.SPI_Master_tb
add wave *
add wave -position insertpoint  \
sim:/SPI_Master_tb/SPI1/m1/din \
sim:/SPI_Master_tb/SPI1/m1/rx_valid \
sim:/SPI_Master_tb/SPI1/m1/dout \
sim:/SPI_Master_tb/SPI1/m1/tx_valid \
sim:/SPI_Master_tb/SPI1/m1/mem \
sim:/SPI_Master_tb/SPI1/m1/stored_command \
sim:/SPI_Master_tb/SPI1/s1/tx_data \
sim:/SPI_Master_tb/SPI1/s1/rx_data \
sim:/SPI_Master_tb/SPI1/s1/counter \
sim:/SPI_Master_tb/SPI1/s1/allow_memorize \
sim:/SPI_Master_tb/SPI1/s1/ns \
sim:/SPI_Master_tb/SPI1/s1/cs

run -all
#quit -sim