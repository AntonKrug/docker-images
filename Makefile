SC_CAPTURE ?= 5.4
SUBDIRS   := $(wildcard */.)
MAKEFLAGS := --jobs=1  # force sequential execution as docker doesn't like concurent
TS := $(shell /bin/date "+%Y-%m-%d-%H-%M-%S")
$(eval TAG=$(shell git log -1 --pretty=%h))
VARIABLES = '$$SOFTCONSOLE_INTRANET_BASE_URL'

.PHONY: clean all $(SUBDIRS) login-email login status list


all: list $(SUBDIRS)


list:
	@echo "*************************************************************************"
	@echo "All present subdirectories ${SUBDIRS}"
	@echo "SoftConsole capture is set SC_CAPTURE=${SC_CAPTURE}"
	@echo "*************************************************************************"


all-without-softconsole-final: softconsole-base-images libero weak build-containers


softconsole-base-images: softconsole-base/. softconsole-base-slim/.


softconsole-final: softconsole-sch/. softconsole-sch-slim/.


libero: libero11-8/.


weak: weak-ubuntu16/.


build-containers: debian9.4-cmake-mingw/.


status:
	@echo ""
	@echo "*************************************************************************"
	@echo "Listing current present images by date of creation"
	@echo "*************************************************************************"
	@docker images
	@echo ""
	@echo "*************************************************************************"
	@echo "Listing current present images by alphabet"
	@echo "*************************************************************************"
	@docker images | sort


clean:
	@echo "Clean up existing containers and images"
	docker ps -a -q -f status=exited | xargs --no-run-if-empty docker rm -v
	docker images -q -f dangling=true | xargs --no-run-if-empty docker rmi


$(SUBDIRS):
	$(eval IMAGE=$(@:/.=))
	@echo ""
	@echo "*************************************************************************"
	@echo "${IMAGE}"
	@echo "*************************************************************************"

	@echo "Building: ${DOCKER_USER}/${IMAGE}:${TAG}"
	$(eval BASE_IMAGE=`cat ./${IMAGE}/Dockerfile | grep FROM | cut -d' '  -f2`)
	@echo Make sure we are using the newest base image: ${BASE_IMAGE}
	@docker pull ${BASE_IMAGE}

	@if [ "${IMAGE}" = "softconsole-sch" ] || [ "${IMAGE}" = "softconsole-sch-slim" ];  then \
		echo "SoftConsole final container tagging is slightly different compared to other containers"; \
		echo "CAPTURE-GITHASH-TIMESTAMP -> CAPTURE -> latest"; \
		time cat ./${IMAGE}/Dockerfile | envsubst ${VARIABLES} | docker build -t ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${TS} -;\
		docker tag -f ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${TS} ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}; \
		docker tag -f ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${TS} ${DOCKER_USER}/${IMAGE}:latest; \
		echo "Docker push CAPTURE-GITHASH-TS tag"; \
		docker push ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${TS}; \
		echo "Docker push CAPTURE tag"; \
		docker push ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}; \
	else \
		echo "Tagging current hash container as the latest:"; \
		echo "GITHASH -> latest"; \
		time cat ./${IMAGE}/Dockerfile | envsubst ${VARIABLES} | docker build -t ${DOCKER_USER}/${IMAGE}:${TAG} -;\
		docker tag -f ${DOCKER_USER}/${IMAGE}:${TAG} ${DOCKER_USER}/${IMAGE}:latest; \
		echo "Docker push GITHASH tag"; \
		docker push ${DOCKER_USER}/${IMAGE}:${TAG}; \
	fi

	@echo "Push latest tag"
	@docker push ${DOCKER_USER}/${IMAGE}:latest


login-email:
	@echo "Login into the docker account with email"
	@docker login -u ${DOCKER_USER} -e ${DOCKER_EMAIL} -p ${DOCKER_PASS}


login:
	@echo "Login into the docker account without email"
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
