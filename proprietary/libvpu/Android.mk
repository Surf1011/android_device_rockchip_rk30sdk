LOCAL_PATH := $(call my-dir)

# Use BUILD_PREBUILT instead of PRODUCT_COPY_FILES to bring in the NOTICE file.
include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libapedec.so
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)

include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libhtml5_check.so
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)

include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libjesancache.so                  
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)
  
include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libjpeghwdec.so                   
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)
  
include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libjpeghwenc.so                   
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)
  
include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libOMX_Core.so                    
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)
  
include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libomxvpu.so                      
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)
  
include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := librkwmapro.so                
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)
  
include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libvpu.so                
LOCAL_MODULE_TAGS := optional
include $(BUILD_MULTI_PREBUILT)

