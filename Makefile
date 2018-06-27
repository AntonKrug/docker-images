SUBDIRS   := $(wildcard */.)
MAKEFLAGS := --jobs=1  # force sequential execution as docker doesn't like concurent
$(eval TAG=$(shell git log -1 --pretty=%h))
VARIABLES = '$$SOFTCONSOLE_INTERANET_BASE_URL $$SOFTCONSOLE_5_3 $$SOFTCONSOLE_5_3_BASE'
SOFTCONSOLE_5_3_BASE=`echo ${SOFTCONSOLE_5_3}|cut -d'.' -f1-3`

.PHONY: all $(SUBDIRS)
all: $(SUBDIRS)
	@docker images

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	echo
	$(eval IMAGE=$(@:/.=))
	echo "Building: ${DOCKER_USER}/${IMAGE}:${TAG}"
	$(eval BASE_IMAGE=`cat ./${IMAGE}/Dockerfile | grep FROM | cut -d' '  -f2`)
	echo Make sure we are using the newest base image: ${BASE_IMAGE}
	@docker pull ${BASE_IMAGE}
	echo "SC 5.3: ${SOFTCONSOLE_5_3_BASE}"
	cat ./${IMAGE}/Dockerfile | envsubst ${VARIABLES} | docker build -t ${DOCKER_USER}/${IMAGE}:${TAG} -
	@docker tag -f ${DOCKER_USER}/${IMAGE}:${TAG} ${DOCKER_USER}/${IMAGE}:latest
	@docker push ${DOCKER_USER}/${IMAGE}


.PHONY: login-email
login-email:
	@docker login -u ${DOCKER_USER} -e ${DOCKER_EMAIL} -p ${DOCKER_PASS}


.PHONY: login
login:
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
