********************************************************************************
*                            NyanCatLoader pour TO8                            *
********************************************************************************
* Auteur  : OlivierP                                                           *
* Date    : avril 2024                                                         *
* Licence : GNU GPLv3 (http://www.gnu.org/copyleft/gpl.html)                   *
* Origine : https://github.com/OlivierP-To8/NyanCat                            *
********************************************************************************
*
* Permet de diviser par 3 le temps de chargement avec un entrelacement de 2.
*
* Temps mesurés :
* entrelacement | LOADER.BIN | NYANCAT.BAS |
* --------------|------------|-------------|
*   DSKINI 0,8  | 1 min 30 s | 1 min 37 s  |
*   DSKINI 0,7  | 1 min 17 s | 1 min 29 s  | (entrelacement par défaut)
*   DSKINI 0,6  | 1 min 07 s | 3 min 01 s  |
*
*   DSKINI 0,3  | 0 min 46 s | 3 min 13 s  |
*   DSKINI 0,2  | 0 min 31 s | 3 min 03 s  | (meilleur temps)
*   DSKINI 0,1  | 2 min 48 s | 2 min 57 s  |
********************************************************************************
* Ce programme est basé sur mon chargeur de .BIN sous Thomson DOS en pseudo C
*   https://github.com/OlivierP-To8/InufutoPorts/tree/main/Thomson/AUTO.LOAD
********************************************************************************


(main)Loader.asm

    org $7D20

***************************************
* tableaux en mémoire
***************************************
FATtable_   equ $7B00  * RMB sectorSize
Buffer_     equ $7C00  * RMB sectorSize
filebloc_   equ $7D00  * RMB maxFiles
filenbls_   equ $7D10  * RMB maxFiles

***************************************
* constantes
***************************************
STATUS  equ $6019   * Différents sémaphores
DKOPC   equ $6048   * Commande du contrôleur de disque
DKDRV   equ $6049   * Numéro du disque (0 à 3)
DKTRK   equ $604B   * Numéro de piste (0 à 39 ou 79)
DKSEC   equ $604C   * Numéro de secteur (1 à 16)
DKNUM   equ $604D   * Entrelacement des secteurs au formatage (7 par défaut)
DKSTA   equ $604E   * Etat du contrôleur de disquettes
DKBUF   equ $604F   * Pointeur de la zone tampon d'I/O disque (256 octets max)
LGA5    equ $E7E5   * Registre "RAM données"
LGA7    equ $E7E7   * Registre "système 1"
PUTC    equ $E803   * Affichage d'un caractère
DKCO    equ $E82A   * Contrôleur de disque
MODELE  equ $FFF0   * Modèle de la gamme

maxFiles      equ 15
sectorSize    equ 256 * 256 octets par secteur
sectorBytes   equ 255 * 255 octets utiles par secteur
freeBlock     equ $ff
reservedBlock equ $fe

    * set S (system stack)
    lds #FATtable_

    * ne pas interrompre
    orcc #$50

    * curseur invisible
    lda STATUS
    anda #$fb
    sta STATUS

    * initialisation des banques mémoire
    ldb MODELE
    cmpb #$03
    blt Main_end

    * si TO8/TO8D/TO9+
    lda $6081
    ora #$10        * gestion par registre interne $E7E5
    sta $6081
    sta LGA7

    * nb = listBinFiles_()
    jsr listBinFiles_

    * if nb < 13 goto Main_end
    cmpa #13
    bcs Main_end

    * nb = 3
    lda #3

Main_loopSample
    * if nb > 14 goto Main_nyancat
    cmpa #14
    bhi Main_nyancat

    * Putc('.')
    ldb #46
    jsr PUTC

    * set bank
    sta LGA5

    * LoadBinFile_(nb)
    jsr loadBinFile_

    * nb = nb + 1
    inca

    * goto Main_loopSample
    bra Main_loopSample

Main_nyancat
    * Putc('.')
    ldb #46
    jsr PUTC

    * LoadBinFile_(0)
    clra
    jsr loadBinFile_
    jmp ,X            * exec

Main_end
    rts


***************************************
* byte ReadSector(byte track, byte sector, word pDest)
***************************************
* entrée : A = track
*          B = sector
*          X = pDest
* sortie : A = 0 => OK
*              1 => code erreur
***************************************
ReadSector_

    * track in A
    sta DKTRK

    * sector in B
    stb DKSEC

    * buffer address in X
    stx DKBUF

    * read sector command
    lda #$02
    sta DKOPC

    * call ROM
    jsr DKCO
    bcc ReadSector_ok

    * error
    lda DKSTA
    bra ReadSector_end

ReadSector_ok
    lda #0

ReadSector_end
    rts


***************************************
* void CopyToAddress(word pDestination, word pSource, byte length)
***************************************
* 4285 cycles pour 250 octets (environ 17 cycles par octet)
***************************************
* entrée : X = pDestination
*          Y = pSource
*          B = length
***************************************
CopyToAddress_
    pshs a,b,x,y

CopyToAddress_loop
        lda ,y+
        sta ,x+
        subb #1
        bne CopyToAddress_loop

    puls a,b,x,y
    rts


***************************************
* byte StringEqual(word pString, word pConst)
***************************************
* entrée : X = chaîne à comparer
*          Y = const terminée par \0
* sortie : A = 0 => différent
*              1 => identique
***************************************
StringEqual_
    pshs b,x,y

        * différent par défaut
        lda #0

StringEqual_loop
        ldb ,y
        * si \0 alors ==
        beq StringEqual_OK
        cmpb ,x
        * si différence alors !=
        bne StringEqual_end
        * pointe vers le caractère suivant
        leax 1,x
        leay 1,y
        bra StringEqual_loop

StringEqual_OK
        lda #1

StringEqual_end
    puls b,x,y
    rts


***************************************
* byte listBinFiles()
***************************************
* Remplit les 2 tableaux filebloc_ et filenbls_
* avec pour chaque fichier :
*   - le premier bloc dans filebloc_
*   - le nb d'octet dans le dernier secteur dans filenbls_
* L'index des tableaux correspondent à la banque mémoire où
*   charger le fichier
***************************************
* sortie : A = nombre de fichiers mis dans les tableaux
***************************************
listBinFiles_
    pshs b,x,y

        * id : reg B
        * psrc : reg X

        * nb = 0
        clr LBF_nb

        * sector = 3
        lda #3
        sta LBF_sector

        lbra listBinFiles_loadSector

listBinFiles_loop
        lda ,x

        * if *psrc <= 0x20 goto listBinFiles_end
        cmpa #32
        lbls listBinFiles_end

        * if *psrc >= reservedBlock goto listBinFiles_end
        cmpa #reservedBlock
        lbcc listBinFiles_end

        * id = maxFiles
        ldb #maxFiles

        *** teste si fichier binaire

        * if psrc[8] != 'B' goto listBinFiles_nextFile
        lda 8,x
        cmpa #66
        bne listBinFiles_nextFile

        * if psrc[9] != 'I' goto listBinFiles_nextFile
        lda 9,x
        cmpa #73
        bne listBinFiles_nextFile

        * if psrc[10] != 'N' goto listBinFiles_nextFile
        lda 10,x
        cmpa #78
        bne listBinFiles_nextFile

        * if psrc[11] != 0x02 goto listBinFiles_nextFile
        lda 11,x
        cmpa #2
        bne listBinFiles_nextFile

        * if psrc[12] != 0x00 goto listBinFiles_nextFile
        tst 12,x
        bne listBinFiles_nextFile

        *** c'est un fichier binaire

        * compare psrc avec "SAMPLE"
        ldy #STR_SAMPLE
        jsr StringEqual_
        tsta
        beq listBinFiles_notSampleFile

        *** c'est un fichier SAMPLE à mettre en banque

        * calcule dans B la banque de mémoire où charger le fichier
        * id = psrc[7] - '0' + 2 : SAMPLE01.BIN en bank 3, ...
        ldb 7,x
        subb #48
        addb #2

        * if psrc[6] != '1' goto listBinFiles_notSampleFile
        lda 6,x
        cmpa #49
        bne listBinFiles_addFile
        * id = id + 10 : SAMPLE10/11/12.BIN en bank 12/13/14
        addb #10

        bra listBinFiles_addFile

listBinFiles_notSampleFile
        * compare psrc avec "NYANCAT "
        ldy #STR_NYANCAT
        jsr StringEqual_
        tsta
        beq listBinFiles_nextFile

        *** c'est le binaire à executer

        * calcule dans B la banque de mémoire où charger le fichier
        * id = 0 : pas en bank (de $8000 à $A000)
        clrb

listBinFiles_addFile
        * if id >= maxFiles goto listBinFiles_nextFile
        cmpb #maxFiles
        bcc listBinFiles_nextFile

        * get first bloc in filebloc[id]
        clra                 * d = id
        pshs b               * id
            addd #filebloc_
            tfr d,y
        puls b               * id
        * filebloc[id] = psrc[13]
        lda 13,x
        sta ,y

        * get nb bytes in last sector in filenbls[id]
        clra                 * d = id
        pshs b               * id
            addd #filenbls_
            tfr d,y
        puls b               * id
        * filenbls[id] = psrc[15]
        lda 15,x
        sta ,y

        * nb = nb + 1
        inc LBF_nb

listBinFiles_nextFile
        * psrc = psrc + 32
        leax 32,x

        * if psrc < Buffer_+sectorSize goto listBinFiles_loop
        cmpx #Buffer_+sectorSize
        bcs listBinFiles_loop

listBinFiles_loadSector
        * psrc = Buffer_
        ldx #Buffer_

        * ReadSector_(20,sector,Buffer_)
        lda #20
        ldb LBF_sector
        jsr ReadSector_

        * sector = sector + 1
        inc LBF_sector

        lbra listBinFiles_loop

listBinFiles_end
        * return nb
        lda LBF_nb

    puls b,x,y
    rts


***************************************
* void loadBinFile(byte nb)
***************************************
* Charge un fichier en mémoire à partir de 2 tableaux filebloc_ et filenbls_ avec
*   - le premier bloc dans filebloc_
*   - le nb d'octet dans le dernier secteur dans filenbls_
***************************************
* entrée : A = index des 2 tableaux à utiliser
* sortie : X = adresse de début du fichier
***************************************
loadBinFile_
    pshs a,b,y

        * nb = param @1
        sta LBF_nb

        * status = ReadSector_(20,2,FATtable_)
        lda #20
        ldb #2
        ldx #FATtable_
        jsr ReadSector_

        * if status != 0 goto loadBinFile_end
        tsta
        lbne loadBinFile_end

        * address = 0xA000
        ldd #$A000
        std LBF_address

        * block = filebloc[nb]
        clra
        ldb LBF_nb
        addd #filebloc_
        tfr d,x
        lda ,x
        sta LBF_block

        * start = true
        lda #1
        sta LBF_start

loadBinFile_loopBlock
        * if block == freeBlock goto loadBinFile_end
        lda LBF_block
        cmpa #freeBlock
        lbeq loadBinFile_end

        * track = block >> 1
        lsra
        sta LBF_track

        * sector = 1
        lda #1
        sta LBF_sector

        * if ((block & 0x01) != 0x01) goto loadBinFile_setBlock (1 block = 8 sectors)
        lda LBF_block
        anda #1
        cmpa #1
        bne loadBinFile_setBlock

        * sector = 9
        lda #9
        sta LBF_sector

loadBinFile_setBlock
        * block = FATtable[block+1]
        clra
        ldb LBF_block
        incb
        addd #FATtable_
        tfr d,x
        lda ,x
        sta LBF_block

        * nbSectors = 8
        lda #8
        sta LBF_nbSectors

        * i = 0
        clr LBF_i

        * if block <= 0xc0 goto loadBinFile_loopSector
        lda LBF_block
        cmpa #$C0
        bls loadBinFile_loopSector

        * nbSectors = block - 0xc0
        suba #$C0
        sta LBF_nbSectors

        * block = freeBlock
        lda #freeBlock
        sta LBF_block

loadBinFile_loopSector
        * if i >= nbSectors goto loadBinFile_loopBlock
        lda LBF_i
        cmpa LBF_nbSectors
        bcc loadBinFile_loopBlock

        * nbBytes = sectorBytes
        ldb #sectorBytes
        stb LBF_nbBytes

        * if block != freeBlock goto loadBinFile_firstSector
        lda LBF_block
        cmpa #freeBlock
        bne loadBinFile_firstSector

        * if i + 1 != nbSectors goto loadBinFile_firstSector
        lda LBF_i
        inca
        cmpa LBF_nbSectors
        bne loadBinFile_firstSector

        * read last sector of file
        * nbBytes = filenbls[nb] - 5 (remove end of binary)
        clra
        ldb LBF_nb
        addd #filenbls_
        tfr d,x
        ldb ,x
        subb #5
        stb LBF_nbBytes

        * ReadSector_(track,sector,Buffer_)
        lda LBF_track
        ldb LBF_sector
        ldx #Buffer_
        jsr ReadSector_

        * CopyToAddress_(address,Buffer_,nbBytes)
        ldb LBF_nbBytes
        ldx LBF_address
        ldy #Buffer_
        jsr CopyToAddress_

        * goto loadBinFile_end
        bra loadBinFile_end

loadBinFile_firstSector
        * if start == 0 goto loadBinFile_readSector
        tst LBF_start
        beq loadBinFile_readSector

        * read first sector of file
        * ReadSector_(track,sector,Buffer_)
        lda LBF_track
        ldb LBF_sector
        ldx #Buffer_
        jsr ReadSector_

        * address = (Buffer[3] << 8) + Buffer[4]
        ldx #Buffer_+3
        lda ,x
        ldx #Buffer_+4
        ldb ,x
        std LBF_address
        * garde l'adresse de début pour le rts
        pshs d

        * start = 0
        clr LBF_start

        * nbBytes = sectorBytes - 5 (remove start of binary)
        ldb #sectorBytes
        subb #5
        stb LBF_nbBytes

        * CopyToAddress_(address,Buffer_+5,nbBytes)
        ldx LBF_address
        ldy #Buffer_+5
        jsr CopyToAddress_

        * goto loadBinFile_nextSector
        bra loadBinFile_nextSector

loadBinFile_readSector
        * ReadSector_(track,sector,address)
        lda LBF_track
        ldb LBF_sector
        ldx LBF_address
        jsr ReadSector_

loadBinFile_nextSector
        * address += nbBytes
        clra
        ldb LBF_nbBytes
        addd LBF_address
        std LBF_address

        * sector = sector + 1
        inc LBF_sector

        * i = i + 1
        inc LBF_i

        * goto loadBinFile_loopSector
        lbra loadBinFile_loopSector

loadBinFile_end
    puls x         * adresse de début
    puls a,b,y
    rts


***************************************
* variables
***************************************
STR_SAMPLE      FCS "SAMPLE"
STR_NYANCAT     FCS "NYANCAT "
LBF_nb          FCB $00
LBF_address     FDB $0000
LBF_block       FCB $00
LBF_start       FCB $00
LBF_track       FCB $00
LBF_sector      FCB $00
LBF_i           FCB $00
LBF_nbSectors   FCB $00
LBF_nbBytes     FCB $00


    end $7D20

