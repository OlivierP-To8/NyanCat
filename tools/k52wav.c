/*
		    MM   MM    OOOOO    5555555
		    M M M M   O     O   5
		    M  M  M   O     O   555555
		    M     M   O     O         5
		    M     M   O     O         5
		    M     M    OOOOO    555555

			     EMULATEUR

			 Par Edouard FORLER
		    (edouard.forler@di.epfl.ch)
			  Par Sylvain HUET
		    (huet@poly.polytechnique.fr)
			       1997

  k52wav.c : outil de conversion de donnees PC -> MO5.

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define sample_freq 44100
#define rec_speed   2400

void blank(FILE *fw);

int longper  = sample_freq/(rec_speed)*1.1;
int shortper = sample_freq/(rec_speed*2)*1.1;
signed int spl = 64;

int head[46] = {0x52,0x49,0x46,0x46,0x00,0x00,0x00,0x00,0x57,0x41,0x56,0x45,
                0x66,0x6d,0x74,0x20,0x12,0x00,0x00,0x00,0x01,0x00,0x01,0x00,
                0x44,0xac,0x00,0x00,0x44,0xac,0x00,0x00,0x01,0x00,0x08,0x00,
                0x00,0x00,0x64,0x61,0x74,0x61,0x00,0x00,0x00,0x00
               };

int myfgetc(FILE *fp, FILE *fw)
{
    int c=fgetc(fp),size;

    if (c==EOF)
    {
        printf("Fin du fichier .K5\n");
        blank(fw);

        size = ftell(fw)-8;
        fseek(fw,4,0);
        fputc(size,fw);
        fputc(size>>8,fw);
        fputc(size>>16,fw);
        fputc(size>>24,fw);

        size -= 38;
        fseek(fw,42,0);
        fputc(size,fw);
        fputc(size>>8,fw);
        fputc(size>>16,fw);
        fputc(size>>24,fw);

        fclose(fw);
        fclose(fp);
        exit(1);
    }
    return c;
}

void write(int bit, FILE *fw)
{
    int i;

    if (bit==0)
    {
        for (i=0; i<longper; i++) fputc(128+spl,fw);
        spl=-spl;
    }
    else
    {
        for (i=0; i<shortper; i++) fputc(128+spl,fw);
        spl=-spl;
        for (i=0; i<shortper; i++) fputc(128+spl,fw);
        spl=-spl;
    }

}

void writebyte(FILE *fw, int c)
{
    int i;

    for (i=8; i>0; i--)
        if (c&(1<<(i-1))) write(1,fw);
        else write(0,fw);
}

void blank(FILE *fw)
{
    int i;
    for (i=0; i<sample_freq; i++) fputc(128,fw);
    spl=64;
}

int main(int argc, char **argv)
{
    int j,l,i,c,b;
    FILE *fp,*fw;

    printf("conversion .k5 mo5 -> wav 44,1KHz 8 bits.\n");
    printf("version 1.0, par Edouard FORLER\n");

    if (argc<2)
    {
        printf("usage : k52wav fichier.k5\n");
        return 1;
    }

    l=strlen(argv[1])-3;

    if ((l<1)||((strcmp(&argv[1][l],".k5"))&&(strcmp(&argv[1][l],".K5"))&&(strcmp(&argv[1][l],".k7"))&&(strcmp(&argv[1][l],".K7"))))
    {
        printf("erreur: mauvais format source.\n");
        return 1;
    }

    printf("ouverture de %s\n",argv[1]);
    fp=fopen(argv[1],"rb");
    if (fp==NULL)
    {
        printf("erreur: fichier %s introuvable.\n",argv[1]);
        return 0;
    }

//  fseek(fp,0,SEEK_END);
//  printf("Taille estimee du fichier .wav:  %i octets. Continuer (O/N)? ",ftell(fp)*8*longper+ftell(fp)/255*sample_freq);
//  fseek(fp,0,SEEK_SET);
//  fflush(stdout);
//  if (((c=getchar())!='o')&&(c!='O')) exit(1);

    strcpy(&argv[1][l],".wav\0");
    printf("creation de %s\n",argv[1]);
    fw=fopen(argv[1],"wb");
    if (fw==NULL)
    {
        printf("erreur: fichier %s impossible a ouvrir.\n",argv[1]);
        return 1;
    }

    /* Ecriture header WAV */

    for(i=0; i<46; i++) fputc(head[i],fw);

    blank(fw);

    do
    {
        do
        {
            c=myfgetc(fp,fw);
        }
        while (c==1);

        for (j=0; j<16; j++) writebyte(fw,1);

        if (c==60)
        {
            writebyte(fw,60);
            c=myfgetc(fp,fw);
            if (c==90)
            {
                int s=0;
                writebyte(fw,90);
                b=myfgetc(fp,fw);
                writebyte(fw,b);
                l=myfgetc(fp,fw);
                writebyte(fw,l);
                if (l==0) l=256;

                for (i=0; i<l-2; i++)
                {
                    c=myfgetc(fp,fw);
                    writebyte(fw,c);
                    s=s+c;
                }
                c=myfgetc(fp,fw);
                writebyte(fw,c);
                if (((c+s)&255) && (b!=0xff)) printf("erreur checksum!?");
            }
            else printf("erreur");
        }
        else
        {
            long pw,pp;

            do
            {
                printf("bloc special");

                do
                {
                    writebyte(fw,c);
                    c=myfgetc(fp,fw);
                }
                while (c!=1);

                pw=ftell(fw);
                pp=ftell(fp)-1;
                do
                {
                    writebyte(fw,c);
                    c=myfgetc(fp,fw);
                }
                while (c==1);

            }
            while (c!=60);
            fseek(fw,pw,SEEK_SET);
            fseek(fp,pp,SEEK_SET);
        }
        blank(fw);

        c=myfgetc(fp,fw);
        if (c==0) fseek(fp,0,SEEK_END);
    }
    while (1);
}

