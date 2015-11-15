From your terminal launch this command:
```shell
$>: hexdump -s 0x33 -n 2 -v -d <FILE_NAME>.frm  | awk '{ print "Mysql version " $2; exit }'
```

Example output: `Mysql version 50530`, which means version 5.5.30
