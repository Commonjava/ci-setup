FROM jenkins
#COPY plugins.txt /usr/share/jenkins/ref/plugins/
#COPY custom.groovy /usr/share/jenkins/ref/init.groovy.d/custom.groovy
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

USER root
RUN apt-get upgrade
RUN apt-get install openjdk-8-jdk
ADD timezone /etc/timezone
ADD docker.profile /etc/profile.d/docker.sh
RUN ln -s /etc/alternatives/java /bin/java
#RUN /usr/local/bin/install-plugins.sh bouncycastle-api \
#									  credentials \
#									  git \
#									  git-client \
#									  github \
#									  github-api \
#									  github-oauth \
#									  ghprb \
#									  mailer \
#									  matrix-project \
#									  plain-credentials \
#									  scm-api \
#									  ssh-agent \
#									  ssh-credentials \
#									  token-macro \
#									  workflow-step-api

RUN /usr/local/bin/install-plugins.sh github \
 									  github-oauth \
 									  ghprb

USER jenkins

ENTRYPOINT ["/bin/tini", "--", "/bin/bash", "-l", "/usr/local/bin/jenkins.sh"]
