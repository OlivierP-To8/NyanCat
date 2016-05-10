********************************************************************************
*                               NyanCat pour TO8                               *
********************************************************************************
* Auteur  : OlivierP (sauf si indication contraire)                            *
* Date    : novembre-décembre 2011                                             *
* Licence : GNU GPLv3 (http://www.gnu.org/copyleft/gpl.html)                   *
********************************************************************************
* Chaque dessin de frame (fonction FRAME1-12) consomme 24326 cycles
********************************************************************************

(main)NyanCat.asm

   ORG $8000

ADR_ARC EQU $0BED
ADR_MIX EQU ADR_ARC+4
ADR_CAT EQU ADR_MIX+3

NBL_STAR1 EQU 23*80
NBL_STAR2 EQU 15*80
NBL_STAR3 EQU 7*80 
NBL_STAR4 EQU 16*80
NBL_STAR5 EQU 27*80
NBL_STAR6 EQU 35*80

   ORCC #80        * ne pas interrompre

********************************************************************************
* Definition de la palette de couleurs
* 
* Provenance de ce bout de code : manuel technique des TO8, TO9, TO9+ page 70
* modifié par OlivierP pour faire les 16 valeurs
********************************************************************************
   CLRA
PALETTE_FOND
   PSHS A
   ASLA
   STA $E7DB
   LDD #$0310      * on force toutes les couleurs durant l'initialisation
   STB $E7DA
   STA $E7DA
   PULS A
   INCA
   CMPA #$F
   BNE PALETTE_FOND


********************************************************************************
* Passage en mode 160x200x16c
* 
* Provenance de ce bout de code :  manuel technique des TO8, TO9, TO9+ page 61
********************************************************************************
   LDA #$7B
   STA $E7DC


********************************************************************************
* Initialisation de la routine de commutation de page video
* 
* Provenance de ce bout de code :  http://pulsdemos.com/vector02.html
* Remplacement du LDB $6181 par LDB $6081 sur les conseils de Gilles. 
********************************************************************************
   LDB $6081
   ORB #$10
   STB $6081
   STB $E7E7


********************************************************************************
* Effacement ecran (les deux pages)
********************************************************************************
   JSR SCRC
   JSR EFF
   JSR SCRC
   JSR EFF


********************************************************************************
* Definition de la palette de couleurs
* 
* Provenance de ce bout de code : manuel technique des TO8, TO9, TO9+ page 70
* amélioré par OlivierP pour gérer un tableau de valeurs
********************************************************************************
   LDY #PALET
   CLRA
PALETTE
   PSHS A
   ASLA
   STA $E7DB
   LDD ,Y++
   STB $E7DA
   STA $E7DA
   PULS A
   INCA
   CMPY #FINPA
   BNE PALETTE


********************************************************************************
* Boucle principale
********************************************************************************
BOUCLE_PRINC
   JSR FRAME1
   JSR FRAME2
   JSR FRAME3
   JSR FRAME4
   JSR FRAME5
   JSR FRAME6
   JSR FRAME7
   JSR FRAME8
   JSR FRAME9
   JSR FRAME10
   JSR FRAME11
   JSR FRAME12
   BRA BOUCLE_PRINC

********************************************************************************
* Appel des frames
********************************************************************************

FRAME1
   LDX #ANIM1
   LDY #ANIM2
   JSR FRAME_ANIM

   LDX #STAR6
   LDY #ADR_ARC+NBL_STAR4+2
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME2
   LDX #ANIM2
   LDY #ANIM3
   JSR FRAME_ANIM

   LDX #STAR1
   LDY #ADR_ARC+NBL_STAR4
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME3
   LDX #ANIM3
   LDY #ANIM4
   JSR FRAME_ANIM

   LDX #STAR2
   LDY #ADR_ARC+NBL_STAR4-2
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME4
   LDX #ANIM4
   LDY #ANIM5
   JSR FRAME_ANIM

   LDX #STAR3
   LDY #ADR_ARC+NBL_STAR4-4
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME5
   LDX #ANIM5
   LDY #ANIM6
   JSR FRAME_ANIM

   LDX #STAR4
   LDY #ADR_ARC+NBL_STAR4-6
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME6
   LDX #ANIM6
   LDY #ANIM7
   JSR FRAME_ANIM

   LDX #STAR5
   LDY #ADR_ARC+NBL_STAR4+16
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME7
   LDX #ANIM7
   LDY #ANIM8
   JSR FRAME_ANIM

   LDX #STAR6
   LDY #ADR_ARC+NBL_STAR4+14
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME8
   LDX #ANIM8
   LDY #ANIM9
   JSR FRAME_ANIM

   LDX #STAR1
   LDY #ADR_ARC+NBL_STAR4+12
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME9
   LDX #ANIM9
   LDY #ANIM10
   JSR FRAME_ANIM

   LDX #STAR2
   LDY #ADR_ARC+NBL_STAR4+10
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME10
   LDX #ANIM10
   LDY #ANIM11
   JSR FRAME_ANIM

   LDX #STAR3
   LDY #ADR_ARC+NBL_STAR4+8
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME11
   LDX #ANIM11
   LDY #ANIM12
   JSR FRAME_ANIM

   LDX #STAR4
   LDY #ADR_ARC+NBL_STAR4+6
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS

FRAME12
   LDX #ANIM12
   LDY #ANIMEND
   JSR FRAME_ANIM

   LDX #STAR5
   LDY #ADR_ARC+NBL_STAR4+4
   JSR DESSIN_TR

   JSR SCRC        * changement de page écran
   RTS


********************************************************************************
* Changement de page écran
* 
* Provenance de ce bout de code :  http://pulsdemos.com/vector02.html
* Modifié par OlivierP (ORB #$0A et lignes commençant par 6 espaces)
* Suppression du CLR $E7CF sur les conseils de Gilles.
********************************************************************************
SCRC
   LDB SCRC0+1
   ANDB #$80          * BANK1 utilisée ou pas pour l'affichage / fond couleur 0
   ORB #$0A           * contour écran = couleur A
   STB $E7DD
   COM SCRC0+1
SCRC0
   LDB #$00
   ANDB #$02          * page RAM no0 ou no2 utilisée dans l'espace cartouche
   ORB #$60           * espace cartouche recouvert par RAM / écriture autorisée
   STB $E7E6
   RTS

* Comment cette routine fonctionne-t-elle ?
* Premierement, il convient de noter que SCRC0+1 est l'adresse en mémoire de la valeur du LDB #$00.
* Plutot que d'utiliser une variable et de charger et décharger (par les LDB / STB), nous modifions directement le programme lui meme.
* Cette technique va nous permettre de sauver du temps lors de l'exécution du programme.
* A la première exécution de cette routine, nous allons charger dans B la valeur qui se trouve dans SCRC0 LDB #$00, soit $00.
* Nous appliquons un ET logique qui ne changera pas le résultat, la valeur stockée dans $E7DD sera $00.
* Nous complémentons la valeur du LDB #$00.
* Le programme va donc s'auto-modifier et le LDB #$00 va se transformer en LDB #$FF (Une complémentation met les bits 0 à 1 et les bits 1 à 0)
* Le programme continue son exécution et trouve un LDB #$FF, et charge donc $FF dans B naturellement.
* Le reste sont des opérations logique qui produisent au final la valeur $62.
* A la deuxième exécution de cette routine, notre ligne était restée à l'état LDB #$FF.
* Un COM SCRC0+1 complémentera donc le $FF ce qui modifera le programme et changera cette ligne en LDB #$00.
* La valeur qui résultera des opérations qui suivent sera $60.
* Nous avons donc une routine qui permute entre les valeurs $00/$80, et $60/$62 à chaque fois qu'elle est exécutée.  	  	  	 

* http://www.logicielsmoto.com/phpBB/viewtopic.php?p=787#787
* la memoire video se trouve a $0000 et $2000 pour les 2 RAMs plutot qu'en $4000 avec commutation pour les 2 RAMs.
* Ca simplifie enormement la programmation d'avoir les 16 kilo lineaires et a la meme adresse quelques soit l'ecran affiche,
* plutot que d'avoir a travailler soit en $4000 (en prenant soin de commuter RAMA/RAMB), soit en $a000 et $c000 suivant le cas.
* Ce que l'on fait est "simplement" de deplacer la "fenetre visible" sur l'espace normal ou la banque.
* Mais d'un point de vue programmation, c'est visible en $0000 quelque soit la page selectionne. 

* http://www.logicielsmoto.com/phpBB/viewtopic.php?p=796#796
* En fait, on n'utilise pas proprement dit la zone $0000-$3FFF, mais on cree une fenetre au adresses $0000-$3FFF
* On peut alors deplacer cette fenetre sur la zone memoire video ($4000) ou BANK 1 ($A000).
* Cela permet de pouvoir gerer 2 pages videos, toujours a la meme adresse.
* La routine de commutation doit etre appele a chaque fois que tu changes d'image (frame).
* Cette routine pointe l'affichage video dans la bonne banque ($4000 ou $A000) et
* commute l'ecriture video dans l'autre banque (celle qui n'est pas affichee).
* Cela permet donc d'afficher un ecran, et d'ecrire dans un ecran (invisible).
* Lorsque l'affichage est fini, on appel la routine, et on commute les 2.
* Celle qui etait ecrite devient visible, et celle qui etait visible devient invisible et disponible a l'ecriture. 

* http://pulsdemos.com/vector03.html
* notre écran sera positionnné en mémoire à partir de l'adresse &H0000.
* La RAMA se trouvera de &H0000 a &H1FFF et la RAMB se trouvera de &H2000 a &H3FFF.


********************************************************************************
* Effacement de l'écran
********************************************************************************
EFF
   LDA #$AA  * couleur fond
   LDY #$0000
EFF_RAM
   STA ,Y+
   CMPY #$3FFF
   BNE EFF_RAM
   RTS


********************************************************************************
* Affichage d'une frame
* 
* La RAM video est composée de la façon suivante
* en octet en RAMA code 2 pixels (4 bits par pixel)
* en octet en RAMB code les 2 pixels suivants (4 bits par pixel)
********************************************************************************
FRAME_ANIM
   TFR Y,D         * D (A et B) contient maintenant l'adresse de fin du tableau ANIM (Y)
   STA FRAME_ANIM_YVAL+1    
   STB FRAME_ANIM_YVAL+2

FRAME_ANIM_B
   PSHS X          * X contient le pointeur dans le tableau ANIM

   LDD ,X++        * D contient les donnees graphiques  
   LDY ,X++        * Y contient l'adresse video
   TFR D,X         * X contient les donnees graphiques

* Affichage d'un bitmap en mode 16 couleurs
* On affiche chaque point en double (sur la position courante en RAM video
* ainsi que sur la ligne suivante) afin d'avoir des pixels carrés.
* 0xEE indique la fin de ligne (on perd donc une couleur possible).
* Il y a ensuite une valeur qui permet de pointer vers le début de la ligne
* suivante en RAM video. Si cette valeur en nulle alors le dessin est fini.
* Cette routine ne gère pas la transparence.
* X contient le bitmap, Y pointe vers la ram video

DESSIN
   LDD ,X++        * D (A et B) contient le point bitmap
DESSIN_B
   STA ,Y          * ecrit les 2 points contenus dans A en RAMA
   STA $28,Y       * ecrit les 2 points contenus dans A sur la ligne suivante en RAMA
   STB $2000,Y     * ecrit les 2 points contenus dans B en RAMB
   STB $2028,Y     * ecrit les 2 points contenus dans B sur la ligne suivante en RAMB
   LDD ,X++        * D (A et B) contient le point bitmap suivant
   LEAY 1,Y
   CMPA #$EE       * EE = fin de ligne
   BNE DESSIN_B    * aller à DESSIN_B si pas fin de ligne
   CMPB #$00
   BEQ DESSIN_FIN  * sortir si fin bitmap
   LEAY B,Y        * ajout B pour que Y pointe vers la ligne suivante
   BRA DESSIN
DESSIN_FIN
   PULS X          * X contient le pointeur dans le tableau ANIM
   LEAX 4,X        * X pointe vers l'anim suivante dans le tableau ANIM
FRAME_ANIM_YVAL
   CMPX #$0000     * cette valeur est initialisée entre FRAME_ANIM et FRAME_ANIM_B  
   BNE FRAME_ANIM_B  * boucler si c'est n'est pas la derniere anim


   RTS


********************************************************************************
* Affichage d'un dessin transparent
* 
* Affichage d'un bitmap en mode 16 couleurs
* On affiche chaque point en double (sur la position courante en RAM video
* ainsi que sur la ligne suivante) afin d'avoir des pixels carrés.
* 0xEE indique la fin de ligne (on perd donc une couleur possible).
* Il y a ensuite une valeur qui permet de pointer vers le début de la ligne
* suivante en RAM video. Si cette valeur en nulle alors le dessin est fini.
* X contient le bitmap, Y pointe vers la ram video
********************************************************************************
DESSIN_TR
   LDA ,Y          * lit la mémoire video en RAMA
   LDB $2000,Y     * lit la mémoire video en RAMB

   ANDA ,X+        * ajoute le masque de données graphiques pour RAMA
   ANDB ,X+        * ajoute le masque de données graphiques pour RAMB

   STA ,Y          * ecrit les 2 points contenus dans A en RAMA
   STA $28,Y       * ecrit les 2 points contenus dans A sur la ligne suivante en RAMA
   STB $2000,Y     * ecrit les 2 points contenus dans B en RAMB
   STB $2028,Y     * ecrit les 2 points contenus dans B sur la ligne suivante en RAMB

   LEAY 1,Y
   LDD ,X          * D (A et B) contient le point bitmap suivant
   CMPA #$EE       * EE = fin de ligne
   BNE DESSIN_TR   * aller à DESSIN_TR si pas fin de ligne
   CMPB #$00
   BEQ DESSIN_TR_FIN  * sortir si fin bitmap
   LEAY B,Y        * ajout B pour que Y pointe vers la ligne suivante
   LEAX 2,X
   BRA DESSIN_TR
DESSIN_TR_FIN

   RTS


********************************************************************************
* DONNEES                                                 B  V  R
********************************************************************************
PALET
   FDB $0FFF    * blanc                                   FF FF FF
   FDB $00EE    * jaune                                   00 FF FF
   FDB $05AF    * saumon (contour du chat)                99 CC FF
   FDB $00E1    * vert clair                              00 FF 33
   FDB $0F5F    * rose clair (milieu du chat)             FF 99 FF
   FDB $044F    * saumon rose (joues du chat)             99 99 FF
   FDB $005F    * orange                                  00 99 FF
   FDB $0555    * gris                                    99 99 99
   FDB $0F50    * bleu                                    FF 99 00
   FDB $051F    * rose foncé (points du chat)             99 33 FF
   FDB $0310    * bleu foncé (fond écran)                 FF 33 66
   FDB $000F    * rouge                                   00 00 FF
   FDB $0000    * noir                                    00 00 00
   FDB $0F13    * violet                                  66 33 00
   FDB $0000    * non utilisé / fin de ligne
   FDB $0310    * bleu foncé (fond écran pour dessin_tr)
FINPA

ANIM1
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+14
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2-4
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4+6
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5-5
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+13

   FDB STAR2
   FDB ADR_ARC-NBL_STAR1+10
   FDB STAR4
   FDB ADR_ARC-NBL_STAR2+16
   FDB STAR2
   FDB ADR_ARC-NBL_STAR3-4
   FDB STAR6
   FDB ADR_ARC+NBL_STAR5+15
   FDB STAR3
   FDB ADR_ARC+NBL_STAR6+9
   
   FDB ARC1
   FDB ADR_ARC
   FDB MIX1
   FDB ADR_MIX
   FDB CAT1
   FDB ADR_CAT

ANIM2
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+12
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2-6
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3-2
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4+4
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+17
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+11

   FDB STAR3
   FDB ADR_ARC-NBL_STAR1+8
   FDB STAR5
   FDB ADR_ARC-NBL_STAR2+14
   FDB STAR3
   FDB ADR_ARC-NBL_STAR3-6
   FDB STAR5
   FDB ADR_ARC+NBL_STAR5+13
   FDB STAR4
   FDB ADR_ARC+NBL_STAR6+7
   
   FDB ARC1
   FDB ADR_ARC
   FDB MIX2
   FDB ADR_MIX
   FDB CAT2
   FDB ADR_CAT

ANIM3
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+10
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2+16
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3-4
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4+2
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+15
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+9

   FDB STAR4
   FDB ADR_ARC-NBL_STAR1+6
   FDB STAR6
   FDB ADR_ARC-NBL_STAR2+12
   FDB STAR4
   FDB ADR_ARC-NBL_STAR3+16
   FDB STAR4
   FDB ADR_ARC+NBL_STAR5+11
   FDB STAR5
   FDB ADR_ARC+NBL_STAR6+5
   
   FDB ARC2
   FDB ADR_ARC
   FDB MIX3
   FDB ADR_MIX
   FDB CAT3
   FDB ADR_CAT

ANIM4
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+8
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2+14
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3-6
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+13
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+7

   FDB STAR5
   FDB ADR_ARC-NBL_STAR1+4
   FDB STAR1
   FDB ADR_ARC-NBL_STAR2+10
   FDB STAR5
   FDB ADR_ARC-NBL_STAR3+14
   FDB STAR3
   FDB ADR_ARC+NBL_STAR5+9
   FDB STAR6
   FDB ADR_ARC+NBL_STAR6+3
   
   FDB ARC2
   FDB ADR_ARC
   FDB MIX4
   FDB ADR_MIX
   FDB CAT4
   FDB ADR_CAT

ANIM5
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+6
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2+12
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3+16
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4-2
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+11
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+5

   FDB STAR6
   FDB ADR_ARC-NBL_STAR1+2
   FDB STAR2
   FDB ADR_ARC-NBL_STAR2+8
   FDB STAR6
   FDB ADR_ARC-NBL_STAR3+12
   FDB STAR2
   FDB ADR_ARC+NBL_STAR5+7
   FDB STAR1
   FDB ADR_ARC+NBL_STAR6+1

   FDB ARC1
   FDB ADR_ARC
   FDB MIX5
   FDB ADR_MIX
   FDB CAT5
   FDB ADR_CAT

ANIM6
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+4
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2+10
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3+14
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4-4
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+9
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+3

   FDB STAR1
   FDB ADR_ARC-NBL_STAR1
   FDB STAR3
   FDB ADR_ARC-NBL_STAR2+6
   FDB STAR1
   FDB ADR_ARC-NBL_STAR3+10
   FDB STAR1
   FDB ADR_ARC+NBL_STAR5+5
   FDB STAR2
   FDB ADR_ARC+NBL_STAR6-1

   FDB ARC1
   FDB ADR_ARC
   FDB MIX6
   FDB ADR_MIX
   FDB CAT6
   FDB ADR_CAT

ANIM7
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+2
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2+8
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3+12
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4-6
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+7
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+1

   FDB STAR2
   FDB ADR_ARC-NBL_STAR1-2
   FDB STAR4
   FDB ADR_ARC-NBL_STAR2+4
   FDB STAR2
   FDB ADR_ARC-NBL_STAR3+8
   FDB STAR6
   FDB ADR_ARC+NBL_STAR5+3
   FDB STAR3
   FDB ADR_ARC+NBL_STAR6-3

   FDB ARC2
   FDB ADR_ARC
   FDB MIX7
   FDB ADR_MIX
   FDB CAT1
   FDB ADR_CAT

ANIM8
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2+6
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3+10
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4+16
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+5
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6-1

   FDB STAR3
   FDB ADR_ARC-NBL_STAR1-4
   FDB STAR5
   FDB ADR_ARC-NBL_STAR2+2
   FDB STAR3
   FDB ADR_ARC-NBL_STAR3+6
   FDB STAR5
   FDB ADR_ARC+NBL_STAR5+1
   FDB STAR4
   FDB ADR_ARC+NBL_STAR6+19

   FDB ARC2
   FDB ADR_ARC
   FDB MIX8
   FDB ADR_MIX
   FDB CAT2
   FDB ADR_CAT

ANIM9
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1-2
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2+4
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3+8
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4+14
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+3
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6-3

   FDB STAR4
   FDB ADR_ARC-NBL_STAR1+18
   FDB STAR6
   FDB ADR_ARC-NBL_STAR2
   FDB STAR4
   FDB ADR_ARC-NBL_STAR3+4
   FDB STAR4
   FDB ADR_ARC+NBL_STAR5-1
   FDB STAR5
   FDB ADR_ARC+NBL_STAR6+17

   FDB ARC1
   FDB ADR_ARC
   FDB MIX9
   FDB ADR_MIX
   FDB CAT3
   FDB ADR_CAT

ANIM10
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1-4
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2+2
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3+6
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4+12
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5+1
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+19

   FDB STAR5
   FDB ADR_ARC-NBL_STAR1+16
   FDB STAR1
   FDB ADR_ARC-NBL_STAR2-2
   FDB STAR5
   FDB ADR_ARC-NBL_STAR3+2
   FDB STAR3
   FDB ADR_ARC+NBL_STAR5-3
   FDB STAR6
   FDB ADR_ARC+NBL_STAR6+15

   FDB ARC1
   FDB ADR_ARC
   FDB MIXA
   FDB ADR_MIX
   FDB CAT4
   FDB ADR_CAT

ANIM11
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+18
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3+4
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4+10
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5-1
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+17

   FDB STAR6
   FDB ADR_ARC-NBL_STAR1+14
   FDB STAR2
   FDB ADR_ARC-NBL_STAR2-4
   FDB STAR6
   FDB ADR_ARC-NBL_STAR3
   FDB STAR2
   FDB ADR_ARC+NBL_STAR5-5
   FDB STAR1
   FDB ADR_ARC+NBL_STAR6+13

   FDB ARC2
   FDB ADR_ARC
   FDB MIXB
   FDB ADR_MIX
   FDB CAT5
   FDB ADR_CAT

ANIM12
   FDB STAR7
   FDB ADR_ARC-NBL_STAR1+16
   FDB STAR7
   FDB ADR_ARC-NBL_STAR2-2
   FDB STAR7
   FDB ADR_ARC-NBL_STAR3+2
   FDB STAR7
   FDB ADR_ARC+NBL_STAR4+8
   FDB STAR7
   FDB ADR_ARC+NBL_STAR5-3
   FDB STAR7
   FDB ADR_ARC+NBL_STAR6+15

   FDB STAR1
   FDB ADR_ARC-NBL_STAR1+12
   FDB STAR3
   FDB ADR_ARC-NBL_STAR2-6
   FDB STAR1
   FDB ADR_ARC-NBL_STAR3-2
   FDB STAR1
   FDB ADR_ARC+NBL_STAR5+17
   FDB STAR2
   FDB ADR_ARC+NBL_STAR6+11

   FDB ARC2
   FDB ADR_ARC
   FDB MIXC
   FDB ADR_MIX
   FDB CAT6
   FDB ADR_CAT

ANIMEND
