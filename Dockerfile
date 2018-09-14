FROM ibmjava:latest
COPY rpt/ /rpt
RUN ./rpt/InstallerImage_linux_gtk_x86_64/installc -acceptLicense &&\
    cd /opt/IBM/InstallationManager/eclipse &&\
    ./IBMIM --launcher.ini silent-install.ini -input /rpt/MyResponse.xml -log /tmp/silent.log -acceptLicense &&\
    rm -rf /rpt/
COPY majordomo.config /opt/IBM/SDP/Majordomo/

FROM ibmjava:latest
LABEL maintainer="F8749577 - Romulo Cesar Gomes Graciano"
COPY --from=0 /opt/IBM/ /opt/IBM/
ENV user rpt_user
RUN useradd -m -d /home/${user} ${user} \
    && chown -R ${user} /home/${user}
USER ${user}
WORKDIR /home/${user}
CMD /opt/IBM/SDP/Majordomo/MDStart.sh && \
    tail -f /dev/null
EXPOSE 7080