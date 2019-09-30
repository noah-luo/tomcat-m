# tomcat-many-instance
tomcat-many-instance 是一个部署tomcat单机多实例工具，内含脚本

-----

简单介绍一下各个文件夹及文件：
> * bin：主要存放脚本文件，例如比较常用的windows和linux系统中启动和关闭脚本
> * conf：主要存放配置文件，其中最重要的两个配置文件是server.xml和web.xml
> * lib：主要存放tomcat运行所依赖的包
> * LICENSE：版权许可证，软件版权信息及使用范围等信息
> * logs：主要存放运行时产生的日志文件，例如catalina.out(曾经掉过一个大坑)、catalina.{date}.log等
> * NOTICE：通知信息，一些软件的所属信息和地址什么的
> * RELEASE-NOTES：发布说明，包含一些版本升级功能点
> * RUNNING.txt：运行说明，必需的运行环境等信息
> * temp：存放tomcat运行时产生的临时文件，例如开启了hibernate缓存的应用程序，会在该目录下生成一些文件
> * webapps：部署web应用程序的默认目录，也就是 war 包所在默认目录
> * work：主要存放由JSP文件生成的servlet（java文件以及最终编译生成的class文件）

# Tomcat 常见的几种部署场景

通常，我们在同一台服务器上对 Tomcat 部署需求可以分为以下几种：单实例单应用，单实例多应用，多实例单应用，多实例多应用。实例的概念可以理解为上面说的一个 Tomcat 目录。

> * 单实例单应用：比较常用的一种方式，只需要把你打好的 war 包丢在 webapps目录下，执行启动 Tomcat 的脚本就行了。
> * 单实例多应用：有两个不同的 Web 项目 war 包，还是只需要丢在webapps目录下，执行启动 Tomcat 的脚本，访问不同项目加上不同的虚拟目录。这种方式要慎用在生产环境，因为重启或挂掉 Tomcat 后会影响另外一个应用的访问。
> * 多实例单应用：多个 Tomcat 部署同一个项目，端口号不同，可以利用 Nginx 这么做负载均衡，当然意义不大。
> * 多实例多应用：多个 Tomcat 部署多个不同的项目。这种模式在服务器资源有限，或者对服务器要求并不是很高的情况下，可以实现多个不同项目部署在同一台服务器上的需求，来实现资源使用的最大化。

-----
# 说明
## 本多实例脚本采用的方法和说明
1. 对带版本号的tomcat目录,创建不带版本号的软连接,方便以后升级tomcat
2. 多实例tomcat共用一个tomcat主目录,和一个instance目录
3. instance目录存放 [端口号+用途] 组成的实例名文件夹
4. 实例文件夹下是各自的conf,webapps,logs目录
5. 实例文件夹下的`tomcat.sh`是实例的启停脚本[任意路径执行]
6. 实例文件夹下的`setenv.sh`是变量`JAVA_OPTS`配置参数,便于修改内存参数

## 这样做的目的
让本项目,既可以用于单实例部署,也可以用于多实例部署,不用维护多个tomcat版本,方便升级,统一管理

## server.xml配置文件更改
1. 删除注释配置,添加部分中文注释
2. 该8005端口为随机端口
3. 禁用ajp端口[8009]
4. 注释掉tomcat认证用户相关配置
5. 添加tomcat连接池配置
6. 完善8080服务配置(压缩,dns等)
7. 设置webapps目录为根目录

## logging.properties配置文件
1. 清除所有日志配置,值保留基本日志

# 使用说明
## 脚本说明
script目录下有三个脚本,分别是`instance.sh`,`tomcat.sh`,`setenv.sh`
`instance.sh`脚本是主角,用于生产多实例配置,生成过程中会cp后两个脚本多实例目录下
`tomcat.sh`是实例启停脚本,导入了`setenv.sh`脚本中的内存参数,本脚本可在任意目录执行
`setenv.sh`中是JAVA_OPTS`配置参数及参数说明
本脚本仅能生成端口号为8081-8099的实例[20个已经够多了]

## 命令说明
直接执行脚本不带参数,会输出帮助信息,帮助信息就是使用说明
```
faafa
```
### 添加实例 
```shell
sh instance.sh -add 8081 user
```
### 查看所有实例
```shell
sh instance.shh -list
```
### 删除实例
```shell
sh instance.sh -remove 8081 user
```
### 删除所有实例
```shell
sh instance.sh -removeAll
```



