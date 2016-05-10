/*******************************************************************************
 * Rapide programme pour transformer un snd 8 bits en 6 bits
 * Auteur : OlivierP 
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char **argv)
{
	if (argc < 3)
		printf("usage : %s fichier.snd nom\n", argv[0]);
	else
    {
        FILE *f = fopen(argv[1], "rb");
        if (f != NULL)
        {
			fseek(f, 0, SEEK_END);
			int taille = ftell(f);

			int nb = ceil((float)taille / 16384.0f);
			int nbb = taille / nb;
			printf("%d samples de %d octets chacun\n", nb, nbb);
			
			fseek(f, 0, SEEK_SET);
			for (int i=0; i<nb; i++)
			{
				char filename[1024];
				sprintf(filename, "%s%02d.asm", argv[2], i+1);
				FILE *fout = fopen(filename, "w");
				if (fout != NULL)
				{
					fprintf(fout, "(main)%s\n", filename);
					fprintf(fout, "   ORG $A000\n");
					fprintf(fout, "SAMPLE\n");
					for (int j=0; j<nbb; j++)
		            {
		                unsigned char c = fgetc(f);
		                fprintf(fout, "      FCB $%02x\n", c/4);
		            }
		            fclose(fout);
		        }
		        else printf("impossible d'ouvrir %s\n", filename);
	        }
            fclose(f);
        }
        else printf("impossible d'ouvrir %s\n", argv[1]);
    }
    return 0;
}
