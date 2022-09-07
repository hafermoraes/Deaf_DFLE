all: help

dependencies: ## Install required dependencies
	@echo 'Installing OS dependencies...'
	sudo apt install wget unzip docker*
	@echo 'Configuring docker...'
	sudo usermod -a -G docker $USER ; newgrp docker
	@echo '... done.'
	@echo 'Installing the GNU R dependencies...'
	sudo apt install r-cran-dplyr r-cran-readr r-cran-readxl r-cran-stringr r-cran-tidyr r-cran-survey
	@echo '... done.'

extract: ## Fetch the dictionary and microdata of National Health Survey (PNS2019) from FTP Server and save it to disk
	@echo 'Fetching the PNS 2019 microdata and saving it to disk...'
	@rm -rf /tmp/paa_pns/; mkdir /tmp/paa_pns 
	@wget --no-passive-ftp -tries=100 ftp://ftp.ibge.gov.br/PNS/2019/Microdados/Dados/PNS_2019_20220525.zip -O /tmp/paa_pns/pns_2019.zip >/dev/null 2>&1
	@echo 'DONE. Unziping the microdata...'
	@unzip /tmp/paa_pns/pns_2019.zip -d /tmp/paa_pns/ >/dev/null 2>&1
	@echo 'DONE. Deleting the downloaded zip file...'
	@rm -rf /tmp/paa_pns/pns_2019.zip
	@echo 'DONE.'
	@echo 'Fetching the PNS 2019 data dictionary and saving it to disk...'
	@wget --no-passive-ftp -tries=100 ftp://ftp.ibge.gov.br/PNS/2019/Microdados/Documentacao/Dicionario_e_input_20220530.zip -O /tmp/paa_pns/pns_2019.zip >/dev/null 2>&1
	@echo 'DONE. Unziping the data dictionary...'
	@unzip /tmp/paa_pns/pns_2019.zip -d /tmp/paa_pns/ >/dev/null 2>&1
	@echo 'DONE. Deleting the downloaded zip file...'
	@rm -rf /tmp/paa_pns/pns_2019.zip
	@echo 'DONE.'
	@echo 'Fetching the abbreviated life tables from 2010th edition of brazilian census...'
	@wget --no-passive-ftp -tries=100 ftp://ftp.ibge.gov.br/Tabuas_Abreviadas_de_Mortalidade/2010/tabelas_xls.zip -O /tmp/paa_pns/censo2010_lifetables.zip >/dev/null 2>&1
	@unzip -j /tmp/paa_pns/censo2010_lifetables.zip "tabela_1_1.xls" -d /tmp/paa_pns >/dev/null 2>&1
	@rm -rf /tmp/paa_pns/censo2010_lifetables.zip
	@mv /tmp/paa_pns/tabela_1_1.xls /tmp/paa_pns/censo2010_lifetables.xls
	@echo 'DONE.'

transform: ## Prepare files for ingesting into postgres database
	@echo 'Preparing microdata and data dictionary for database ingestion...'
	@Rscript pns2019_args_cut.R >/dev/null 2>&1
	@sh pns2019_create_csvs.sh >/dev/null 2>&1
	@Rscript popcensus2010_lifetables.R >/dev/null 2>&1
	@echo 'DONE.'

load: ## Ingest treated data into the database
	@echo 'Ingesting the treated microdata and data dictionary into database...'
	@psql -U rmoraes -d postgres < paa2022_create_db.sql
	@echo 'DONE.'

.PHONY: help
help: ## Show this help message
	@echo 'Makefile documentation for the PAA/PNS2019 paper'
	@echo ''
	@echo 'Usage:'
	@echo '    make [target]'
	@echo ''
	@echo 'Targets:'
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\t%-25s %s\n", $$1, $$2}'
	@echo ''
