#!/bin/sh
#定义tomcat主目录和多实例主目录
script_dir=$(cd `dirname $0`; pwd)
root_dir=`dirname $script_dir`
tomcat_dir="$root_dir/tomcat"  #tomcat主目录
app_dir=$root_dir/instances    #多实例主目录
[ -d $app_dir ] || mkdir -p $app_dir

#接收参数并赋值
action=$1
http_port=$2
instance_name=${http_port}_$3
instance_dir=$app_dir/$instance_name

function helpme()
{
	echo "-------------使用帮助-------------"
	echo "$0 [-add|-list|-remove|-removeall] {port} {ins_name}"
	echo -e "添加单个实例:\t  $0 -add port ins_name"
	echo -e "显示所有实例:\t  $0 -list"
	echo -e "移除单个实例:\t  $0 -remove port ins_name"
	echo -e "移除所有实例:\t  $0 -removeall"
}
if [ $# -eq 0 ];then
	helpme
	exit
fi

#echo "--------info---------"
#echo "  ROOT_DIR=$root_dir"
#echo "  SCRIPT_DIR=$script_dir"
#echo "  TOMCAT_DIR=$tomcat_dir"
#echo "  HTTP_PORT=$http_port"
#echo "  SHUTDOWN_PORT=$shutdown_port"
#echo "  AJP_PORT=$ajp_port"
#echo "  INSTANCE_DIR=$instance_dir"
#echo "  ACTION=$action"

function replace()
{
	echo "replace $2 to $3"
	sed -i "s#$2#$3#g" $1
}

function addInstance()
{
	echo "Step 1: 检查端口是在允许范围内[8081-8099]"
	res1=`expr $http_port - 8080 2>/dev/null`
	if [ $? -ne 0 ];then
		echo "error:输入的端口号不是数字,退出"
		exit 1
	elif [ $res1 -le 0 -o $res1 -ge 20 ];then
		echo "error:输入的端口号不在范围[8081-8099]内"
		exit 2
	else
		# 三个端口号分别为8080,5080,9080往上加
		shutdown_port=$(($res1+5080))
		ajp_port=$(($res1+9080))
	fi 

    echo "Step 2: 检查实例是否存在"
    res2=`find $app_dir -maxdepth 1 -type d -name "${http_port}*"|wc -l `
	if [ $res2 -ne 0 ]; then
		echo "端口:$http_port 对应实例目录已存在,不能创建,退出"
		exit 3
	fi 

	# 创建目录拷贝conf配置文件,创建webapps和logs目录
	echo "Step 3: 创建新实例:$http_port"
	mkdir $instance_dir
	mkdir $instance_dir/webapps
	mkdir $instance_dir/logs
	cp -R $tomcat_dir/conf $instance_dir/
	cp    $script_dir/tomcat.sh $instance_dir/
	cp    $script_dir/setenv.sh $instance_dir/
  
	echo "Step 4: 替换配置文件端口......"
	serverXML=$instance_dir/conf/server.xml
	replace $serverXML 8080 $http_port
	replace $serverXML 8005 $shutdown_port
      #	replace $serverXML 8009 $ajp_port
	echo "Create new tomcat instance successfully!"
}

function listInstance()
{
	echo "#################CURRENT INSTANCE#################"
	filelist=$(ls $app_dir)
	for filename in $filelist
	do
		echo $filename 
	done
}

function removeInstance()
{
	if   [ `echo $http_port|wc -L` -eq 0 ];then
		echo "请输入要删除的实例全名"
		exit 4
	elif [ -d "$instance_dir" ]; then
        rm -rf "$instance_dir/"
        echo "实例$instance_name已删除"
    else
    	echo "实例$instance_name不存在,请检查"
	fi
}

function removeAll()
{
	filelist=$(ls $root_dir/instances)
	for filename in $filelist
	do
		instance_dir=$root_dir/instances/$filename
		if [[ -d "$instance_dir" ]] && [[ $instance_dir != "." ]] && [[ $instance_dir != ".." ]]; then
			echo "remove instance $filename......"
        		rm -rf "$instance_dir"
		fi
	done
}

#########Main#######
if   [ "$action" = "-add" ] ; then
	addInstance
elif [ "$action" = "-remove" ]; then
	removeInstance
elif [ "$action" = "-list" ]; then
	listInstance
elif [ "$action" = "-removeall" ]; then
	removeAll	
else
	helpme
fi
