FROM archlinux/archlinux

RUN pacman -Syu
RUN useradd -m danny && \
    echo 'danny:danny2024' | chpasswd && \
    mkdir -p /etc/sudoers.d && \
    echo "danny ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel && \
    chmod 750 /etc/sudoers.d

RUN pacman -S sudo --noconfirm

COPY run.sh /run.sh

RUN chmod +x /run.sh
RUN chmod 777 /run.sh

USER danny
WORKDIR /home/danny
CMD ["su", "danny", "-c", "/run.sh"]