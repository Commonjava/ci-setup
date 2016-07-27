#CI with Docker Notes

* Used `docker network create -d bridge ci-network` to create a custom network within which CI services could interact freely
  * Without this, jenkins could create docker containers but never access them...
* Added [Indy](https://commonjava.github.io/indy/user) and Jenkins to ci-network
  * Using `docker run --net=ci-network [...]` 
  * Updated Jenkins `settings.xml` to point to host 'indy' on the container-native port of 8080 (port is not mapped via docker)
* Added server for `registry.hub.docker.io` and matching `serverId` to docker-maven-plugin configuration
  * Server password was encrypted
* Changed Docker `/etc/sysconfig/docker` options to use `-H tcp://0.0.0.0:2375` (to enable TCP port control)
  * TIP: You can leave `-H unix:///var/run/docker.sock` in there too to enable both access methods, and avoid the need to do a lot of reconfiguration for the host cli
* Added docker.sh to profile.d to initialize DOCKER_HOST using `"tcp://$(ip route show | grep default | awk '{print $3}'):2375"`
* Added OpenJDK 1.8.0 installler using shell: `sudo apt-get -y install openjdk-8-jdk` with tool path: `/usr/lib/jvm/java-8-openjdk-amd64`
  * This was to support java builds requiring large encryption key sizes, which isn't enabled normally with Oracle Java
* Added symlink from /etc/alternatives/java to /bin/java to support apt-get installed JDKs
  * This was for the builds requiring large encryption keys
* [PR #117](https://github.com/wouterd/docker-maven-plugin/pull/117) on net.wouterdanes.docker-docker-maven-plugin
* Adjusted project pom.xml configurations for docker-maven-plugin, as in: [https://github.com/Commonjava/jhttpc/blob/ae684d84199fbf0f92071b3e174a2d9145873e7a/pom.xml](https://github.com/Commonjava/jhttpc/blob/ae684d84199fbf0f92071b3e174a2d9145873e7a/pom.xml)
* Set timezone of Jenkins container appropriately using `/etc/timezone` and mapped volume: `-v /etc/localtime:/etc/localtime:ro`

