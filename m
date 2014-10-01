From: VARUN BHATIA <varuninbharti@gmail.com>
Date: Wed, 01 Oct 2014 13:58:12 +0000
Subject: Re: SCTP Multihoming Always sending primary interface ip I
Message-Id: <CAFi7GbyZ8k3aseibZ8u01ZdrOtYuM5rEc7yzWcMdOGVw8F5Cdw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
In-Reply-To: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

They both are on different subnets one is on 10.204 & other o 10.205.

Kindly let me know what route will be required for this as I am still
stuck in this issue.

Thanks,
Varun

On Thu, Sep 25, 2014 at 6:06 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Thu, Sep 25, 2014 at 03:53:13PM +0530, VARUN BHATIA wrote:
>> The mask kept is /16, I placed wrong information correcting it:
>>
>>                   Host A                                      Host B
>> Primary    10.204.200.200                          10.204.100.100
>> Secondary 10.205.200.200                         10.205.100.100
>>
>> We are having our customized linux.
>>
>> ip neigh list
>> fe80::224:13ff:fe45:ced4 dev eth3 lladdr 00:24:13:45:ce:d4 router STALE
>> fe80::224:13ff:fe45:ced5 dev eth0 lladdr 00:24:13:45:ce:d5 router STALE
>> 10.205.100.100 dev eth3 lladdr 00:0b:ab:55:57:01 REACHABLE
>>
>> I tried for a workaround and played with nat rules:
>>
>> iptables -t nat -I POSTROUTING -o eth2 -d 10.204.100.100 -j SNAT -p
>> sctp --to 10.204.200.200
>> iptables -t nat -I POSTROUTING -o eth3 -d 10.205.100.100 -j SNAT -p
>> sctp --to 10.205.200.200
>>
>> After this it started working though it is not the correct solution,
>> but yet after this it seems due to some conntrack table entries when I
>> receive request from peer end it is not working proparly:
>>
>>   3.484280 10.205.200.200 -> 10.205.100.100 SCTP 98 INIT
>>   3.488652 10.205.100.100 -> 10.205.200.200 SCTP 354 INIT_ACK
>>   3.488706 10.205.200.200 -> 10.205.100.100 SCTP 310 COOKIE_ECHO
>>   3.488923 10.205.100.100 -> 10.205.200.200 SCTP 60 COOKIE_ACK
>>
>>   3.497282 10.205.200.200 -> 10.205.100.100 SCTP 62 SACK
>>
>>   6.512476 10.205.100.100 -> 10.205.200.200 SCTP 98 INIT
>>   6.512575 10.204.200.200 -> 10.205.100.100 SCTP 354 INIT_ACK
>>
>>  21.240776 10.205.100.100 -> 10.205.200.200 SCTP 310 COOKIE_ECHO
>>  21.240866 10.204.200.200 -> 10.205.100.100 SCTP 50 COOKIE_ACK
>>  21.242183 10.205.100.100 -> 10.205.200.200 SCTP 60 SHUTDOWN
>>  21.242237 10.205.200.200 -> 10.205.100.100 SCTP 50 SHUTDOWN_ACK
>>  21.242353 10.205.100.100 -> 10.205.200.200 SCTP 60 SHUTDOWN_COMPLETE
>>
>> When peer end sends INIT my box again send INIT_ACK using primary ip
>> address simlarly for COOKIE_ACK also, but SHUTDOWN ACK it is sending
>> correct.
>>
>> Not sure what I am missing here, kindly provide your inputs on this ?
>>
>> Thanks,
>> Varun
>>
>
> This is working as designed.  Since both your host addresses are on the same
> subnet, and since ip addresses are owned by the system in linux, not the
> interface, its not really relevant which source address is used.  If you want to
> force source ip addresses to be used for the interface you are sending from,
> you'll want to add higher priority routes that specify the src address.
>
> Neil
>



-- 
Regards,
Varun Bhatia
