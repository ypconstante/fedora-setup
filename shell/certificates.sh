#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_base.sh"

my:step_begin "install openssl"
my:dnf_install openssl
my:step_end

TARGET_DIR='/usr/share/pki/ca-trust-source/anchors/'

install_certificate() {
    local url="$1"
    local name=$(basename "$url")
    my:step_begin "download certificate $name"
    certificate_temp_file="/tmp/$name"

    curl -L --cookie "security=true" "$url" -o "$certificate_temp_file"

    sudo cp "$certificate_temp_file" "$TARGET_DIR"

    rm "$certificate_temp_file"

    my:step_end
}

# http://receita.economia.gov.br/orientacao/tributaria/senhas-e-procuracoes/senhas/certificados-digitais/alerta-de-pagina-nao-confiavel-atualizacao-da-cadeia-de-certificacao
install_certificate 'http://acraiz.icpbrasil.gov.br/credenciadas/RAIZ/ICP-Brasilv2.crt'
install_certificate 'http://acraiz.icpbrasil.gov.br/credenciadas/RFB/v2/p/AC_Secretaria_da_Receita_Federal_do_Brasil_v3.crt'
install_certificate 'http://acraiz.icpbrasil.gov.br/credenciadas/RFB/v2/AC_Serpro_RFB_v4.crt'
install_certificate 'http://acraiz.icpbrasil.gov.br/credenciadas/RFB/v2/Autoridade_Certificadora_do_SERPRO_RFB_SSL.crt'
install_certificate 'http://acraiz.icpbrasil.gov.br/credenciadas/RAIZ/ICP-Brasilv5.crt'
install_certificate 'http://acraiz.icpbrasil.gov.br/credenciadas/RFB/v5/p/AC_Secretaria_da_Receita_Federal_do_Brasil_v4.crt'
install_certificate 'http://acraiz.icpbrasil.gov.br/credenciadas/RFB/v5/Autoridade_Certificadora_SERPRORFBv5.crt'


# http://www.caixa.gov.br/site/paginas/downloads.aspx
my:step_begin "download certificates caixa"
certificate_chain_compressed_file=/tmp/certificate--caixa.zip
certificate_chain_dir=/tmp/certificate--caixa

curl -L \
    --cookie "security=true" \
    'http://www.caixa.gov.br/Downloads/certificado-digital-cadeia-certificados/cadeiacompleta.zip' \
    -o "$certificate_chain_compressed_file"
unzip $certificate_chain_compressed_file -d $certificate_chain_dir

certificate_chain_p7b_file=$(find $certificate_chain_dir -name '*.p7b')
certificate_chain_crt_file="$TARGET_DIR/caixa.crt"

sudo openssl pkcs7 -print_certs -in "$certificate_chain_p7b_file" -out "$certificate_chain_crt_file"
sudo restorecon -v "$certificate_chain_crt_file"
rm -rf "$certificate_chain_compressed_file" "$certificate_chain_dir" "$certificate_chain_p7b_file"
my:step_end

my:step_begin "update certificates"
sudo update-ca-trust
my:step_end
