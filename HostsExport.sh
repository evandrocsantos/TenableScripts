#!/usr/bin/env bash
#
# Este script efetua a extração de hosts únicos, a partir de um arquivo .csv exportado pelo Nessus Professional e 
# o prepara para importação e leitura por outros aplicativos, como um leitor de planilha, exportando o resultado
# para um arquivo .txt
#
# Execução
#
# É necessário executar o script no mesmo diretório em que está o arquico .csv gerado pelo Nessus, para que a 
# a leitura do conteúdo seja feita e os dados trabalhados.
#
# Elaborado por: Evandro Santos
# E-mail de contato: evandro.santos@tutanota.com
# Versão do Script: 1.0

# Nome do arquivo exportado com o resultado
hosts_result="hosts.txt"

# Início do Processamento
for relatorio in *.csv; do
  echo "`date`: Processando o Relatório ${relatorio}"

  tr -d '\n\r' <"${relatorio}" | sed -e 's/""\([0-9]\+\)"/"\n"\1"/g;s/,Plugin Output"/,Plugin Output"/g' >"${relatorio}.tmp"

  # # # # # hosts
  if [ -f "${relatorio/.csv/}-${hosts_result}" ]; then
    echo "`date`: Analisando lista de hosts identificados e Removendo valores duplciados... Pronto!"
  else
    echo "`date`: Analisando lista de hosts identificados"
    grep '","[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+","' <"${relatorio}.tmp" | \
      cut -d',' -f5 | tr -d '"' | sort -V | uniq >"${relatorio}-${hosts_result}.tmp"
    mv -f -- "${relatorio}-${hosts_result}.tmp" "${relatorio/.csv/}-${hosts_result}"
  fi
