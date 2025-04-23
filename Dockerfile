FROM container-registry.oracle.com/database/free:latest

COPY --chmod=777 start.sh /home/oracle/start.sh
RUN chmod +x /home/oracle/setPassword.sh




COPY scripts/ /opt/oracle/scripts/

# Copy startup script
#COPY start.sh /opt/oracle/start.sh
#COPY updb.sh /opt/oracle/updb.sh
#RUN chmod +x /opt/oracle/start.sh
COPY --chmod=777 updb.sh /opt/oracle/updb.sh
COPY --chmod=777 installapex.sh /opt/oracle/installapex.sh
COPY --chmod=777 install_jave.sh /opt/oracle/install_jave.sh
COPY --chmod=777 install_ords.sh /opt/oracle/install_ords.sh
COPY --chmod=777 install_tomcat.sh /opt/oracle/install_tomcat.sh
COPY --chmod=777 opass.txt /opt/oracle/opass.txt
COPY --chmod=777 apex_pass_input.txt /opt/oracle/apex_pass_input.txt
RUN mkdir /opt/oracle/extention/

COPY --chmod=777 apex.zip /opt/oracle/extention/apex.zip
#COPY --chmod=777 bip.zip /opt/oracle/extention/bip.zip
COPY --chmod=777 jdk-21.tar.gz /opt/oracle/extention/jdk-21.tar.gz
COPY --chmod=777 ords.zip /opt/oracle/extention/ords.zip
COPY --chmod=777 tomcat.tar.gz /opt/oracle/extention/tomcat.tar.gz

USER root

RUN chmod +x /home/oracle/start.sh
RUN chmod +x /opt/oracle/updb.sh
RUN chmod +x /opt/oracle/installapex.sh
RUN chmod +x /opt/oracle/install_jave.sh
RUN chmod +x /opt/oracle/install_ords.sh
RUN chmod +x /opt/oracle/install_tomcat.sh
USER oracle
# Optional: Install dos2unix to avoid Windows line ending issues
#RUN microdnf install -y dos2unix && dos2unix /opt/oracle/start.s


# Set environment variable for password
ENV ORACLE_PASSWORD=Oracle123



EXPOSE 1521 80 8080
CMD ["sh", "/home/oracle/start.sh"]

