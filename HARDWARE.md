# Comment utiliser sur un TO8/TO8D/TO9+


## Avec une machine, sous DOS/Windows ayant un lecteur compatible 720k, ou un Amiga

Ecrire l'image **NyanCatTO8.fd** sur disquette Double Densité avec l'outil adapté à votre système :
- Windows : [Omniflop](http://www.shlock.co.uk/Utils/OmniFlop/OmniFlop.htm),
- DOS : [DCFDUTIL](http://dcmoto.free.fr/emulateur/prog/dcfdutil33.zip),
- Amiga : [ToDisk](http://aminet.net/package/disk/misc/ToDisk).

Pour réduire le temps de chargement par 3, il faut utiliser un facteur d'entrelacement de 2 plutôt que celui de 7 par défaut. Pour changer le facteur d'entrelacement de la disquette sur TO8/TO8D/TO9+, entrer les instructions suivantes en BASIC 512 :
- formater la face 1 si ce n'est pas déjà fait : **DSKINI 1**
- copier la face 0 sur la face 1 : **BACKUP 0 TO 1**
- reformater la face 0 avec un facteur d'entrelacement de 2 : **DSKINI 0,2**
- copier la face 1 sur la face 0 : **BACKUP 1 TO 0**


## Avec un SDDRIVE

Utiliser un [SDDRIVE](http://dcmoto.free.fr/bricolage/sddrive/index.html) et mettre **NyanCatTO8.sd** sur une carte microSD. Attention il y a une manipulation supplémentaire sur TO8D et TO9+ pour désactiver le lecteur interne.


## Avec un lecteur HxC ou HxC Gotek et un câble DIN spécifique

Faire un [câble DIN 14 pour lecteur externe de disquette](http://forum.system-cfg.com/viewtopic.php?p=53096#p53096) et y brancher un [HxC](https://hxc2001.com/floppy_drive_emulator/) ou [HxC Gotek](https://hxc2001.com/docs/gotek-floppy-emulator-hxc-firmware/) configuré en Shugart et contenant l'image **NyanCatTO8.hfe**. Il faut prévoir une alimentation 5V externe pour le lecteur HxC.

Une fois branché, choisir le BASIC 512 et entrer **DEVICE"2:"** suivi de **RUN"AUTO.BAT"**

Pour copier le contenu du HxC sur une disquette dans le lecteur interne, entrer les instructions suivantes en BASIC 512 :
- formater la face 0 avec un facteur d'entrelacement de 2 : **DSKINI 0,2**
- copier la face 2 sur la face 0 : **BACKUP 2 TO 0**


## Avec DC Transferts et une machine ayant un lecteur compatible DOS 720k

Faire une disquette Thomson contenant [DC Transferts](http://dcmoto.free.fr/programmes/dctransferts/index.html), mettre l'image **NyanCatTO8.fd** sur une autre disquette Double Densité formatée DOS 720k, et créer une troisième disquette sur le Thomson avec les deux précédentes.


## Avec une interface CC90-232 et un câble série 

Avec une interface CC90-232 et un câble série, faire un transfert série en utilisant [CC90](http://www.pulsdemos.com/cc90.html).


# Comment utiliser sur un MO6


## Avec un câble audio

Souder un câble audio sur le lecteur de cassette du MO6, sur [TK02](https://forum.system-cfg.com/viewtopic.php?p=246642#p246642) et la masse, Puis lancer **RUN"** en BASIC 128 et lire le fichier **NyanCatMO6.wav**.


## Avec un SDDRIVE

Utiliser un [SDDRIVE](http://dcmoto.free.fr/bricolage/sddrive/index.html) avec **NyanCatMO6.sd** sur une carte microSD. Choisir "1" au menu de démarrage.


## Avec un SDLEP-READER

Utiliser un [SDLEP-READER](http://dcmoto.free.fr/bricolage/sdlep-reader/index.html) avec **NyanCatMO6.lep** sur une carte microSD. Choisir "1" au menu de démarrage et lancer **RUN"**

