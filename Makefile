.PHONY: all clean tools nyancatTO8 nyancatMO6

all: nyancatTO8.fd nyancatTO8.sd nyancatTO8.hfe nyancatMO6.fd nyancatMO6.sd nyancatMO6.k7

clean:
	-rm *.lst *.asm
	-rm diskTO8/*.BIN
	-rm diskMO6/*.BIN
	-rm dist/NyanCat{TO8,MO6}.{fd,sd}
	-rm dist/NyanCatTO8.hfe
	-rm dist/NyanCatMO6.k7
	make -C tools $@

tools:
	make -C $@


nyancatTO8: tools
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

	tools/c6809 -bl src/NyanCatTO8Loader.asm diskTO8/LOADER.BIN

nyancatTO8.fd: nyancatTO8
	cd diskTO8; ../tools/fdfs -add ../dist/NyanCatTO8.fd AUTO.BAT LOADER.BIN SAMPLE01.BIN SAMPLE02.BIN SAMPLE03.BIN SAMPLE04.BIN SAMPLE05.BIN SAMPLE06.BIN SAMPLE07.BIN SAMPLE08.BIN SAMPLE09.BIN SAMPLE10.BIN SAMPLE11.BIN SAMPLE12.BIN NYANCAT.BIN NYANCAT.BAS CATNOSND.BIN

nyancatTO8.sd: dist/NyanCatTO8.fd
	tools/fdtosd -conv dist/NyanCatTO8.fd dist/NyanCatTO8.sd

nyancatTO8.hfe: dist/NyanCatTO8.fd
	tools/fdtohfe -conv dist/NyanCatTO8.fd dist/NyanCatTO8.hfe 2


nyancatMO6: tools
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

nyancatMO6.fd: nyancatMO6
	cd diskMO6; ../tools/fdfs -add ../dist/NyanCatMO6.fd AUTO.BAT NYANCAT.BAS SAMPLE01.BIN SAMPLE02.BIN SAMPLE03.BIN SAMPLE04.BIN SAMPLE05.BIN NYANCAT.BIN CATNOSND.BIN

nyancatMO6.sd: dist/NyanCatMO6.fd
	tools/fdtosd -conv dist/NyanCatMO6.fd dist/NyanCatMO6.sd

nyancatMO6.k7: nyancatMO6
	cat /dev/null > dist/NyanCatMO6.k7
	cd diskMO6; ../tools/k7mofs -add ../dist/NyanCatMO6.k7 AUTO.BAT
	cd diskMO6; ../tools/k7mofs -add ../dist/NyanCatMO6.k7 NYANCAT.BAS
	cd diskMO6; ../tools/k7mofs -add ../dist/NyanCatMO6.k7 SAMPLE01.BIN
	cd diskMO6; ../tools/k7mofs -add ../dist/NyanCatMO6.k7 SAMPLE02.BIN
	cd diskMO6; ../tools/k7mofs -add ../dist/NyanCatMO6.k7 SAMPLE03.BIN
	cd diskMO6; ../tools/k7mofs -add ../dist/NyanCatMO6.k7 SAMPLE04.BIN
	cd diskMO6; ../tools/k7mofs -add ../dist/NyanCatMO6.k7 SAMPLE05.BIN
	cd diskMO6; ../tools/k7mofs -add ../dist/NyanCatMO6.k7 NYANCAT.BIN
