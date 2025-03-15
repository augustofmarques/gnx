# Criação de distribuição Debian utilizando live-build USO PESSOAL.
Utilizo este script para criar minha própria distribuição com configurações pessoais já pré-existentes. Baseado em Debian.
É utilizado um script chamado live-build do próprio projeto Debian para fazer este processo. Todo processo é automatizado atráves do script make-kassandra.sh. Ao final é criado um sistema
totalmente utilizável, com live-cd e com instalador calamares incluso.

### Arquivos
* includes.chroot = Tudo que será incluso dentro do ambiente final.
* bootloaders     = Bootloaders grub etc...
* hooks           = Scripts que serão executados em CHROOT.
* package-lists   = Lista de pacotes para instalação da live/ambiente final. Tudo que estiver dentro deste diretório será instalado, utilize somente o preset que você deseja.
* preseed.cfg     = Utilizado para instalador gráfico/cli do debian. Neste caso não é utilizado, pois utilizo o calamares.
* make-kassandra.sh = Gere a live iso
