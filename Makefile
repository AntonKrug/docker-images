SUBDIRS   := $(wildcard */.)
MAKEFLAGS := --jobs=1  # force sequential execution as docker doesn't like concurent
$(eval TAG=$(shell git log -1 --pretty=%h))
VARIABLES = '$$SOFTCONSOLE_INTRANET_BASE_URL'

.PHONY: clean all $(SUBDIRS) login-email login status list


all: list $(SUBDIRS)


list:
	@echo "*************************************************************************"
	@echo "All present subdirectories ${SUBDIRS}"
	@echo "*************************************************************************"


all-without-softconsole-final: softconsole-base-images libero weak build-containers


softconsole-base-images: softconsole-base/. softconsole-base-slim/.


softconsole-final: softconsole-5-3/. softconsole-5-3-slim/.


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
	@echo ""
	@echo "*************************************************************************"
	$(eval IMAGE=$(@:/.=))
	@echo "${IMAGE}"
	@echo "*************************************************************************"
	@echo "Building: ${DOCKER_USER}/${IMAGE}:${TAG}"
	$(eval BASE_IMAGE=`cat ./${IMAGE}/Dockerfile | grep FROM | cut -d' '  -f2`)
	@echo Make sure we are using the newest base image: ${BASE_IMAGE}
	@docker pull ${BASE_IMAGE}
	time cat ./${IMAGE}/Dockerfile | envsubst ${VARIABLES} | docker build -t ${DOCKER_USER}/${IMAGE}:${TAG} -
	@echo "Tagging current hash as the latest:"
	docker tag -f ${DOCKER_USER}/${IMAGE}:${TAG} ${DOCKER_USER}/${IMAGE}:latest
	@docker push ${DOCKER_USER}/${IMAGE}


login-email:
	@echo "Login into the docker account with email"
	@docker login -u ${DOCKER_USER} -e ${DOCKER_EMAIL} -p ${DOCKER_PASS}


login:
	@echo "Login into the docker account without email"
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
