FROM archlinux/archlinux

RUN pacman -Syu
RUN useradd -m tempuser && \
    echo 'tempuser:12345678' | chpasswd && \
    mkdir -p /etc/sudoers.d && \
    echo "tempuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel && \
    chmod 750 /etc/sudoers.d

RUN pacman -S sudo --noconfirm

USER tempuser
WORKDIR /home/tempuser/scripts/

RUN mkdir -p /home/tempuser/scripts
COPY . /home/tempuser/scripts/
RUN sudo chmod -R 777 /home/tempuser/scripts/
RUN sudo chmod +x /home/tempuser/scripts/run.sh
RUN sudo chmod 777 /home/tempuser/scripts/run.sh

CMD ["su", "tempuser", "-c", "/home/tempuser/scripts/run.sh"]