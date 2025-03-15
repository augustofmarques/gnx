#!/usr/bin/env bash
#####################################################################
# AUTOR   : Jefferson Carneiro
# PRG     : make-kassandra
# VERSAO  : 1.0
# LICENCA : GPLv3
#
# DESC
# Programa para criaçaõa de live iso da kassandra.
# Cria a Estrutura utilizando o live-build como componente principal.
# E copia cada arquivo/diretório para seu local correto.
# A edição deve ser feito no diretório raiz do projeto e não deve
# ser alterado no diretório que é gerado.
#####################################################################
set -e

############################################
# Configurações Escopo Global
############################################
export ISO_NAME="kassandra"
export CODENAME="Átermis"
export ISO_PUBLISHER="Jefferson Carneiro"
export DEBIAN_VERSION="bookworm"
export REPO_ENABLED="main non-free-firmware"
export USERNAME="live"
# Modo interativo chroot 0=on 1=off
export INTERACTIVE="0"
# Diretório de estrutura inicial
export WORKDIR=$(pwd)
# Onde será gerado a iso e configurações
export DIR_CREATE_LIVE="${WORKDIR}/GENERATE-LIVE-DIR"
############################################

############################################
# FUNÇÕES
############################################
DIE() {
    local msg="$@"
    echo -e "$msg"
    exit 1
}

# Telinha inicial
clear
if [[ "$INTERACTIVE" = 0 ]]; then
    INFO_INTERACTIVE="Habilitado"
else
    INFO_INTERACTIVE="Desabilitado"
fi

cat << EOF
+---------------------------------------------------------+
| Bem vindo ao live-build da Kassandra 🍄‍🇧🇷               |
| Vamos começar a configuração do live-build...           |
| Este é um processo que pode demorar dependendo da conf  |
| de sua máquina e banda.                                 |
+---------------------------------------------------------+
 📦 UtilizandO Codenome     : $DEBIAN_VERSION
 📦 Repositórios Ativados   : $REPO_ENABLED
 📀 Diretório de criação ISO: $DIR_CREATE_LIVE
 ⌨️  Modo interativo chroot  : $INFO_INTERACTIVE
EOF

read -p $'\nPRESSIONE [ENTER] para começar.' null

############################################
# Testes
############################################

# Checando conexão com internet
if nc -zw1 google.com 443 &>/dev/null; then
    echo "🛜Conectividade com internet ✅"
    sleep 0.2s
else
    DIE "🛜Sem Conectividade com internet 😮‍💨 ❌"
fi

# Verificação live-build package
if ! which live-build &>/dev/null; then
    DIE "📦 Instale o pacote {live-build} 😮‍💨❌"
fi

# Verificação de diretórios essenciais.
cd $WORKDIR

# Diretorios para checar, são obrigatórios.
directories=("package-lists" "includes.chroot" "bootloaders" "hooks" "icons" "backgrounds")

# Vamos fazer o check agora.
for dir_check in "${directories[@]}"; do
    if [[ -d "$dir_check" ]]; then
        echo "📂 Diretório: $dir_check ✅"
        sleep 0.2s
    else
        DIE "📂 Diretório: {$dir_check} [NÃO EXISTE] 😮‍💨 ❌"
    fi
done

echo -e "🪛 Testes Iniciais ✅"
sleep 0.2s

############################################
# Estrutura Inicial
############################################
mkdir ${DIR_CREATE_LIVE}
cd ${DIR_CREATE_LIVE}
echo -e "📂 Estutura inicial ✅"
sleep 0.2s

############################################
# Limpeza Inicial
############################################
lb clean &>/dev/null && lb clean --purge &>/dev/null
echo -e "🪛 Limpeza Executada ✅"
sleep 0.2s

############################################
# Criação de Configuração.
############################################

# Ligar o modo chroot interativo?
if [[ "$INTERACTIVE" = '0' ]] || [[ -n "$INTERACTIVE" ]]; then
    export INTERACTIVE='true'
else
    export INTERACTIVE='false'
fi

lb config noauto \
   --binary-images iso-hybrid \
   --mode debian \
   --architectures amd64 \
   --image-name "$ISO_NAME" \
   --linux-flavours amd64 \
   --distribution "$DEBIAN_VERSION" \
   --archive-areas "$REPO_ENABLED" \
   --parent-archive-areas "$REPO_ENABLED" \
   --parent-debian-installer-distribution "$DEBIAN_VERSION" \
   --debian-installer-gui false \
   --updates true \
   --interactive true \
   --memtest none \
   --security true \
   --cache true \
   --apt-recommends true \
   	--iso-application "$ISO_NAME" \
  	--iso-preparer "$ISO_NAME" \
   	--iso-publisher "$ISO_PUBLISHER" \
   	--iso-volume "$ISO_NAME" \
   	--checksums sha512 \
   --bootappend-live "boot=live locales=pt_BR.UTF-8 keyboard-layouts=br username=$USERNAME hostname=$ISO_NAME timezone=America/Sao_Paulo autologin" \
   "${@}" &>/dev/null

echo -e "\n🪛 Criação de Configuração ✅"
sleep 0.2s

############################################
# Mova os arquivos para locais corretos
############################################

# Arquivos de configurações permanente
cp -r ${WORKDIR}/includes.chroot/ ${DIR_CREATE_LIVE}/config/

# Arquivos de configurações somente em live-cd
cp -r ${WORKDIR}/includes.chroot/* ${DIR_CREATE_LIVE}/config/includes.binary/

# Scripts para execução em chroot.
cp ${WORKDIR}/hooks/* ${DIR_CREATE_LIVE}/config/hooks/normal/

# Icones personalizados.
# Precisamos primeiramente criar o diretório pois não existe.
mkdir -p ${DIR_CREATE_LIVE}/config/includes.chroot/usr/share/icons/default/
cp ${WORKDIR}/icons/* ${DIR_CREATE_LIVE}/config/includes.chroot/usr/share/icons/default/

# Wallpaper Personalizado
#mkdir -p ${DIR_CREATE_LIVE}/config/includes.chroot/usr/share/backgrounds/kassandra
#cp ${WORKDIR}/backgrounds/* ${DIR_CREATE_LIVE}/config/includes.chroot/usr/share/backgrounds/kassandra/


# Bootloaders (grub)
cp -r ${WORKDIR}/bootloaders/ ${DIR_CREATE_LIVE}/config/

# Lista de pacotes para ser instalados
cp -r ${WORKDIR}/package-lists/* ${DIR_CREATE_LIVE}/config/package-lists/

# preseed, instalador cli/gráfico
cp "${WORKDIR}/preseed.cfg" ${DIR_CREATE_LIVE}/config/includes.installer/

echo -e "🪛 Cópia para o diretório: ${DIR_CREATE_LIVE} ✅"
sleep 1s

############################################
# Construa
############################################
echo -e "🪛🔧🔨 Iniciando Construção de Live 🟢\n"
sleep 5s
lb build

echo -e "\nImagem .iso criada em: {$DIR_CREATE_LIVE} 💿"
