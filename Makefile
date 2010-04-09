all:
	@echo "invoking opensource mm-video make"
	$(MAKE) -C 8k/vdec
	$(MAKE) -C 8k/venc

install:
	$(MAKE) -C 8k/vdec install
	$(MAKE) -C 8k/venc install
