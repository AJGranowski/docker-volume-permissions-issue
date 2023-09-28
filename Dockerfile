FROM busybox:uclibc

ARG USER_ID
ARG USER_NAME
ARG MKDIR_PATHS
ARG CHOWN_PATHS

# Create $USER_NAME
RUN if [ -n "${USER_NAME}" ] && [ "${USER_NAME}" != "root" ] && if [ -n "${USER_ID}" ]; then [ ${USER_ID} -ne 0 ]; fi; then \
        if getent passwd "${USER_NAME}"; then \
            deluser "${USER_NAME}" \
        ;fi && \
        if [ -n "${USER_ID}" ] && getent passwd "${USER_ID}"; then \
            deluser "$(getent passwd "${USER_ID}" | cut -d':' -f1)" \
        ;fi && \
        if [ -n "${USER_ID}" ]; then \
            adduser -u "${USER_ID}" -s /bin/sh -D "${USER_NAME}" \
        ;else \
            adduser -s /bin/sh -D "${USER_NAME}" \
        ;fi && \
        if [ -n "${MKDIR_PATHS}" ]; then \
            eval mkdir -p ${MKDIR_PATHS} \
        ;fi && \
        if [ -n "${CHOWN_PATHS}" ]; then \
            eval chown -Rc "${USER_NAME}" ${CHOWN_PATHS} \
        ;fi \
    ;fi

USER ${USER_NAME}
ENTRYPOINT ["sh", "-c"]
CMD ["echo && echo Container: && id && ls -ld volume"]