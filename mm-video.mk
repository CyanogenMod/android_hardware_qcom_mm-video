all:
	@echo "invoking vidc/vdec make"
	$(MAKE) -f $(SRCDIR)/vidc/vdec/vdec.mk
	mv $(SYSROOTLIB_DIR)/mm-vdec-omx-test $(SYSROOTBIN_DIR)
	mv $(SYSROOTLIB_DIR)/mm-video-driver-test $(SYSROOTBIN_DIR)
	@echo "invoking vidc/enc make"
	$(MAKE) -f $(SRCDIR)/vidc/venc/venc.mk
	mv $(SYSROOTLIB_DIR)/mm-venc-omx-test720p $(SYSROOTBIN_DIR)
	mv $(SYSROOTLIB_DIR)/mm-video-encdrv-test $(SYSROOTBIN_DIR)
