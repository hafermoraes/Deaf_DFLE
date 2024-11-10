# global variables
uid=$(shell id -u)
gid=$(shell id -g)
etl=${HOME}/git/Deaf_DFLE/etl
etl_docker_image=rocker/tidyverse:4.4.1
image_name=deaf_dfle

all: help

data: ## Extract, transform and load data sources for analyses
	# National Health Survey 2019 (br_ibge_pns_2019)
	docker run -it --rm \
		--volume /tmp/:/tmp/ \
		--volume $(etl)/:/etl/ \
		--user ${uid}:${gid} \
		$(etl_docker_image) \
		sh -c "cd /etl/br_ibge_pns_2019 && sh etl.sh"
	# Abridged Life Tables from 2010 Census (br_ibge_censo_2010)
	docker run -it --rm \
		--volume /tmp/:/tmp/ \
		--volume $(etl)/:/etl/ \
		--user ${uid}:${gid} \
		$(etl_docker_image) \
		sh -c "cd /etl/br_ibge_censo_2010 && sh etl.sh"
	# Abridged Life Tables from 2019 (de_mpidr_hld)
	docker run -it --rm \
		--volume /tmp/:/tmp/ \
		--volume $(etl)/:/etl/ \
		--user ${uid}:${gid} \
		$(etl_docker_image) \
		sh -c "cd /etl/de_mpidr_hld && sh etl.sh"
	# populate repo with processed data
	mkdir -p data/
	mv /tmp/etl/* data/

build: ## build Rstudio container when all sources are processed
	docker buildx build -t ${image_name} -f ${HOME}/git/Deaf_DFLE/docker/Dockerfile /
	docker run -it --rm \
		--detach \
		--publish 8787:8787 \
		--volume analyses/:/home/rstudio/analyses/ \
		--env DISABLE_AUTH=true \
		--user ${uid}:${gid} \
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
