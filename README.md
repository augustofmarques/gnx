# Criação de distribuição Debian utilizando live-build USO PESSOAL.
Utilizo este script para criar minha própria distribuição com configurações pessoais já pré-existentes. Baseado em Debian.
É utilizado um script chamado live-build do próprio projeto Debian para fazer este processo. Todo processo é automatizado atráves do script make-kassandra.sh. Ao final é criado um sistema
totalmente utilizável, com live-cd e com instalador calamares incluso.

Veja o meu video:
[![Watch the video](https://i9.ytimg.com/vi/1-B8OXjmzr0/maxresdefault.jpg?v=67d62afd&sqp=CKytgb8G&rs=AOn4CLAfrRyBz3OxgVqFeWkw8Xt2QNMrBg)](https://youtu.be/1-B8OXjmzr0)

### Arquivos
* includes.chroot = Tudo que será incluso dentro do ambiente final.
* bootloaders     = Bootloaders grub etc...
* hooks           = Scripts que serão executados em CHROOT.
* package-lists   = Lista de pacotes para instalação da live/ambiente final. Tudo que estiver dentro deste diretório será instalado, utilize somente o preset que você deseja.
* preseed.cfg     = Utilizado para instalador gráfico/cli do debian. Neste caso não é utilizado, pois utilizo o calamares.
* make-kassandra.sh = Gere a live iso

## Nota Calamares
Por ser configurações do calamares personalizadas e testado no bookworm, no trixie a chance de ter problemas é grande.
Para usar o trixie altere as configurações do Calamares tambem.

## Modo de uso
```
$ git clone https://github.com/augustofmarques/gnx
$ cd make-debian-live
# bash make-kassandra.sh
```
A iso sera gerada no diretório GENERATE-LIVE-DIR/. Você pode alterar, por exemplo, se deseja trocar para gerar a configuração e ISO final com o nome de (meu-debian) altere a variável DIR_CREATE_LIVE:
```
# Antes
export DIR_CREATE_LIVE="${WORKDIR}/GENERATE-LIVE-DIR"

# Depois
export DIR_CREATE_LIVE="${WORKDIR}/meu-debian"
```
