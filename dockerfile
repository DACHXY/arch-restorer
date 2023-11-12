FROM archlinux/archlinux

RUN pacman -Syu
RUN useradd -m danny && \
    echo 'danny:danny2024' | chpasswd && \
    mkdir -p /etc/sudoers.d && \
    echo "danny ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel && \
    chmod 750 /etc/sudoers.d

RUN pacman -S sudo --noconfirm

USER danny
WORKDIR /home/danny/scripts/

RUN mkdir -p /home/danny/scripts/
COPY . /home/danny/scripts/
RUN sudo chmod +x /home/danny/scripts/run.sh
RUN sudo chmod 777 /home/danny/scripts/run.sh

CMD ["su", "danny", "-c", "/home/danny/scripts/run.sh"]