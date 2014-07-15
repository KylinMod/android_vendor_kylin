PRODUCT_BRAND ?= kylinmod

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/kylin/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/kylin/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/kylin/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/kylin/CHANGELOG.mkdn:system/etc/CHANGELOG-KM.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/kylin/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/kylin/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/kylin/prebuilt/common/bin/50-km.sh:system/addon.d/50-km.sh \
    vendor/kylin/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/km/prebuilt/common/bin/otasigcheck.sh:system/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/kylin/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/kylin/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/kylin/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# kM-specific init file
PRODUCT_COPY_FILES += \
    vendor/kylin/prebuilt/common/etc/init.local.rc:root/init.km.rc

# KylinMod prebuilts
PRODUCT_COPY_FILES += \
    vendor/kylin/prebuilt/common/app/Market.apk:system/app/Market.apk \
    vendor/kylin/prebuilt/common/app/iFlyIME.apk:system/app/iFlyIME.apk \
    vendor/kylin/prebuilt/common/app/Stats.apk:system/app/Stats.apk \
    vendor/kylin/prebuilt/common/lib/libmsc-v7.so:system/lib/libmsc-v7.so \
    vendor/kylin/prebuilt/common/lib/libsmartaiwrite-jni-v7.so:system/lib/libsmartaiwrite-jni-v7.so \
    vendor/kylin/prebuilt/common/lib/libsmartaiwrite-jni-v8.so:system/lib/libsmartaiwrite-jni-v8.so \
    vendor/kylin/prebuilt/common/lib/libsmartaiwrite-jni-v9.so:system/lib/libsmartaiwrite-jni-v9.so \
    vendor/kylin/prebuilt/common/lib/libvadLib-v5.so:system/lib/libvadLib-v5.so

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/kylin/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/kylin/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is KM!
PRODUCT_COPY_FILES += \
    vendor/kylin/config/permissions/com.kylinmod.android.xml:system/etc/permissions/com.kylinmod.android.xml \
    vendor/kylin/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# T-Mobile theme engine
include vendor/kylin/config/themes_common.mk

# Required KM packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt

# Optional KM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji

# KylinMod PhoneLoc Database
PRODUCT_COPY_FILES +=  \
    vendor/kylin/prebuilt/common/media/kylin-phoneloc.dat:system/media/kylin-phoneloc.dat

# Custom KM packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    DSPManager \
    libcyanogen-dsp \
    libscreenrecorder \
    audio_effects.conf \
    Apollo \
    CMFileManager \
    CMHome \
    LockClock \
    KylinModScreenRecorder \
    KylinModSetupWizard

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in KM
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)

PRODUCT_PACKAGES += \
    procmem \
    procrank \
    Superuser \
    su

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=1
else

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

endif

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/kylin/overlay/common

PRODUCT_VERSION_MAJOR = KK4
PRODUCT_VERSION_MINOR = 44
PRODUCT_VERSION_MAINTENANCE = 0

# Set KM_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef KM_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "KM_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^KM_||g')
        KM_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY WEEKLY SNAPSHOT EXPERIMENTAL,$(KM_BUILDTYPE)),)
    KM_BUILDTYPE :=
endif

ifdef KM_BUILDTYPE
    ifneq ($(KM_BUILDTYPE), SNAPSHOT)
        ifdef KM_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            KM_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from KM_EXTRAVERSION
            KM_EXTRAVERSION := $(shell echo $(KM_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to KM_EXTRAVERSION
            KM_EXTRAVERSION := -$(KM_EXTRAVERSION)
        endif
    else
        ifndef KM_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            KM_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from KM_EXTRAVERSION
            KM_EXTRAVERSION := $(shell echo $(KM_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to KM_EXTRAVERSION
            KM_EXTRAVERSION := -$(KM_EXTRAVERSION)
        endif
    endif
else
    # If KM_BUILDTYPE is not defined, set to UNOFFICIAL
    KM_BUILDTYPE := UNOFFICIAL
    KM_EXTRAVERSION :=
endif

ifeq ($(KM_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        KM_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(KM_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        KM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(KM_BUILD)-RELEASE
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            KM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(KM_BUILD)
        else
            KM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(KM_BUILD)
        endif
    endif
else
    ifeq ($(PRODUCT_VERSION_MINOR),0)
        KM_VERSION := $(PRODUCT_VERSION_MAJOR)-$(shell date -u +%Y%m%d)-$(KM_BUILDTYPE)$(KM_EXTRAVERSION)-$(KM_BUILD)
    else
        KM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(KM_BUILDTYPE)$(KM_EXTRAVERSION)-$(KM_BUILD)
    endif
endif

ifeq ($(PRODUCT_VERSION_MAINTENANCE),0)
    KMSTATS_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)
else
    KMSTATS_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)$(PRODUCT_VERSION_MAINTENANCE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.km.version=$(KM_VERSION) \
  ro.modversion=$(KM_VERSION) \
  ro.km.ui.name=KylinMod \
  ro.km.ui.version=$(KMSTATS_VERSION) \
  ro.km.version=$(KM_VERSION) \
  ro.km.releasetype=$(KM_BUILDTYPE) \
  ro.modversion=$(KM_VERSION) \
  ro.cmlegal.url=http://www.cyanogenmod.org/docs/privacy

-include vendor/cm-priv/keys/keys.mk

KM_DISPLAY_VERSION := $(KM_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
  ifneq ($(KM_BUILDTYPE), UNOFFICIAL)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
      ifneq ($(KM_EXTRAVERSION),)
        # Remove leading dash from KM_EXTRAVERSION
        KM_EXTRAVERSION := $(shell echo $(KM_EXTRAVERSION) | sed 's/-//')
        TARGET_VENDOR_RELEASE_BUILD_ID := $(KM_EXTRAVERSION)
      else
        TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
      endif
    else
      TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    endif
    KM_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

PRODUCT_PROPERTY_OVERRIDES += \
  ro.km.display.version=$(KM_DISPLAY_VERSION)

# disable multithreaded dextop for RELEASE and SNAPSHOT builds
ifneq ($(filter RELEASE SNAPSHOT,$(CM_BUILDTYPE)),)
PRODUCT_PROPERTY_OVERRIDES += \
  persist.sys.dalvik.multithread=false
endif

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk
