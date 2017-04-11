declare -a arr=(ex1-hello-world ex2-init-exit ex3-doc-license ex4-param ex5-multi-file ex6-char-register ex7-char-dev-register ex8-char-dev-register-dynamic ex9-write ex10-read ex11-debug ex12-proc ex13-ioctl)                                                  
echo > Makefile.log
echo > Module.log
for p in ${arr[@]}; do \
	echo | tee -a Module.log
	echo "=============================================" | tee -a Module.log
	flag=0
	cd $p
	echo "$p============================================" >> ../Makefile.log
	make >> ../Makefile.log
	var=$(ls | grep ko)
	if echo $var | grep -q ko
	then
		echo "Make successful" >> ../Makefile.log
	else
		echo "Make failed" >> ../Makefile.log
		echo "Module load and unload commands not run for $p as make failed" >> ../Module.log
		cd ..
		continue
	fi

	sudo insmod $var
	mod=$(lsmod | grep $(echo ${var::-3} | tr '-' '_'))

	if echo $mod | grep -q $(echo ${var::-3} | tr '-' '_')
	then
		echo "insmod: $p module successfully loaded" | tee -a ../Module.log
		flag=1
	else
		echo "insmod: $p module could not be loaded successfully" | tee -a ../Module.log
	fi

	if echo $p | grep ex9 || echo $p | grep ex10 || echo $p | grep ex13
	then
		cc test.c -o test
		sudo mknod /dev/hello c 255 0
		sudo ./test
	fi

	sudo rmmod ${var::-3}
	if [ $flag -eq 1 ]
	then
		mod=$(lsmod | grep -q ${var::-3})
		if echo $mod | grep -q ${var::-3}
		then
			echo "rmmod: $p module could not be successfully removed" | tee -a ../Module.log
		else
			echo "rmmod: $p module  successfully removed" | tee -a ../Module.log
		fi
	else
		echo "rmmod: $p module was not loaded, nothing to remove" | tee -a ../Module.log 
	fi
	make clean >> ../Makefile.log
	cd ..
	
done

