# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY setup.sh /

FROM ghcr.io/ublue-os/arch-toolbox:latest AS arch-toolbox

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience powered by Arch Linux"

RUN --mount=type=bind,from=ctx,source=/,target=/ctx /ctx/setup.sh
