#!/bin/bash
#proxyauto 1.0.0
#Coded by: rumixpumix
#Github: https://github.com/ / 
clear

proxy_checker() {
clear
figlet proxyauto
printf '\n'
printf '                Coded by: rumix'
printf '\n------------------------------------------------\n'
printf '\n'
printf '\e[31m\e[1m[ProxyAuto] \e[0mMore proxies = More time required'
read -p$'\n\e[31m\e[1m[ProxyAuto] \e[0mMinimum amount of proxies needed: (Good amount=3) ' amount_proxy
cd proxy
echo $amount_proxy > amount.txt
python3 proxy_checker_$proxy.py &
pid1=$!
wait $pid1
printf "\n\e[31m\e[1m[ProxyAuto] \e[0mProxies tested, creating config file.\n"
input_file="$proxy""_working_proxies.txt"
num_lines=$(wc -l < "$input_file")
if [ $num_lines -eq 0 ]; then
  read line < "$input_file"
  ip_address=$(echo "$line" | cut -d':' -f1)
  port_number=$(echo "$line" | cut -d':' -f2)
  modified_line=$(echo "$proxy $ip_address $port_number")
  echo "$modified_line" > "$input_file"
else
tail -c1 "$input_file" | read -r _ || echo >> "$input_file"
  while read -r line; do
    ip_address=$(echo "$line" | cut -d':' -f1)
    port_number=$(echo "$line" | cut -d':' -f2)
    modified_line=$(echo "$proxy $ip_address $port_number")
    sed -i "s|^$line\$|$modified_line|" "$input_file"
  done < "$input_file"
fi
cd ..
cp proxychains.txt /etc/proxychains4.conf
cd proxy
cat $input_file >> /etc/proxychains4.conf
command_input
}

command_input() {
read -p $'\n\e[31m\e[1m[ProxyAuto-COMMAND] \e[0mInput command: ' command
proxychains4 $command
read -p $'\n\e[31m\e[1m[ProxyAuto] \e[0mEnter for new command' none
command_input
}

proxy_method() {
curl 'https://api.proxyscrape.com/v2/?request=getproxies&protocol='$proxy'&timeout=10000&country=all' > proxy/$proxy.proxies
clear
figlet proxyauto
printf '\n'
printf '                Coded by: rumix'
printf '\n------------------------------------------------\n'
printf '\n'
printf '\e[31m\e[1m[ProxyAuto] \e[0m'${proxy^^}' proxies, grabbed proxy list. \n'
printf '\e[31m\e[1m[ProxyAuto] \e[0mDo you want to back-up your existing proxychains4.conf file\n'
printf '\e[1m\e[31m[1] \e[0mYes\n'
printf '\e[1m\e[31m[2] \e[0mNo\n'
read -p $'\e[1m\e[31m[OPTION] \e[0mSelect: ' option
if [ $option == 1 ]; then
cp /etc/proxychains4.conf >> /etc/proxychains4-backup.conf
printf '\n\e[31m\e[1m[ProxyAuto] \e[0mOld conf file backed up at /etc/proxychains4-backup.conf\n'
elif [ $option == 2 ]; then
printf '\e[31m\e[1m[ProxyAuto] \e[0mNot backing up, overwriting existing file.\n'
else
printf '\e[31m\e[1m[ProxyAuto] \e[0mWRONG ARGS\n'
sleep 2
proxy_method
fi
sleep 2
proxy_checker
}

menu(){
clear
figlet proxyauto
printf '\n'
printf '                Coded by: rumix'
printf '\n------------------------------------------------\n'
printf '\n'
printf "\e[31m\e[1m[ProxyAuto] \e[0mSelect proxy method\n"
printf "\e[1m\e[31m[1] \e[0mHTTP\n"
printf "\e[1m\e[31m[2] \e[0mSOCKS4\n"
printf "\e[1m\e[31m[3] \e[0mSOCKS5\n"
read -p $'\e[1m\e[31m[OPTION] \e[0mChoose proxy: ' option
if [ $option == 1 ]; then
proxy=http
proxy_method
elif [ $option == 2 ]; then
proxy=socks4
proxy_method
elif [ $option == 3 ]; then
proxy=socks5
proxy_method
else 
printf 'INCORRECT INPUT'
menu
fi
}
menu
