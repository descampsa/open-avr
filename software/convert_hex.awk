#!/usr/bin/awk -f

# convert from intel hex format to verilog hex (with 16bits words)

BEGIN{
	mem_size = ARGV[2]
	ARGC = 2
}

{
	data_size = strtonum("0x" substr($1,2,2))
	address = strtonum("0x" substr($1,4,4))
	type = strtonum("0x" substr($1,8,2))
	if(type == 0)
	{
		for(i=0; i<(data_size/2); ++i)
		{
			mem[(address/2)+i] = substr($1,10+i*4+2,2) substr($1,10+i*4,2)
		}
	}
}

END{
	for(i=0; i<mem_size; ++i)
	{
		if(i in mem)
		{
			print mem[i]
		}
		else
		{
			print "0000"
		}
	}
}
