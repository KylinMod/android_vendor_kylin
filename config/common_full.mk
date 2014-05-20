# Inherit common KM stuff
$(call inherit-product, vendor/kylin/config/common.mk)

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Include KM audio files
include vendor/kylin/config/km_audio.mk

# Include KM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/kylin/overlay/dictionaries

# Optional KM packages
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    VisualizationWallpapers \
    PhotoTable \
    SoundRecorder

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# Extra tools in KM
PRODUCT_PACKAGES += \
    vim
