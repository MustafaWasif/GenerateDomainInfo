#!/bin/bash
#DOMAIN_SEARCH='Domain Name|Registrant Name|tech organization|Status|email|Date|admin phone|tech phone|Tech Country|Tech City|Registrant Country|Registrant City|Name Server|Registrar Abuse Contact Email'
echo "Please Choose:"
echo "1: Analyze a Domain Name. Eg. yahoo.com"
echo "2: Analyze domain of an Email Address. Eg. bob@yahoo.com"
echo "3: Analyze an IP address. Eg. 98.137.11.163"
echo "4: Analyze a URL. Eg. www.yahoo.com"
read NUMBER_INPUT
case $NUMBER_INPUT in
1)
echo "Please type a Domain Name."
read USER_INPUT
domain_name=$USER_INPUT
;;
2)
echo "Please type an email
address"
read USER_INPUT
email_address=$USER_INPUT
;;
3)
echo
"Please type an IP address"
read USER_INPUT
ip_address=$USER_INPUT
;;
4)
echo "Please type a URL"
read USER_INPUT
url=$USER_INPUT
;;
*)
echo "Invalid Input. Please choose between 1 to 4."
exit 0
;;
esac
GetDomainInfo(){
echo "Relevant information of Domain: $domain_name ..."
echo
echo " -------General Info--------"
whois $domain_name | egrep -i 'Org|com'| egrep -v "Billing|>>>|NOTICE|For" | egrep -i 'Domain Name|Registrant Name|tech organization|Status|email|Date|admin phone|tech phone|Tech Country|Tech City|Registrant Country|Registrant City|Name Server|Registrar Abuse Contact Email'
echo
echo " -------IP Address-----------"
dig "$domain_name" | awk '$0==";; ANSWER SECTION:"{f=1; next}!NF{f=0;}f'
echo
echo " -------Server Name-----------"
dig +noall +answer soa "$domain_name" | sed 's/.*SOA\s*//' | sed 's/^\([^ ]*\). .*/\1/g'
}
#GetDomainInfo $domain_name

GetIPInfo(){
echo "Relevant information of IP: $ip_address ...."
echo
echo " -------General Info--------"
whois $ip_address | egrep -i 'Organization|OrgId|NetName|NetRange|Parent|OrgTechEmail|OrgAbuseEmail'
echo
echo "-------Pointer Record (Security Tool)-----------"
dig -x "$ip_address" +short
}
if [ $domain_name ]
then
GetDomainInfo $domain_name
elif [ $email_address ]
then
domain_name=$( echo "$email_address" | sed -n 's/.*@//p')
#echo "$domain_name"
GetDomainInfo $domain_name
elif [ $ip_address ]
then
GetIPInfo $ip_address
elif [ $url ]
then
domain_name=$( echo "$url" | sed -n 's/.*www.//p')
GetDomainInfo $domain_name
fi
