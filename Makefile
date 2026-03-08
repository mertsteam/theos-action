include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AsuraBypass
AsuraBypass_FILES = Tweak.xm
AsuraBypass_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
