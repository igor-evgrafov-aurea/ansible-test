FROM ubuntu:16.04

# install ssh server
RUN apt-get update && apt-get install -y openssh-server

# change password to random value
RUN echo 'root:root' | chpasswd

# Add public key
RUN mkdir -p /root/.ssh
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Below public key could come from build-args or
# can be Added from SCM repository (could pass as env variables in EY)
# REPLACE THE BELOW KEY WITH YOUR ACTUAL PUBLIC KEY
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAvUrHW7W8+yjOX5ZSAM/Tun0qRnQGsppl4ustwIIE4suUawoXnKWv2uGmJyJjc+dVI \
AWbJ32lcQLNwKkDkuLSFpxPFvYF7YJuvVdTJ2wXMgEL89OcS4WLmXEDroWJnBlX1QgiWC1n5x17pV7SrSMfzbQdZsO3j+DLnaj8aypu3jyXOmJE \
xe7qn53xGX/KWYRtbuMW9feXUTTrIFGZHFbhYDTpzRVRVKvu7Vpwq/ang6YNP3OpUsjdq83S0pTCTAIpGkHtqvtpzLvkKDFv4t4mUiLCbkvohUg \
+bg8VReqBbIhQV5I5k6LJEY83grrkmkkxPe1iCpU2Zry95g77ti4c/Q== ievgrafov" >> /root/.ssh/authorized_keys

# Docker Env variables do not show up in ssh
# example env variables which will or will not show up
ENV NOTVISIBLE "This variable is not visible in ssh"
RUN echo "export VISIBLE_VARIABLE=CAN_SEE_THIS_IN_SSH" >> /etc/profile

RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

# starting ssh daemon (sshd) needs to go in startup script or may also go before your startup command, like this:
CMD /usr/sbin/sshd -D && tail -F /dev/null

# Mark port 22 as exposed for ssh
EXPOSE 22
