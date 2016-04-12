#!/bin/bash


# Help function
function HELP
{
	echo "--------log4j log patch shell----------"
	echo "The log file name must be ended with format yyyy-MM-dd-XX or  yyyy-MM-dd.XX, 2015-08-08-16"
	echo "arg1: the path of the log folder"
	echo "arg2: the log file initial string, for example the log file name console.2016-04-12-00, this arg should be console."
	echo "arg3: the days of patching file before today"
	echo "Eg: /app/shell/tar_log.sh /log/tangren-server-web/ info_tangren-server.log. 2"
	echo "if you want patch log file daily please config the /etc/crontab file like this:"
	echo "13 0 * * *  tangren /app/shell/tar_log.sh /log/tangren-erp-web/ console.log- 2"
	exit 1
}


if test -z "$1" || test -z "$2" ||test -z "$3" 
then
    HELP
fi


day=$3
#echo ${day}
cmd=`printf "%s%s %s" "date -d\"" "${day}" "days ago\" +%Y-%m-%d"`
#echo "----------------------------------------------------------"
#echo $cmd
#echo "----------------------------------------------------------"
name=`eval $cmd`


#echo ${day}
cmd=`printf "%s%s %s" "date -d\"" "${day}" "days ago\" +%Y-%m"`
#echo "----------------------------------------------------------"
#echo $cmd
#echo "----------------------------------------------------------"
month_day_str=`eval $cmd`

#name=`date +%Y-%m-%d --date\\="${day} days ago"`
#name=`date -d'7 days ago' +%Y-%m-%d`
#echo $name
nametitle=$2
nameall=""

echo `date '+%Y-%m-%d %H:%M:%S'`" start patching"

cd $1

#if the patch folder not exist, creat it 
if [ ! -d "bak/"$month_day_str ];
then
	mkdir bak/$month_day_str
fi;


for((i=0;i<24;i++));
do
	if [ $i -lt 10 ] 
	then
		if [ -f $nametitle$name-0$i ] 
		then
			nameall=`printf "%s %s" "$nameall" "$nametitle$name-0$i"`
		fi;
		if [ -f $nametitle$name.0$i ] 
		then
			nameall=`printf "%s %s" "$nameall" "$nametitle$name.0$i"`
		fi;
	else
		if [ -f $nametitle$name-$i ]
		then
			nameall=`printf "%s %s" "$nameall" "$nametitle$name-$i"`
		fi;
		if [ -f $nametitle$name.$i ]
		then
			nameall=`printf "%s %s" "$nameall" "$nametitle$name.$i"`
		fi;
	fi
done



echo "tar：$nameall => $nametitle$name.tar.gz"
echo "------------------------------------------"
tar zcf "bak/"$month_day_str"/"$nametitle$name.tar.gz $nameall
if [ -f "bak/"$month_day_str"/"$nametitle$name.tar.gz ]
then
	echo "rm：$nameall"
	rm -rf $nameall
fi;
sleep 1

echo '---'$name' patch finished ---'
echo `date '+%Y-%m-%d %H:%M:%S'`" patch finished！"
echo "------------------------------------------"

