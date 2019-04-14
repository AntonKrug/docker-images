SC_CAPTURE ?= 6.0 # feed from the Jenkins job, update the values in the job itself
SHELL = bash
SUBDIRS   := $(wildcard */.)
MAKEFLAGS := --jobs=1  # force sequential execution as docker doesn't like concurent
TS := $(shell /bin/date "+%Y-%m-%d-%H-%M-%S")
$(eval TAG=$(shell git log -1 --pretty=%h))
VARIABLES = '$$SOFTCONSOLE_INTRANET_BASE_URL $$SC_BASE_IMAGE'

.PHONY: clean all $(SUBDIRS) login-email login status list

# ----- Default target -----
all: list $(SUBDIRS)


# ----- Aliases/groups of targets ------
all-without-softconsole-final: softconsole-base-images libero weak build-containers


softconsole-base-images: softconsole-base/. softconsole-base-slim/.


softconsole-final: softconsoleheadless/.


libero: libero11-8/.


weak: weak-ubuntu16/.


build-containers: renode-builder/. verilator-lcov-slim/. verilator-slim/. verilator/. debian9.4-cmake-mingw/. code-styling/. documentation-builders/.

# build-containers which I temporary disabled ykush-controller-slim/. ykush-controller/.


list:
	# Helper to display conditions at which this make file is run
	@echo "*************************************************************************"
	@echo "All present subdirectories ${SUBDIRS}"
	@echo "SoftConsole capture is set SC_CAPTURE=${SC_CAPTURE}"
	@echo "Parent SoftConsole capture hash SC_COMMIT_HASH=${SC_COMMIT_HASH}"
	@echo "*************************************************************************"


status:
	# Will display existing images so it should show the freshly generated ones
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
	# Try to remove previous containers so they will not keep piling up
	@echo "Clean up existing containers and images"
	#docker ps -a -q -f status=exited | xargs --no-run-if-empty docker rm -v
	#docker images -q -f dangling=true | xargs --no-run-if-empty docker rmi


$(SUBDIRS):
	# Will generate containers for all the generic containers, it's using hash of the git commit as tag version
	# It will alias this tag with latest tag so the latest always points to the bleeding edge
	$(eval IMAGE=$(@:/.=))
	@echo
	@echo "*************************************************************************"
	@echo "${IMAGE}"
	@echo "*************************************************************************"

	@echo "Building: ${DOCKER_USER}/${IMAGE}:${TAG}"
	$(eval BASE_IMAGE=`cat ./${IMAGE}/Dockerfile | grep FROM | cut -d' '  -f2`)

	@echo
	@echo Make sure we are using the newest base image: ${BASE_IMAGE}
	docker pull ${BASE_IMAGE}

	@echo
	@echo "Tagging current hash container as the latest:"
	@echo "GITHASH -> latest"
	time cat ./${IMAGE}/Dockerfile | docker build -t ${DOCKER_USER}/${IMAGE}:${TAG} -

	@echo
	docker tag -f ${DOCKER_USER}/${IMAGE}:${TAG} ${DOCKER_USER}/${IMAGE}:latest

	@echo
	@echo "Docker push GITHASH tag"
	docker push ${DOCKER_USER}/${IMAGE}:${TAG}

	@echo
	@echo "Docker push latest tag"
	docker push ${DOCKER_USER}/${IMAGE}:latest


softconsoleheadless/.:
	# In contrast to regular target this will generate 2 containers instead of 1.
	#
	# Both are for the SCH, one regular and one slim. It uses single file as a template
	# and 2 different Dockerfiles are produced. More modern ways of using ARG are avoided
	# because this needs to work on larger range of docker versions.
    #
	# For tagging it's using hash of the git commit and it iherits the hash from parent 
	# (softconsole-baker branch:docker), then it combines both hashes
	# with prefixed SC_CAPTURE variable and postfixed date.
	#
	# SC_CAPTURE - DOCKER_BUILDER_COMMIT_HASH - SOFTCONSOLE_BAKER_COMMIT_HASH - TIMESTAMP
	# 
	# So they will be still sorted by major released while allowing to see what baker commit 
	# and what docker builder commit are mapping to what tag. And even if nothing changed
	# and it was re-run manually, then the timestamp will distinguish both runs
	# 
	# On top of linking the long-winded tag to latest tag, it is linking it to the shorter
	# SC_CAPTURE
	# Which means after new major version is introduced, it will make the previous version
	# a static point, which should be stable and human friendly tag to use.

	$(eval IMAGE=$(@:/.=))
	@echo
	@echo "*************************************************************************"
	@echo "${IMAGE}"
	@echo "*************************************************************************"

	@echo "Building: ${DOCKER_USER}/${IMAGE}:${TAG}-${SC_COMMIT_HASH}"
	$(eval BASE_IMAGE=`cat ./${IMAGE}/Dockerfile | grep FROM | cut -d' '  -f2`)

	@echo
	@echo "Make sure we are using the newest base image: ${BASE_IMAGE}"
	docker pull antonkrug/softconsole-base
	docker pull antonkrug/softconsole-base-slim

	@echo
	@echo "SoftConsole final container generation is different because 1 Dockerfile will generate 2 variants of a container (full and slim variants)."
	@echo "Tagging is slightly different compared to other containers as well, 1 images creates 3 tags"
	@echo "CAPTURE-GITHASH-TIMESTAMP -> CAPTURE -> latest"

	@echo
	cat ./${IMAGE}/Dockerfile | SC_BASE_IMAGE=antonkrug/softconsole-base envsubst ${VARIABLES} > ./${IMAGE}/Dockerfile.full
	cat ./${IMAGE}/Dockerfile | SC_BASE_IMAGE=antonkrug/softconsole-base-slim envsubst ${VARIABLES} > ./${IMAGE}/Dockerfile.slim
	@echo "Input Dockerfiles:"
	@cat ./${IMAGE}/Dockerfile.*
	
	@echo
	@echo Extracting SC archive
	#rm -rf ./${IMAGE}/scLinux*  # should remove all directories, but keep the zip
	ls -la ./${IMAGE}/ 
	unzip ./${IMAGE}/scLinux*.zip -d ./${IMAGE}/
	chmod -R a+rw ./${IMAGE}/scLinux*/*

	@echo
	@echo Fixing time atributes to specific timestap as Docket 1.7 still is using the time to invalidate caches and will not allow reuse caches
	find ./${IMAGE}/scLinux*/ | xargs touch -t 201812261704.00

	@echo
	@echo Making slim container
	time docker build -t ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${SC_COMMIT_HASH}-${TS}-slim -f ./${IMAGE}/Dockerfile.slim ./${IMAGE}

	@echo
	@echo Making full container
	time docker build -t ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${SC_COMMIT_HASH}-${TS} -f ./${IMAGE}/Dockerfile.full ./${IMAGE}
	
	@echo
	@echo Tagging slim and full containers to a capture and to the "latest" tags
	docker tag -f ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${SC_COMMIT_HASH}-${TS}-slim ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-slim
	docker tag -f ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${SC_COMMIT_HASH}-${TS}-slim ${DOCKER_USER}/${IMAGE}:latest-slim
	docker tag -f ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${SC_COMMIT_HASH}-${TS} ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}
	docker tag -f ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${SC_COMMIT_HASH}-${TS} ${DOCKER_USER}/${IMAGE}:latest
	
	@echo
	@echo "Docker push CAPTURE-GITHASH-TS tag"
	docker push ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${SC_COMMIT_HASH}-${TS}-slim
	docker push ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-${TAG}-${SC_COMMIT_HASH}-${TS}
	
	@echo
	@echo "Docker push CAPTURE tag"
	docker push ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}-slim
	docker push ${DOCKER_USER}/${IMAGE}:${SC_CAPTURE}
	
	@echo
	@echo "Docker push latest tag"
	docker push ${DOCKER_USER}/${IMAGE}:latest-slim
	docker push ${DOCKER_USER}/${IMAGE}:latest


login-email:
	# Login into docker the old way
	@echo "Login into the docker account with email"
	@docker login -u ${DOCKER_USER} -e ${DOCKER_EMAIL} -p ${DOCKER_PASS}


login:
	# Login into docker the current way
	@echo "Login into the docker account without email"
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
