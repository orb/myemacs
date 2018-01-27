FROM silex/emacs:25
ARG EMACS_FILE=init.el
COPY $EMACS_FILE /root/.emacs.d/init.el
RUN emacs --batch -l /root/.emacs.d/init.el
