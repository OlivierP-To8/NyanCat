/*******************************************************************************
 * Rapide programme pour mettre des fichiers dans une K7 MO
 * Auteur : OlivierP 
*******************************************************************************/
// la description du format K7 MO provient principalement du post suivant
// http://dcmoto.free.fr/forum/messages/591147_0.html

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

char calculChecksum(const char *data, int len)
{
	// checksum OK en MO si somme(donnes + checksum) modulo 256 == 0
	int val = 0;
	for (int i=0; i<len; i++)
	{
		val += data[i];
	}
	return (char)(256-(val%256));
}

void ecrireBloc(FILE *k7, const char typeBloc, const char data[], int len)
{
	//En-tete de bloc :
	//Pour permettre la synchronisation de la lecture, les blocs sont
	//precedes d'une en-tete composee de 16 octets 01, suivis de deux
	//octets contenant les caracteres <Z (3C5A).
	const char synchroMO[] = {0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 
							  0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01};
	fwrite(synchroMO, sizeof(synchroMO), 1, k7);
	const char blocMO[] = {0x3C, 0x5A};
	fwrite(blocMO, sizeof(blocMO), 1, k7);

	fwrite(&typeBloc, 1, 1, k7);

	// longueur en MO = 1 octet longueur + données + 1 octet checksum
	unsigned char taille = len+2;
	fwrite(&taille, 1, 1, k7);

	if (len>0)
		fwrite(data, len, 1, k7);

	int chksum = calculChecksum(data, len);
	fwrite(&chksum, 1, 1, k7);
}

void ajouterFichier(FILE *k7, char *filename)
{
	FILE *f = fopen(filename, "rb");
	if (f==NULL)
	{
		printf("impossible d'ouvrir %s\n", filename);
	}
	else
	{
		char data[256];
		memset(data, 0, sizeof(data));

		int point = strcspn(filename, ".");
		strncpy(data, filename, point);
		for (int i=point; i<8; i++)
			strcat(data, " ");
		strcat(data, &filename[point+1]);
		if (strncmp(&filename[point+1], "BIN", 3) == 0)
			data[11] = 0x02;
		//- Bloc d'en-tete (type 00)
		//00 type de bloc = 00
		//01 longueur du bloc = &h10
		//02-09 nom du fichier
		//0A-0C extension (sans le point)
		//0D type de fichier 00=Basic 01=Data 02=Binaire
		//0E mode du fichier 00=Binaire FF=Texte
		//0F identique à l'octet precedent (a verifier)
		//10 checksum
		ecrireBloc(k7, 0x00, data, 14);

		int taille = 254;
		while (taille==254)
		{
			taille = fread(data, 1, 254, f);
			//- Blocs contenant le fichier (type 01)
			//00 type de bloc = 01
			//01 longueur du bloc = xx (attention, &h00 signifie 256)
			//02-yy contenu du fichier (yy = xx -1)
			//xx checksum
			ecrireBloc(k7, 0x01, data, taille);
		}

		memset(data, 0, sizeof(data));
		//- Bloc de fin (type FF)
		//00 type de bloc = FF
		//01 longueur du bloc = 02
		//02 checksum = 00
		ecrireBloc(k7, 0xff, data, 0);

		fclose(f);
	}
}

int main(int argc, char **argv)
{
	if ((argc==4) && (strcmp(argv[1], "-add") == 0))
	{
		FILE *k7=fopen(argv[2], "ab");
		if (k7==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
		}
		else
		{
			ajouterFichier(k7, argv[3]);
			fclose(k7);
		}
	}
	else
	{
		printf("usage : %s -add filename.k7 filename\n", argv[0]);
	}
	return 0;
}
