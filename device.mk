# Copyright (C) 2011 rockchip Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file includes all definitions that apply to ALL rk30sdk devices, and
# are also specific to rk30sdk devices
#
# Everything in this directory will become public

########################################################
# Kernel
########################################################
PRODUCT_COPY_FILES += \
    $(TARGET_PREBUILT_KERNEL):kernel

include frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk

###########################################################
## Find all of the apk files under the named directories.
## Meant to be used like:
##    SRC_FILES := $(call all-apk-files-under,src tests)
###########################################################
define all-apk-files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH)/$(1) ; \
          find ./ -maxdepth 1  -name "*.apk" -and -not -name ".*") \
 )
endef

#########################################################
#  copy proprietary apk
#########################################################
COPY_APK_TARGET := $(call all-apk-files-under,apk)
PRODUCT_COPY_FILES += $(foreach apkName, $(COPY_APK_TARGET), \
	$(addprefix $(LOCAL_PATH)/apk/, $(apkName)):$(addprefix system/app/, $(apkName)))

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/apk/flashplayer:system/app/flashplayer

########################################################
# Google applications
########################################################
ifeq ($(strip $(BUILD_WITH_GOOGLE_MARKET)),true)
gapps_files := $(shell ls $(LOCAL_PATH)/googleapps/app )
PRODUCT_COPY_FILES += $(foreach file, $(gapps_files), \
        $(LOCAL_PATH)/googleapps/app/$(file):system/app/$(file))

gapps_files := $(shell ls $(LOCAL_PATH)/googleapps/lib )
PRODUCT_COPY_FILES += $(foreach file, $(gapps_files), \
        $(LOCAL_PATH)/googleapps/lib/$(file):system/lib/$(file))

gapps_files := $(shell ls $(LOCAL_PATH)/googleapps/framework )
PRODUCT_COPY_FILES += $(foreach file, $(gapps_files), \
        $(LOCAL_PATH)/googleapps/framework/$(file):system/framework/$(file))

gapps_files := $(shell ls $(LOCAL_PATH)/googleapps/etc/permissions )
PRODUCT_COPY_FILES += $(foreach file, $(gapps_files), \
        $(LOCAL_PATH)/googleapps/etc/permissions/$(file):system/etc/permissions/$(file))

gapps_files := $(shell ls $(LOCAL_PATH)/googleapps/usr/srec/en-US )
PRODUCT_COPY_FILES += $(foreach file, $(gapps_files), \
        $(LOCAL_PATH)/googleapps/usr/srec/en-US/$(file):system/usr/srec/en-US/$(file))
endif

########################################################
# Face lock
########################################################
# copy all model files
define all-models-files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH)/$(1) ; \
          find ./ -type f -and -not -name "*.apk" -and -not -name "*.so") \
 )
endef

COPY_FILES := $(call all-models-files-under,facelock)
PRODUCT_COPY_FILES += $(foreach files, $(COPY_FILES), \
	$(addprefix $(LOCAL_PATH)/facelock/, $(files)):$(addprefix system/, $(files)))

ifeq ($(strip $(BUILD_WITH_FACELOCK)),true)
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/facelock/FaceLock.apk:system/app/FaceLock.apk
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/facelock/libfacelock_jni.so:system/lib/libfacelock_jni.so
endif
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.facelock = enable_facelock \
    persist.facelock.detect_cutoff=5000 \
    persist.facelock.recog_cutoff=5000

########################################################
#  RKUpdateService: RKUpdateService.apk
########################################################
rk_apps_files := $(shell ls $(LOCAL_PATH)/apk/RKUpdateService | grep .apk)
PRODUCT_COPY_FILES += $(foreach file, $(rk_apps_files), \
        $(LOCAL_PATH)/apk/RKUpdateService/$(file):system/app/$(file))

########################################################
#  RKUpdateService: librockchip_update_jni.so
########################################################
PRODUCT_COPY_FILES += $(LOCAL_PATH)/apk/RKUpdateService/librockchip_update_jni.so:system/lib/librockchip_update_jni.so

# support Chrome
PRODUCT_COPY_FILES += $(LOCAL_PATH)/apk/chromeLib/libchromeview.so:system/lib/libchromeview.so \
	$(LOCAL_PATH)/apk/chromeLib/chrome-command-line:system/etc/chrome-command-line \
	$(LOCAL_PATH)/apk/chromeLib/chrome.sh:system/bin/chrome.sh

PRODUCT_COPY_FILES += \
	device/rockchip/rk30sdk/proprietary/bin/busybox:system/bin/busybox \
	device/rockchip/rk30sdk/proprietary/bin/io:system/xbin/io \
        device/rockchip/rk30sdk/init.rc:root/init.rc \
        device/rockchip/rk30sdk/mkdosfs:root/sbin/mkdosfs \
        device/rockchip/rk30sdk/init.$(TARGET_BOARD_HARDWARE).rc:root/init.$(TARGET_BOARD_HARDWARE).rc \
        device/rockchip/rk30sdk/init.$(TARGET_BOARD_HARDWARE).usb.rc:root/init.$(TARGET_BOARD_HARDWARE).usb.rc \
        device/rockchip/rk30sdk/ueventd.$(TARGET_BOARD_HARDWARE).rc:root/ueventd.$(TARGET_BOARD_HARDWARE).rc \
	device/rockchip/rk30sdk/init.goldfish.rc:root/init.goldfish.rc \
	device/rockchip/rk30sdk/init.trace.rc:root/init.trace.rc \
	device/rockchip/rk30sdk/init.usb.rc:root/init.usb.rc \
	device/rockchip/rk30sdk/ueventd.goldfish.rc:root/ueventd.goldfish.rc \
	device/rockchip/rk30sdk/ueventd.rc:root/ueventd.rc \
        device/rockchip/rk30sdk/media_profiles.xml:system/etc/media_profiles.xml \
	device/rockchip/rk30sdk/rk29-keypad.kl:system/usr/keylayout/rk29-keypad.kl

# Bluetooth configuration files
PRODUCT_COPY_FILES += \
	system/bluetooth/data/main.nonsmartphone.le.conf:system/etc/bluetooth/main.conf \
	frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
	frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
	$(LOCAL_PATH)/audio_policy.conf:system/etc/audio_policy.conf

PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/rk30xxnand_ko.ko.3.0.36+:root/rk30xxnand_ko.ko.3.0.36+ \
        device/rockchip/rk30sdk/rk30xxnand_ko.ko.3.0.8+:root/rk30xxnand_ko.ko.3.0.8+ 
PRODUCT_COPY_FILES += \
       device/rockchip/rk30sdk/vold.fstab:system/etc/vold.fstab 

# For audio-recoard 
PRODUCT_PACKAGES += \
        libsrec_jni 

# Superuser.apk 
PRODUCT_PACKAGES += \
        Superuser 

# GPU-MALI        
PRODUCT_PACKAGES += \
        libEGL_mali.so \
        libGLESv1_CM_mali.so \
        libGLESv2_mali.so \
        libMali.so \
        libUMP.so \
        mali.ko \
        ump.ko 
PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/proprietary/libmali/libMali.so:system/lib/libMali.so \
        device/rockchip/rk30sdk/proprietary/libmali/libMali.so:obj/lib/libMali.so \
        device/rockchip/rk30sdk/proprietary/libmali/libUMP.so:system/lib/libUMP.so \
        device/rockchip/rk30sdk/proprietary/libmali/libUMP.so:obj/lib/libUMP.so \
        device/rockchip/rk30sdk/proprietary/libmali/libEGL_mali.so:system/lib/egl/libEGL_mali.so \
        device/rockchip/rk30sdk/proprietary/libmali/libGLESv1_CM_mali.so:system/lib/egl/libGLESv1_CM_mali.so \
        device/rockchip/rk30sdk/proprietary/libmali/libGLESv2_mali.so:system/lib/egl/libGLESv2_mali.so \
        device/rockchip/rk30sdk/proprietary/libmali/mali.ko.3.0.36+:system/lib/modules/mali.ko.3.0.36+ \
        device/rockchip/rk30sdk/proprietary/libmali/mali.ko:system/lib/modules/mali.ko \
        device/rockchip/rk30sdk/proprietary/libmali/ump.ko.3.0.36+:system/lib/modules/ump.ko.3.0.36+ \
        device/rockchip/rk30sdk/proprietary/libmali/ump.ko:system/lib/modules/ump.ko \
        device/rockchip/rk30sdk/gpu_performance/performance_info.xml:system/etc/performance_info.xml \
        device/rockchip/rk30sdk/gpu_performance/performance:system/bin/performance \
        device/rockchip/rk30sdk/gpu_performance/libperformance_runtime.so:system/lib/libperformance_runtime.so \
        device/rockchip/rk30sdk/gpu_performance/gpu.rk30board.so:system/lib/hw/gpu.rk30board.so

PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/proprietary/libipp/rk29-ipp.ko.3.0.36+:system/lib/modules/rk29-ipp.ko.3.0.36+ \
        device/rockchip/rk30sdk/proprietary/libipp/rk29-ipp.ko:system/lib/modules/rk29-ipp.ko

PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/proprietary/libion/libion.so:system/lib/libion.so \
        device/rockchip/rk30sdk/proprietary/libion/libion.so:obj/lib/libion.so 

PRODUCT_COPY_FILES += \
	device/rockchip/rk30sdk/proprietary/bin/io:system/xbin/io \
	device/rockchip/rk30sdk/proprietary/bin/busybox:system/bin/busybox 
	
#########################################################
#       adblock rule
#########################################################        
PRODUCT_COPY_FILES += \
	device/rockchip/rk30sdk/proprietary/etc/.allBlock:system/etc/.allBlock \
	device/rockchip/rk30sdk/proprietary/etc/.videoBlock:system/etc/.videoBlock 

#########################################################
#       webkit
#########################################################        
PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/proprietary/libwebkit/libwebcore.so:system/lib/libwebcore.so \
        device/rockchip/rk30sdk/proprietary/libwebkit/libwebcore.so:obj/lib/libwebcore.so \
        device/rockchip/rk30sdk/proprietary/libwebkit/webkit_ver:system/lib/webkit_ver

#########################################################
#       vpu lib
#########################################################        
sf_lib_files := $(shell ls $(LOCAL_PATH)/proprietary/libvpu | grep .so)
PRODUCT_COPY_FILES += \
        $(foreach file, $(sf_lib_files), $(LOCAL_PATH)/proprietary/libvpu/$(file):system/lib/$(file))

PRODUCT_COPY_FILES += \
        $(foreach file, $(sf_lib_files), $(LOCAL_PATH)/proprietary/libvpu/$(file):obj/lib/$(file))

PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/proprietary/libvpu/media_codecs.xml:system/etc/media_codecs.xml \
	device/rockchip/rk30sdk/proprietary/libvpu/registry:system/lib/registry \
        device/rockchip/rk30sdk/proprietary/libvpu/vpu_service.ko.3.0.36+:system/lib/modules/vpu_service.ko.3.0.36+ \
        device/rockchip/rk30sdk/proprietary/libvpu/vpu_service.ko:system/lib/modules/vpu_service.ko

PRODUCT_PACKAGES += \
        ilibapedec.so \
        libjesancache.so                  \
        libjpeghwdec.so                   \
        libjpeghwenc.so                   \
        libOMX_Core.so                    \
        libomxvpu.so                      \
        librkswscale.so                   \
        librkwmapro.so                    \
        libyuvtorgb.so                    \
        libvpu.so		        \
	libhtml5_check.so

ifeq ($(strip $(BUILD_WITH_RK_EBOOK)),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rkbook/apk/BooksProvider.apk:system/app/BooksProvider.apk \
    $(LOCAL_PATH)/rkbook/apk/RKEBookReader.apk:system/app/RKEBookReader.apk \
    $(LOCAL_PATH)/rkbook/bin/adobedevchk:system/bin/adobedevchk \
    $(LOCAL_PATH)/rkbook/lib/libadobe_rmsdk.so:system/lib/libadobe_rmsdk.so \
    $(LOCAL_PATH)/rkbook/lib/libRkDeflatingDecompressor.so:system/lib/libRkDeflatingDecompressor.so \
    $(LOCAL_PATH)/rkbook/lib/librm_ssl.so:system/lib/librm_ssl.so \
    $(LOCAL_PATH)/rkbook/lib/libflip.so:system/lib/libflip.so \
    $(LOCAL_PATH)/rkbook/lib/librm_crypto.so:system/lib/librm_crypto.so \
    $(LOCAL_PATH)/rkbook/lib/rmsdk.ver:system/lib/rmsdk.ver \
    $(LOCAL_PATH)/rkbook/fonts/adobefonts/AdobeMyungjoStd.bin:system/fonts/adobefonts/AdobeMyungjoStd.bin \
    $(LOCAL_PATH)/rkbook/fonts/adobefonts/CRengine.ttf:system/fonts/adobefonts/CRengine.ttf \
    $(LOCAL_PATH)/rkbook/fonts/adobefonts/RyoGothicPlusN.bin:system/fonts/adobefonts/RyoGothicPlusN.bin \
    $(LOCAL_PATH)/rkbook/fonts/adobefonts/AdobeHeitiStd.bin:system/fonts/adobefonts/AdobeHeitiStd.bin \
    $(LOCAL_PATH)/rkbook/fonts/adobefonts/AdobeMingStd.bin:system/fonts/adobefonts/AdobeMingStd.bin
endif
ifeq ($(strip $(BUILD_WITH_SURFER_APK)),true)
PRODUCT_COPY_FILES +=\
    $(LOCAL_PATH)/surfer/bootanimation.zip:system/media/bootanimation.zip 
endif    
ifeq ($(strip $(BUILD_WITH_HDMI_APK)),true)
PRODUCT_COPY_FILES +=\
    $(LOCAL_PATH)/hdmi/HdmiController.apk:system/app/HdmiController.apk
endif
# Live Wallpapers
PRODUCT_PACKAGES += \
        LiveWallpapersPicker \
        NoiseField \
        PhaseBeam \
        librs_jni \
        libjni_pinyinime \
	hostapd_rtl

# HAL
PRODUCT_PACKAGES += \
		power.$(TARGET_BOARD_PLATFORM) \
		sensors.$(TARGET_BOARD_HARDWARE) \
		gralloc.$(TARGET_BOARD_HARDWARE) \
		hwcomposer.$(TARGET_BOARD_HARDWARE) \
		lights.$(TARGET_BOARD_HARDWARE) \
		camera.$(TARGET_BOARD_HARDWARE) \
		Camera \
		akmd8975 

# charge
PRODUCT_PACKAGES += \
		charger \
		charger_res_images 

PRODUCT_CHARACTERISTICS := tablet

# audio lib
PRODUCT_PACKAGES += \
		audio_policy.$(TARGET_BOARD_HARDWARE) \
		audio.primary.$(TARGET_BOARD_HARDWARE) \
        audio.a2dp.default

# Filesystem management tools
# EXT3/4 support
PRODUCT_PACKAGES += \
	mke2fs \
	e2fsck \
	tune2fs \
	resize2fs \
	mkdosfs
# audio lib
ifeq ($(strip $(BOARD_USES_ALSA_AUDIO)),true)
PRODUCT_PACKAGES += \
    libasound \
    alsa.default \
		acoustics.default
endif


PRODUCT_PROPERTY_OVERRIDES += \
        persist.sys.usb.config=mass_storage \
        persist.sys.strictmode.visual=false \
        dalvik.vm.jniopts=warnonly \
	ro.rksdk.version=RK30_ANDROID$(PLATFORM_VERSION)-SDK-v1.00.00 \
        sys.hwc.compose_policy=6 \
        ro.sf.fakerotation=true \
        ro.sf.hwrotation=270 \
	ro.rk.MassStorage=false \
        wifi.interface=wlan0 \
	ro.sf.lcd_density=160 \
        ro.rk.screenoff_time=60000 \
        ro.rk.def_brightness=180\
        ro.rk.homepage_base=http://www.4pda.ru/\
        ro.rk.install_non_market_apps=false\
        ro.default.size=100\
        persist.sys.timezone=Europe/Moscow\
        ro.product.usbfactory=rockchip_usb \
        wifi.supplicant_scan_interval=15 \
        ro.opengles.version=131072 \
        testing.mediascanner.skiplist = /mnt/sdcard/Android/ \

PRODUCT_TAGS += dalvik.gc.type-precise

# NTFS support
PRODUCT_PACKAGES += \
    ntfs-3g

PRODUCT_PACKAGES += \
        com.android.future.usb.accessory

PRODUCT_PACKAGES += \
        librecovery_ui_$(TARGET_PRODUCT)

# for bugreport
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += device/rockchip/rk30sdk/bugreport.sh:system/bin/bugreport.sh
endif

# wifi
PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/wlan.ko.3.0.36+:system/lib/modules/wlan.ko.3.0.36+ \
        device/rockchip/rk30sdk/wlan.ko:system/lib/modules/wlan.ko \
	device/rockchip/rk30sdk/rt5370sta.ko:system/lib/modules/rt5370sta.ko \
	device/rockchip/rk30sdk/rkwifi.ko.3.0.36+:system/lib/modules/rkwifi.ko.3.0.36+ \
        device/rockchip/rk30sdk/rkwifi.ko:system/lib/modules/rkwifi.ko \
        device/rockchip/rk30sdk/8188eu.ko:system/lib/modules/8188eu.ko \
        device/rockchip/rk30sdk/8188eu.ko.3.0.36+:system/lib/modules/8188eu.ko.3.0.36+ \
        device/rockchip/rk30sdk/8192cu.ko:system/lib/modules/8192cu.ko \
        device/rockchip/rk30sdk/8192cu.ko.3.0.36+:system/lib/modules/8192cu.ko.3.0.36+ \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml

# ethernet settings
#PRODUCT_COPY_FILES += \
#        frameworks/base/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

#########################################################
#	Phone
#########################################################
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/phone/etc/ppp/ip-down:system/etc/ppp/ip-down \
        $(LOCAL_PATH)/phone/etc/ppp/ip-up:system/etc/ppp/ip-up \
        $(LOCAL_PATH)/phone/etc/ppp/call-pppd:system/etc/ppp/call-pppd \
        $(LOCAL_PATH)/phone/etc/operator_table:system/etc/operator_table 


PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/phone/bin/usb_modeswitch.sh:system/bin/usb_modeswitch.sh \
        $(LOCAL_PATH)/phone/bin/usb_modeswitch:system/bin/usb_modeswitch

    modeswitch_files := $(shell ls $(LOCAL_PATH)/phone/etc/usb_modeswitch.d)
    PRODUCT_COPY_FILES += $(foreach file, $(modeswitch_files), \
                          $(LOCAL_PATH)/phone/etc/usb_modeswitch.d/$(file):system/etc/usb_modeswitch.d/$(file))

PRODUCT_PACKAGES += \
	rild \
	chat

ifeq ($(strip $(BOARD_WITH_CALL_FUNCTION)), true)
		
    PRODUCT_PACKAGES += \
	libreference-ril-mu509
	
######################################
# 	phonepad modem list
######################################
ifeq ($(strip $(BOARD_RADIO_MU509)), true)
PRODUCT_PROPERTY_OVERRIDES += \
				ril.function.dataonly=0 
	ADDITIONAL_DEFAULT_PROPERTIES += rild.libpath=/system/lib/libreference-ril-mu509.so
	ADDITIONAL_DEFAULT_PROPERTIES += rild.libargs=-d_/dev/ttyUSB2

PRODUCT_COPY_FILES += \
				$(LOCAL_PATH)/phone/lib/libreference-ril-mu509.so:system/lib/libreference-ril-mu509.so
endif

else
#Use external 3G dongle
PRODUCT_PROPERTY_OVERRIDES += \
	rild.libargs=-d_/dev/ttyUSB1 \
	ril.pppchannel=/dev/ttyUSB2 \
	rild.libpath=/system/lib/libril-rk29-dataonly.so \
	ril.function.dataonly=1

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/phone/lib/libril-rk29-dataonly.so:system/lib/libril-rk29-dataonly.so
endif

# Get the long list of APNs 
PRODUCT_COPY_FILES += device/rockchip/$(TARGET_PRODUCT)/phone/etc/apns-full-conf.xml:system/etc/apns-conf.xml

ifeq ($(strip $(BOARD_BOOT_READAHEAD)),true)
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/proprietary/readahead/readahead:root/sbin/readahead \
	$(LOCAL_PATH)/proprietary/readahead/readahead_list.txt:root/readahead_list.txt
endif

#whtest for bin
PRODUCT_COPY_FILES += \
        device/rockchip/rk30sdk/whtest.sh:system/bin/whtest.sh

$(call inherit-product, external/wlan_loader/wifi-firmware.mk)

$(call inherit-product, system/bluetooth/brcm_patchram_plus/hcd.mk)
$(call inherit-product, device/rockchip/rk30_common/common.mk)
PRODUCT_PACKAGES += hwcomposer.rk30board.so gralloc.rk30board.so libyuvtorgb.so
