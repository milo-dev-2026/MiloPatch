TARGET := iphone:clang:16.5:14.0
ARCHS := arm64
INSTALL_TARGET_PROCESSES = FayChat

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MiloPatch
MiloPatch_FILES = Tweak.xm
MiloPatch_CFLAGS = -fobjc-arc -Wno-unused-function

include $(THEOS_MAKE_PATH)/tweak.mk
