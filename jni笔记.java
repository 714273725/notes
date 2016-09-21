JNI

1.代码中声明本地方法：private native String printJNI(String inputStr);
2.加载库文件：System.loadLibrary("HelloWorldJni");
3.调用本地方法：printJNI(String inputStr);


二
假如包名是ye.jian.ge
需要定位到包的上级目录，在这里定位到ye的上一级目录(java),然后后使用javah
文件创建到ye的上一级目录(java)下
javah ye.jian.ge.HelloWorld(使用jni的类)
生成文件:xxx_xxx_HelloWorld.h
可以看到xxx_xxx_HelloWorld.h中自动生成对应的函数：Java_xxx_xxx_HelloWorld_printJNI
Java_ + 包名（com.lucyfyr） + 类名(HelloWorld) + 接口名(printJNI)：必须要按此JNI规范来操作；函数名太长，可以在.c文件中通过函数名映射表来实现简化。

三：
实现JNI原生函数源文件：新建xxx_xxx_HelloWorld.c文件
里面实现Java_xxx_xxx_HelloWorld_printJNI（）函数
还要实现JNI_OnLoad（）   OnLoadJava_com_lucyfyr_HelloWorld_printJNI
JNI_OnLoad函数JNI规范定义的，当共享库第一次被加载的时候会被回调，
这个函数里面可以进行一些初始化工作，比如注册函数映射表，缓存一些变量等，
最后返回当前环境所支持的JNI环境。本例只是简单的返回当前JNI环境。

四:
编译生成so库
HelloWorld/jni/
下建立Android.mk ，并将com_lucyfyr_HelloWorld.c和 com_lucyfyr_HelloWorld.h 拷贝到进去
编写编译生成so库的Android.mk文件
ps：不管在哪里生成so，生成so所需要的.c和.h及Android.mk文件都要放在jni目录下，然后进入该目录下执行ndk-build
	
五：Android.mk文件
#makefile
LOCAL_PATH := $(my-dir)
APP_PROJECT_PATH = D:\jnilibs\text 
include $(CLEAR_VARS)  
LOCAL_MODULE := jpeg  
LOCAL_SRC_FILES := libjpeg.a  
include $(PREBUILT_STATIC_LIBRARY)
include $(CLEAR_VARS)    
LOCAL_MODULE    := image_compresser 
LOCAL_SRC_FILES := image_compresser.c      #需要的c文件的列表 
  
LOCAL_STATIC_LIBRARIES += jpeg  
  
include $(BUILD_SHARED_LIBRARY)

六：Application.mk
APP_STL:=stlport_static
APP_PLATFORM=android-8
APP_ABI = x86


遇到问题：
无法确定bitmap的签名：
javah -classpath D:\Android\sdk\platforms\android-22\android.jar;. ye.jian.ge.CompressImageUtils