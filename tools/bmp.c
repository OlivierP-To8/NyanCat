/*******************************************************************************
 * Rapide programme pour transformer un bmp 16 couleurs en data asm
 * Auteur : OlivierP 
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
	if (argc < 3)
		printf("usage : %s fichier.bmp nom\n", argv[0]);
	else
	{
		FILE *f = fopen(argv[1], "rb");
		if (f != NULL)
		{
			printf("%s\n", argv[2]);

			fseek(f, 18, SEEK_SET);
			char w = fgetc(f);

			fseek(f, 22, SEEK_SET);
			char h = fgetc(f);

			int pitch = (w%8) ? ((w>>3)+1)<<3 : w;

			fseek(f, 0, SEEK_END);
			int pos = ftell(f);

			for (int i=h; i>0; i--)
			{
				pos -= pitch/2;
				fseek(f, pos, SEEK_SET);
				for (int j=0; j<w/2; j++)
				{
					unsigned char c = fgetc(f);
					printf("   FCB $%02x\n", (int)c);
				}
				printf("   FCB $EE\n");
				int reste = (i==1) ? 0 : 40 + 40 - w/4;
				printf("   FCB $%02x\n\n", reste);
			}
			fclose(f);
		}
        else printf("impossible d'ouvrir %s\n", argv[1]);
	}
    return 0;
}
