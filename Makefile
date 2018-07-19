SC_CAPTURE ?= 5.4
SUBDIRS   := $(wildcard */.)
MAKEFLAGS := --jobs=1  # force sequential execution as docker doesn't like concurent
TS := $(shell /bin/date "+%Y-%m-%d-%H-%M-%S")
$(eval TAG=$(shell git log -1 --pretty=%h))
VARIABLES = '$$SOFTCONSOLE_INTRANET_BASE_URL $$SC_BASE_IMAGE'

.PHONY: clean all $(SUBDIRS) login-email login status list


all: list $(SUBDIRS)


list:
	@echo "*************************************************************************"
	@echo "All present subdirectories ${SUBDIRS}"
	@echo "SoftConsole capture is set SC_CAPTURE=${SC_CAPTURE}"
	@echo "*************************************************************************"


all-without-softconsole-final: softconsole-base-images libero weak build-containers


softconsole-base-images: softconsole-base/. softconsole-base-slim/.


softconsole-final: softconsole-sch/.


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

	@if [ "${IMAGE}" = "softconsole-sch" ];  then \
		echo Make sure we are using the newest base image: ${BASE_IMAGE}; \
		docker pull antonkrug/softconsole-base;\
		docker pull antonkrug/softconsole-base-slim;\
		echo "SoftConsole final container generation is different because 1 Dockerfile will generate 2 variants of a container (full and slim variants).";\
		echo "Tagging is slightly different compared to other containers as well, 1 images creates 3 tags"; \
		echo "CAPTURE-GITHASH-TIMESTAMP -> CAPTURE -> latest"; \
		echo "Example of envsubst resolved Dockerfile:"; \
		cat ./${IMAGE}/Dockerfile | SC_BASE_IMAGE=antonkrug/softconsole-base envsubst ${VARIABLES};\
		exit; \
		time cat ./${IMAGE}/Dockerfile | SC_BASE_IMAGE=antonkrug/softconsole-base envsubst ${VARIABLES} | docker build -t ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${TS} -;\
		time cat ./${IMAGE}/Dockerfile | SC_BASE_IMAGE=antonkrug/softconsole-base-slim envsubst ${VARIABLES} | docker build -t ${DOCKER_USER}/${IMAGE}-slim:${SC_CAPTURE}-${TAG}-${TS} -;\
		docker tag -f ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${TS} ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}; \
		docker tag -f ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${TS} ${DOCKER_USER}/${IMAGE}:latest; \
		docker tag -f ${DOCKER_USER}/${IMAGE}-slim:${SC_CAPTURE}-${TAG}-${TS} ${DOCKER_USER}/${IMAGE}-slim:${SC_CAPTURE}; \
		docker tag -f ${DOCKER_USER}/${IMAGE}-slim:${SC_CAPTURE}-${TAG}-${TS} ${DOCKER_USER}/${IMAGE}-slim:latest; \
		echo "Docker push CAPTURE-GITHASH-TS tag"; \
		docker push ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${TS}; \
		docker push ${DOCKER_USER}/${IMAGE}-slim:${SC_CAPTURE}-${TAG}-${TS}; \
		echo "Docker push CAPTURE tag"; \
		docker push ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}; \
		docker push ${DOCKER_USER}/${IMAGE}-slim:${SC_CAPTURE}; \
		echo "Docker push latest tag"; \
		docker push ${DOCKER_USER}/${IMAGE}:latest;\
		docker push ${DOCKER_USER}/${IMAGE}-slim:latest;\
	else \
		echo Make sure we are using the newest base image: ${BASE_IMAGE}; \
		docker pull ${BASE_IMAGE};\
		echo "Tagging current hash container as the latest:"; \
		echo "GITHASH -> latest"; \
		time cat ./${IMAGE}/Dockerfile | docker build -t ${DOCKER_USER}/${IMAGE}:${TAG} -;\
		docker tag -f ${DOCKER_USER}/${IMAGE}:${TAG} ${DOCKER_USER}/${IMAGE}:latest; \
		echo "Docker push GITHASH tag"; \
		docker push ${DOCKER_USER}/${IMAGE}:${TAG}; \
		echo "Docker push latest tag"; \
		docker push ${DOCKER_USER}/${IMAGE}:latest;\
	fi

login-email:
	@echo "Login into the docker account with email"
	@docker login -u ${DOCKER_USER} -e ${DOCKER_EMAIL} -p ${DOCKER_PASS}


login:
	@echo "Login into the docker account without email"
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
