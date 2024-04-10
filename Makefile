OBJ_ASM = $(OBJ_DIR)tools/c6809.o
OBJ_SAPFS = $(OBJ_DIR)tools/sap/libsap.o $(OBJ_DIR)tools/sap/sapfs.o
OBJ_FDFS = $(OBJ_DIR)tools/fdfs.o
OBJ_BMP = $(OBJ_DIR)tools/bmp.o
OBJ_SNDTO = $(OBJ_DIR)tools/snd6bitTO.o
OBJ_SNDMO = $(OBJ_DIR)tools/snd6bitMO.o
OBJ_K7MOFS = $(OBJ_DIR)tools/k7mofs.o
OBJ_K52WAV = $(OBJ_DIR)tools/k52wav.o
OBJ_WAV2K5 = $(OBJ_DIR)tools/wav2k5.o

all: c6809 sapfs fdfs bmp sndTO nyancatTO8 sndMO k7mofs k52wav nyancatMO6

c6809: $(OBJ_ASM)
	gcc -s -o tools/c6809 $(OBJ_ASM)

sapfs: $(OBJ_SAPFS)
	gcc -s -o tools/sapfs $(OBJ_SAPFS)

fdfs: $(OBJ_FDFS)
	gcc -s -o tools/fdfs $(OBJ_FDFS)

bmp: $(OBJ_BMP) 
	gcc -s -o tools/bmp $(OBJ_BMP)

sndTO: $(OBJ_SNDTO) 
	gcc -s -lm -o tools/snd6bitTO $(OBJ_SNDTO) -lm

sndMO: $(OBJ_SNDMO) 
	gcc -s -lm -o tools/snd6bitMO $(OBJ_SNDMO) -lm

k7mofs: $(OBJ_K7MOFS)
	gcc -s -o tools/k7mofs $(OBJ_K7MOFS)

k52wav: $(OBJ_K52WAV)
	gcc -s -o tools/k52wav $(OBJ_K52WAV)

wav2k5: $(OBJ_WAV2K5)
	gcc -s -o tools/wav2k5 $(OBJ_WAV2K5)

$(OBJ_DIR)%.o: %.c
	gcc -c -W -Wall -std=c99 -o $@ $<

clean:
	-rm tools/*.o
	-rm tools/sap/*.o
	-rm diskTO8/*.BIN
	-rm diskMO6/*.BIN
	-rm *.lst *.asm *.fd *.sap *.k7 *.wav
	-rm tools/c6809 tools/sapfs tools/fdfs tools/bmp tools/snd6bitTO tools/snd6bitMO tools/k7mofs tools/k52wav

nyancatTO8:
	cp src/NyanCatTO8NoSnd.asm NyanCatFull.asm
	tools/bmp data/my_nyan_arc_1.bmp ARC1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_arc_2.bmp ARC2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_1.bmp MIX1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_2.bmp MIX2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_3.bmp MIX3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_4.bmp MIX4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_5.bmp MIX5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_6.bmp MIX6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_7.bmp MIX7 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_8.bmp MIX8 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_9.bmp MIX9 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_A.bmp MIXA >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_B.bmp MIXB >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_C.bmp MIXC >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_1.bmp CAT1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_2.bmp CAT2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_3.bmp CAT3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_4.bmp CAT4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_5.bmp CAT5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_6.bmp CAT6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_1.bmp STAR1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_2.bmp STAR2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_3.bmp STAR3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_4.bmp STAR4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_5.bmp STAR5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_6.bmp STAR6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_7.bmp STAR7 >> NyanCatFull.asm
	tools/c6809 -bl NyanCatFull.asm diskTO8/CATNOSND.BIN

	tools/snd6bitTO "data/Nyan Cat loop TO8.snd" sample
	tools/c6809 -bl sample01.asm diskTO8/SAMPLE01.BIN
	tools/c6809 -bl sample02.asm diskTO8/SAMPLE02.BIN
	tools/c6809 -bl sample03.asm diskTO8/SAMPLE03.BIN
	tools/c6809 -bl sample04.asm diskTO8/SAMPLE04.BIN
	tools/c6809 -bl sample05.asm diskTO8/SAMPLE05.BIN
	tools/c6809 -bl sample06.asm diskTO8/SAMPLE06.BIN
	tools/c6809 -bl sample07.asm diskTO8/SAMPLE07.BIN
	tools/c6809 -bl sample08.asm diskTO8/SAMPLE08.BIN
	tools/c6809 -bl sample09.asm diskTO8/SAMPLE09.BIN
	tools/c6809 -bl sample10.asm diskTO8/SAMPLE10.BIN
	tools/c6809 -bl sample11.asm diskTO8/SAMPLE11.BIN
	tools/c6809 -bl sample12.asm diskTO8/SAMPLE12.BIN

	cp src/NyanCatTO8.asm NyanCatFull.asm
	tools/bmp data/my_nyan_arc_1.bmp ARC1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_arc_2.bmp ARC2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_1.bmp MIX1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_2.bmp MIX2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_3.bmp MIX3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_4.bmp MIX4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_5.bmp MIX5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_6.bmp MIX6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_7.bmp MIX7 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_8.bmp MIX8 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_9.bmp MIX9 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_A.bmp MIXA >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_B.bmp MIXB >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_C.bmp MIXC >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_1.bmp CAT1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_2.bmp CAT2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_3.bmp CAT3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_4.bmp CAT4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_5.bmp CAT5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_6.bmp CAT6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_1.bmp STAR1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_2.bmp STAR2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_3.bmp STAR3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_4.bmp STAR4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_5.bmp STAR5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_6.bmp STAR6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_7.bmp STAR7 >> NyanCatFull.asm
	tools/c6809 -bl NyanCatFull.asm diskTO8/NYANCAT.BIN

	cd diskTO8; ../tools/sapfs -create ../NyanCatTO8.sap
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap CATNOSND.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap AUTO.BAT
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap NYANCAT.BAS
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap NYANCAT.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE01.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE02.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE03.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE04.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE05.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE06.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE07.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE08.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE09.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE10.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE11.BIN
	cd diskTO8; ../tools/sapfs -add ../NyanCatTO8.sap SAMPLE12.BIN

	cd diskTO8; ../tools/fdfs -add ../NyanCatTO8.fd CATNOSND.BIN AUTO.BAT NYANCAT.BAS NYANCAT.BIN SAMPLE01.BIN SAMPLE02.BIN SAMPLE03.BIN SAMPLE04.BIN SAMPLE05.BIN SAMPLE06.BIN SAMPLE07.BIN SAMPLE08.BIN SAMPLE09.BIN SAMPLE10.BIN SAMPLE11.BIN SAMPLE12.BIN

nyancatMO6:
	cp src/NyanCatMO6NoSnd.asm NyanCatFull.asm
	tools/bmp data/my_nyan_arc_1.bmp ARC1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_arc_2.bmp ARC2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_1.bmp MIX1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_2.bmp MIX2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_3.bmp MIX3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_4.bmp MIX4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_5.bmp MIX5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_6.bmp MIX6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_7.bmp MIX7 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_8.bmp MIX8 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_9.bmp MIX9 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_A.bmp MIXA >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_B.bmp MIXB >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_C.bmp MIXC >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_1.bmp CAT1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_2.bmp CAT2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_3.bmp CAT3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_4.bmp CAT4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_5.bmp CAT5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_6.bmp CAT6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_1.bmp STAR1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_2.bmp STAR2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_3.bmp STAR3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_4.bmp STAR4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_5.bmp STAR5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_6.bmp STAR6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_7.bmp STAR7 >> NyanCatFull.asm
	tools/c6809 NyanCatFull.asm diskMO6/CATNOSND.BIN

	tools/snd6bitMO "data/Nyan Cat loop MO6.snd" sample
	tools/c6809 sample01.asm diskMO6/SAMPLE01.BIN
	tools/c6809 sample02.asm diskMO6/SAMPLE02.BIN
	tools/c6809 sample03.asm diskMO6/SAMPLE03.BIN
	tools/c6809 sample04.asm diskMO6/SAMPLE04.BIN
	tools/c6809 sample05.asm diskMO6/SAMPLE05.BIN

	cp src/NyanCatMO6.asm NyanCatFull.asm
	tools/bmp data/my_nyan_arc_1.bmp ARC1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_arc_2.bmp ARC2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_1.bmp MIX1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_2.bmp MIX2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_3.bmp MIX3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_4.bmp MIX4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_5.bmp MIX5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_6.bmp MIX6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_7.bmp MIX7 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_8.bmp MIX8 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_9.bmp MIX9 >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_A.bmp MIXA >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_B.bmp MIXB >> NyanCatFull.asm
	tools/bmp data/my_nyan_mix_C.bmp MIXC >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_1.bmp CAT1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_2.bmp CAT2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_3.bmp CAT3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_4.bmp CAT4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_5.bmp CAT5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_cat_6.bmp CAT6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_1.bmp STAR1 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_2.bmp STAR2 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_3.bmp STAR3 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_4.bmp STAR4 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_5.bmp STAR5 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_6.bmp STAR6 >> NyanCatFull.asm
	tools/bmp data/my_nyan_star_7.bmp STAR7 >> NyanCatFull.asm
	tools/c6809 NyanCatFull.asm diskMO6/NYANCAT.BIN

	cd diskMO6; ../tools/sapfs -create ../NyanCatMO6.sap
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap CATNOSND.BIN
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap AUTO.BAT
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap NYANCAT.BAS
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap SAMPLE01.BIN
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap SAMPLE02.BIN
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap SAMPLE03.BIN
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap SAMPLE04.BIN
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap SAMPLE05.BIN
	cd diskMO6; ../tools/sapfs -add ../NyanCatMO6.sap NYANCAT.BIN

	cd diskMO6; ../tools/fdfs -add ../NyanCatMO6.fd CATNOSND.BIN AUTO.BAT NYANCAT.BAS SAMPLE01.BIN SAMPLE02.BIN SAMPLE03.BIN SAMPLE04.BIN SAMPLE05.BIN NYANCAT.BIN

	cat /dev/null > NyanCatMO6.k7
	cd diskMO6; ../tools/k7mofs -add ../NyanCatMO6.k7 AUTO.BAT
	cd diskMO6; ../tools/k7mofs -add ../NyanCatMO6.k7 NYANCAT.BAS
	cd diskMO6; ../tools/k7mofs -add ../NyanCatMO6.k7 SAMPLE01.BIN
	cd diskMO6; ../tools/k7mofs -add ../NyanCatMO6.k7 SAMPLE02.BIN
	cd diskMO6; ../tools/k7mofs -add ../NyanCatMO6.k7 SAMPLE03.BIN
	cd diskMO6; ../tools/k7mofs -add ../NyanCatMO6.k7 SAMPLE04.BIN
	cd diskMO6; ../tools/k7mofs -add ../NyanCatMO6.k7 SAMPLE05.BIN
	cd diskMO6; ../tools/k7mofs -add ../NyanCatMO6.k7 NYANCAT.BIN

