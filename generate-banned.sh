#!/bin/sh

printf "my @bannedlist = (\n";
for bannedcommandname in "ALL" "\/tmp" "\/home" "\/etc" "\/egrep" "\/rm" "\/mkdir" "\/useradd" "\/adduser" "\/mkuser" "\/usermod" "\/chuser" "passwd" "shadow"
do
	printf "	\".*${bannedcommandname}.*\",\n"
done
wget -O - -o /dev/null https://github.com/GTFOBins/GTFOBins.github.io/tree/master/_gtfobins | egrep "blob\/.*\.md\"" | sed -e "s/.* title=\"//g" -e "s/\.md\" .*//g" | while read bannedcommandname
do
	printf "	\".*\/${bannedcommandname}.*\",\n"
done
printf ");\n"
