/* srand example */
#include <stdio.h>      /* printf, NULL */
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */
#include <string.h>

int main (int argc, char *argv[])
{
	
	int srand_value = atoi(argv[1]);
	const char *hex = argv[2];
	int flag_len = strlen(hex)/2;

	unsigned char flag[] = {
		0x3e, 0xc6, 0x3c, 0xc4, 0x1f, 0x1a, 0xc1, 0x98,
		0x06, 0x51, 0x72, 0x6a, 0xb3, 0xce, 0x29, 0x48,
		0x88, 0x2b, 0x87, 0x9c, 0x19, 0x67, 0x12, 0x69,
		0x96, 0x3e, 0x39, 0x10, 0x3c, 0x83, 0xeb, 0xd6,
		0xef, 0x17, 0x3d, 0x60, 0xc7, 0x6e, 0xe5
	    };	

	for(int j=0;j<10000;j++){
		unsigned char sol_flag[flag_len+1];
		for(int i=0;i<flag_len+1;i++)
			sol_flag[i]=0;
		srand (srand_value+j);
		printf("srand_value: %d\n", srand_value);
		for(int i=0;i<=999;i++)
			rand();

		for(int i=0;i<flag_len;i++){
			unsigned char value = rand() & 0xFF;
			sol_flag[i] = flag[i] ^ value;
		}
		printf("flag: %s\n", sol_flag);
		if(sol_flag[0] == 'b' & sol_flag[1] == 'r')
			break;
	}

	return 0;
}
