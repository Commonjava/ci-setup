FROM jenkins
COPY plugins.txt /usr/share/jenkins/ref/
#COPY custom.groovy /usr/share/jenkins/ref/init.groovy.d/custom.groovy
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

USER root
ADD timezone /etc/timezone
ADD docker.profile /etc/profile.d/docker.sh
RUN ln -s /etc/alternatives/java /bin/java
USER jenkins

ENTRYPOINT ["/bin/tini", "--", "/bin/bash", "-l", "/usr/local/bin/jenkins.sh"]
