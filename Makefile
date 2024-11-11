# global variables
uid=$(shell id -u)
gid=$(shell id -g)
repo=${HOME}/git/Deaf_DFLE
etl_docker_image=rocker/tidyverse:4.4.1
image_name=deaf_dfle

all: help

fetch_data: ## Extract, transform and load data sources for analyses
	# National Health Survey 2019 (br_ibge_pns_2019)
	docker run -it --rm \
		--volume /tmp/:/tmp/ \
		--volume $(repo)/etl/:/etl/ \
		--user ${uid}:${gid} \
		$(etl_docker_image) \
		sh -c "cd /etl/br_ibge_pns_2019 && sh etl.sh"
	# Abridged Life Tables from 2010 Census (br_ibge_censo_2010)
	docker run -it --rm \
		--volume /tmp/:/tmp/ \
		--volume $(repo)/etl/:/etl/ \
		--user ${uid}:${gid} \
		$(etl_docker_image) \
		sh -c "cd /etl/br_ibge_censo_2010 && sh etl.sh"
	# Abridged Life Tables from 2019 (de_mpidr_hld)
	docker run -it --rm \
		--volume /tmp/:/tmp/ \
		--volume $(repo)/etl/:/etl/ \
		--user ${uid}:${gid} \
		$(etl_docker_image) \
		sh -c "cd /etl/de_mpidr_hld && sh etl.sh"
	# populate repo with processed data
	# Abridged Life Tables from Brazilian Census 2010 (br-ibge-censo-2010)
	mkdir -p data/br_ibge_censo_2010
	mv /tmp/etl/br_ibge_censo_2010/data/* data/br_ibge_censo_2010/
	# National Health Service (br-ibge-pns-2019)
	mkdir -p data/br_ibge_pns_2019
	mv /tmp/etl/br_ibge_pns_2019/variables_dictionary.txt data/br_ibge_pns_2019/
	mv /tmp/etl/br_ibge_pns_2019/parquet/* data/br_ibge_pns_2019/
	# Abridged Life Tables from Max Planck's Human Lifetable Database (de-mpidr-hld)
	mkdir -p data/de_mpidr_hld
	mv /tmp/etl/de_mpidr_hld/data/* data/de_mpidr_hld/

build: ## build Rstudio container when all sources are processed
	@docker buildx build \
		--tag ${image_name} \
		--file ${HOME}/git/Deaf_DFLE/docker/Dockerfile \
		.
	@docker run -it --rm \
		--detach \
		--volume ${repo}/analyses/:/home/rstudio/analyses/ \
		--volume ${repo}/data/:/home/rstudio/data/ \
		--publish 8787:8787 \
		--name deaf_dfle_rr \
		--env DISABLE_AUTH=true \
		${image_name}
	@echo "Access RStudio web by visiting http://localhost:8787 ..."


.PHONY: help
help: ## Show this help message
	@echo 'Makefile documentation for the Deaf Depression-free Life Expectancy paper'
	@echo ''
	@echo 'Usage:'
	@echo '    make [target]'
	@echo ''
	@echo 'Targets:'
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\t%-25s %s\n", $$1, $$2}'
	@echo ''
