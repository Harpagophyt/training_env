# Anleitung und Informationen

# Vorbereitung
Kontrollieren, ob Plattenplatz genug vorhanden ist (siehe Partitionieren)
Variablen ändern in vars/vars.yml
* vm_image_path -> wohin die images gelegt werden sollen
* ssh_user -> welcher user ist der Teilnehmer, wer baut die Verbindungen auf?
* ssh_user_home -> wo soll der ssh key ... hingestellt werden
* training_type -> ist es ein linux oder ansible training

## Partitionieren
Nachstehend eine Beispielsitzung wo `/dev/sda` mit MS DOS Partitionierung,
und ein zugehöriges LVM erweitert wird.
```bash
lsblk
parted /dev/sda
    unit s
    print
    mkpart primary xfs _____s 100%
    set 3 lvm on
    print
    quit
udevadm settle
pvcreate /dev/sda3
vgextend vg_system /dev/sda3
lvextend -r -l +100%FREE vg_system/lv_root
```

## bin/build_inventory.sh
mit nmap wird eine Liste aller IP Adressen des subnets erzeugt.
Das subnet muss angegeben werden.
Beispiel: `bin/build_inventory.sh 192.168.1.0/24`

## bin/init.sh
erzeugt das lokale environment
erzeuge die `known_hosts` mit `ssh-keyscan $(cat inventory/inventory) >> ~/.ssh/known_hosts`

## Dateien sharen
Alle Dateien welche an Teilnehmer verteilt werden sollen, unter `shared_files` 
legen und danach das Playbook `share.yml` ausführen.

## Starten
`ansible-playbook playbook.yml -k` startet das ganze.
Alternativ funtkioniert auch `ssh-pass -predhat ansible-playbook playbook.yml -k`