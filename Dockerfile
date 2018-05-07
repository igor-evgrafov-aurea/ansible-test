FROM ubuntu:16.04

# install ssh server
RUN apt-get update && apt-get install -y openssh-server python-minimal python-simplejson

# Add public key
RUN mkdir -p /root/.ssh
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAvUrHW7W8+yjOX5ZSAM/Tun0qRnQGsppl4ustwIIE4suUawoXnKWv2uGmJyJjc+dVI\
AWbJ32lcQLNwKkDkuLSFpxPFvYF7YJuvVdTJ2wXMgEL89OcS4WLmXEDroWJnBlX1QgiWC1n5x17pV7SrSMfzbQdZsO3j+DLnaj8aypu3jyXOmJE\
xe7qn53xGX/KWYRtbuMW9feXUTTrIFGZHFbhYDTpzRVRVKvu7Vpwq/ang6YNP3OpUsjdq83S0pTCTAIpGkHtqvtpzLvkKDFv4t4mUiLCbkvohUg\
+bg8VReqBbIhQV5I5k6LJEY83grrkmkkxPe1iCpU2Zry95g77ti4c/Q== ievgrafov" >> /root/.ssh/authorized_keys

RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

CMD exec /usr/sbin/sshd -D -e "$@"

# Mark port 22 as exposed for ssh
EXPOSE 22
