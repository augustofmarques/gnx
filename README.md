# Criação de distribuição Debian utilizando live-build
Utilizando live-build debian.

### Arquivos
* includes.chroot = Tudo que será incluso dentro do ambiente final.
* bootloaders     = Bootloaders grub etc...
* package-lists   = Lista de pacotes para instalação da live/ambiente final.
* preseed.cfg     = Utilizado para instalador gráfico/cli do debian
* make-kassandra.sh = Geração da live iso
