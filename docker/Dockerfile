# from the repo's base directory, build image with:
#    docker buildx build --tag deaf_dfle_rr --file docker/Dockerfile .

# run Rstudio inside container with
#    docker run -it --rm --publish 8787:8787 --env DISABLE_AUTH=true deaf_dfle_rr

# Note: This rocker image contains all needed packages for etl and analyses purposes
FROM rocker/tidyverse:4.4.1

RUN Rscript -e "install.packages(c('survey', 'srvyr', 'ggstats', 'svglite', 'PNSIBGE'))"

WORKDIR /home/rstudio/
