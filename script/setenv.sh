JAVA_OPTS="-server -Dfile.encoding=UTF-8 -Duser.timezone=Asia/Shanghai
           -Xms1024m
           -Xmx1024m
           -Xss1024K 
           -XX:PermSize=64M
           -XX:MaxPermSize=128m
           "
#参数说明:
#• -server：启用jdk的server版本。
#• -Xms：虚拟机初始化时的最小堆内存。
#• -Xmx：虚拟机可使用的最大堆内存。 #-Xms与-Xmx设成一样的值，避免JVM因为频繁的GC导致性能大起大落
#• -Xss：线程堆栈,可以根据业务服务器的每次请求的大小来进行分配
#• -XX:PermSize：设置非堆内存初始值,默认是物理内存的1/64。
#• -XX:MaxPermSize：Perm（俗称方法区）占整个堆内存的最大值，也称内存最大永久保留区域。
