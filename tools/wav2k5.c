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

  wav2k5.c : outil de recuperation de donnees MO5 par K7.

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define sample_freq 44100
#define rec_speed   1200

char *ftyp[] = {"BASIC (prg)","BASIC (dat)","binaire","assembleur"};

int   med_pt   = (sample_freq/rec_speed)*0.75;
int   low_pt   = (sample_freq/rec_speed)*0.25;

int carac;

int myfgetc(FILE *fp, FILE *fw)
{
  int c=fgetc(fp),i;

  if (c==EOF)
  {
    printf("Fin du fichier .WAV\n");
    for (i=0;i<8;i++) fputc(0,fw);
    fclose(fw);
    fclose(fp);
    exit(1);
  }
  return c;
}

int getperiod(FILE *fp, FILE *fw)
{
  int l;

  do {
    l=1;
    if (carac>127)
      while ((carac=myfgetc(fp,fw))>127) l++;
    else
      while ((carac=myfgetc(fp,fw))<128) l++;
  } while (l<low_pt);

  return l;
}

int getbit(FILE *fp, FILE *fw)
{
  if (getperiod(fp,fw)>med_pt) return 0;
  else
  {
    getperiod(fp,fw);
    return 1;
  }
}

int getbyte(FILE *fp, FILE *fw)
{
  int i,octet=0;

  for (i=0;i<8;i++)
    octet|=getbit(fp,fw) << (7-i);

  return octet;
}

int main(int argc, char **argv)
{
  int i,l,c,checksum,sum,blktp,checkit,buflen;
  FILE *fp,*fw;
  char buffer[255];

  printf("conversion .wav 44,1KHz -> .k5 mo5\n");
  printf("version 1.3, par Edouard FORLER\n");

  if (argc<2)
  {
    printf("usage : wav2k5 fichier.wav [-nc]\n");
    return 1;
  }
  l=strlen(argv[1])-4;

  if ((l<1)||((strcmp(&argv[1][l],".wav"))&&(strcmp(&argv[1][l],".WAV"))))
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

  strcpy(&argv[1][l],".k5\0");
  printf("creation de %s\n",argv[1]);
  fw=fopen(argv[1],"wb");
  if (fw==NULL)
  {
    printf("erreur: fichier %s impossible a ouvrir.\n",argv[1]);
    return 1;
  }

  checkit=strcmp(argv[2],"-nc");
  /* Lecture header WAV */

  for(i=0;i<46;i++) myfgetc(fp,fw);
  carac=myfgetc(fp,fw);

  do
  {
    while (getbit(fp,fw)!=1);
    if (getbyte(fp,fw)==1)
    {
      int cone=1;
      while ((c=getbyte(fp,fw))==1) cone++;
      if (cone>8) {
      if (c!=60)
      {
	long pp;

	do {
          printf("Bloc special, longueur inconnue\n");
          for (i=0;i<16;i++) fputc(1,fw); fputc(c,fw);

          do {
            do {
              pp = ftell(fp);

	    while (getbit(fp,fw)!=1);
	    if ((c=getbyte(fp,fw))!=1)
	    {
	      fseek(fp,pp,SEEK_SET);
	      fputc(getbyte(fp,fw),fw);
	    }

	  } while (c!=1);

	  cone=1;
	  while ((c=getbyte(fp,fw))==1) { cone++; }

	  if (cone<13)
	  {
	    fseek(fp,pp,SEEK_SET);
	    fputc(getbyte(fp,fw),fw);
	  }


	} while (cone<13);
	} while (c!=60);

      }
      if ((c==60) && (getbyte(fp,fw)==90))
      {
        for (i=0;i<16;i++) fputc(1,fw); fputc(60,fw); fputc(90,fw);
	blktp=getbyte(fp,fw);
	switch (blktp)
	{
	  case 0  : printf("Bloc d'entete  : "); break;
	  case 1  : printf("Bloc de donnees: "); break;
	  case 255: printf("Bloc de fin    : ");
	}
	buflen=getbyte(fp,fw);
	fputc(blktp,fw); fputc(buflen,fw);

	printf("longueur=%-3i   ",buflen);
	buflen=(buflen-2) & 0xff;
	sum=0;
	for (i=0;i<buflen;i++)
	{
	  buffer[i]=getbyte(fp,fw);
	  fputc(buffer[i],fw);
	  sum+=buffer[i];
	}

	if ((blktp==0)&&checkit)
	{
	  printf("nom du fichier=");
	  for (i=0;i<11;i++) printf("%c",buffer[i]);
	  printf ("   type=s", ftyp[(int)buffer[11]]);
	}

	checksum=getbyte(fp,fw);
	fputc(checksum,fw);

	if (checkit)
	{
	  if (((checksum+sum) & 0xff)!=0)
	  {
	    printf("\nError 53\nOK\n");
	    printf("Option -nc pour desactiver le controle de bloc/checksum.\n");
	    exit(1);
	  } else
            if (blktp!=0) printf("Checksum OK!");
	}

	printf("\n");
	if (blktp==255) printf("\n");

      }
      }
    }
  } while (1);
}

