TARGET := iphone:clang:latest:14.0
ARCHS := arm64
INSTALL_TARGET_PROCESSES = FayChat

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MiloPatch
MiloPatch_FILES = Tweak.xm
MiloPatch_CFLAGS = -fobjc-arc -Wno-unused-function

include $(THEOS_MAKE_PATH)/tweak.mk
