From: VARUN BHATIA <varuninbharti@gmail.com>
Date: Thu, 25 Sep 2014 10:35:13 +0000
Subject: Re: SCTP Multihoming Always sending primary interface ip I
Message-Id: <CAFi7Gby7JyrvmFd4B3djQuH1V6n5T55v0PfZr48J8ejAtWYTkQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
In-Reply-To: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The mask kept is /16, I placed wrong information correcting it:

                  Host A                                      Host B
Primary    10.204.200.200                          10.204.100.100
Secondary 10.205.200.200                         10.205.100.100

We are having our customized linux.

ip neigh list
fe80::224:13ff:fe45:ced4 dev eth3 lladdr 00:24:13:45:ce:d4 router STALE
fe80::224:13ff:fe45:ced5 dev eth0 lladdr 00:24:13:45:ce:d5 router STALE
10.205.100.100 dev eth3 lladdr 00:0b:ab:55:57:01 REACHABLE

I tried for a workaround and played with nat rules:

iptables -t nat -I POSTROUTING -o eth2 -d 10.204.100.100 -j SNAT -p
sctp --to 10.204.200.200
iptables -t nat -I POSTROUTING -o eth3 -d 10.205.100.100 -j SNAT -p
sctp --to 10.205.200.200

After this it started working though it is not the correct solution,
but yet after this it seems due to some conntrack table entries when I
receive request from peer end it is not working proparly:

  3.484280 10.205.200.200 -> 10.205.100.100 SCTP 98 INIT
  3.488652 10.205.100.100 -> 10.205.200.200 SCTP 354 INIT_ACK
  3.488706 10.205.200.200 -> 10.205.100.100 SCTP 310 COOKIE_ECHO
  3.488923 10.205.100.100 -> 10.205.200.200 SCTP 60 COOKIE_ACK

  3.497282 10.205.200.200 -> 10.205.100.100 SCTP 62 SACK

  6.512476 10.205.100.100 -> 10.205.200.200 SCTP 98 INIT
  6.512575 10.204.200.200 -> 10.205.100.100 SCTP 354 INIT_ACK

 21.240776 10.205.100.100 -> 10.205.200.200 SCTP 310 COOKIE_ECHO
 21.240866 10.204.200.200 -> 10.205.100.100 SCTP 50 COOKIE_ACK
 21.242183 10.205.100.100 -> 10.205.200.200 SCTP 60 SHUTDOWN
 21.242237 10.205.200.200 -> 10.205.100.100 SCTP 50 SHUTDOWN_ACK
 21.242353 10.205.100.100 -> 10.205.200.200 SCTP 60 SHUTDOWN_COMPLETE

When peer end sends INIT my box again send INIT_ACK using primary ip
address simlarly for COOKIE_ACK also, but SHUTDOWN ACK it is sending
correct.

Not sure what I am missing here, kindly provide your inputs on this ?

Thanks,
Varun

On Wed, Sep 24, 2014 at 11:52 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
> On 09/24/2014 01:26 PM, VARUN BHATIA wrote:
>> Hi Vlad,
>>
>> This is my configuration eth2 and eth3 of 2 machines are connected
>> through my office network.
>>                  Host A                                      Host B
>> Primary    10.204.200.200                          10.205.200.200
>> Secondary 10.204.100.100                         10.205.100.100
>>
>
> Is this a /24 netmask?
>
> What does it say if you run
>   ip route get 10.205.200.200
>
> and
>    ip route get 10.205.100.100
>
> Also, which kernel are you using?
>
> -vlad
>
>> When my both interfaces are up then:
>>
>>   0.903456 10.204.200.200 -> 10.204.100.100 SCTP 100 INIT
>>   0.905510 10.204.100.100 -> 10.204.200.200 SCTP 356 INIT_ACK
>>   0.905565 10.204.200.200 -> 10.204.100.100 SCTP 312 COOKIE_ECHO
>>   0.907578 10.204.100.100 -> 10.204.200.200 SCTP 62 COOKIE_ACK
>>
>>   3.099986 10.205.100.100 -> 10.205.200.200 SCTP 100 HEARTBEAT
>>   3.106487 10.204.200.200 -> 10.205.100.100 SCTP 100 HEARTBEAT_ACK
>>   6.889510 10.204.200.200 -> 10.204.100.100 SCTP 100 HEARTBEAT
>>   6.891533 10.204.100.100 -> 10.204.200.200 SCTP 100 HEARTBEAT_ACK
>>   9.257506 10.204.200.200 -> 10.205.100.100 SCTP 100 HEARTBEAT
>>   9.258420 10.204.100.100 -> 10.204.200.200 SCTP 100 HEARTBEAT_ACK
>>  12.248829 10.204.100.100 -> 10.204.200.200 SCTP 100 HEARTBEAT
>>  12.248869 10.204.200.200 -> 10.204.100.100 SCTP 100 HEARTBEAT_ACK
>>  57.372808 10.204.200.200 -> 10.204.100.100 SCTP 56 SHUTDOWN
>>  57.374730 10.204.100.100 -> 10.204.200.200 SCTP 62 SHUTDOWN_ACK
>>  57.374767 10.204.200.200 -> 10.204.100.100 SCTP 52 SHUTDOWN_COMPLETE
>>
>>
>> Now I make my interface down eth2 which is primary of Host A:
>>
>> At A:
>>
>> 107.729047 10.204.200.200 -> 10.204.100.100 SCTP 100 INIT
>> 110.740242 10.204.200.200 -> 10.205.100.100 SCTP 100 INIT
>> 113.744168 10.204.200.200 -> 10.204.100.100 SCTP 100 INIT
>>
>>
>> At B:
>>  69.842169 10.204.200.200 -> 10.204.100.100 SCTP 100 INIT
>>  69.842234 10.204.100.100 -> 10.204.200.200 SCTP 356 INIT_ACK
>>
>>
>> It is dropping INIT ACK because the ip address on which it is sending
>> is down, I have made the changes recommended by you but yet the result
>> is same:
>>
>> ip neigh list
>> fe80::224:13ff:fe45:ced4 dev eth3 lladdr 00:24:13:45:ce:d4 router STALE
>> fe80::224:13ff:fe45:ced5 dev eth0 lladdr 00:24:13:45:ce:d5 router REACHABLE
>> 10.205.100.100 dev eth3 lladdr 00:0b:ab:55:57:01 DELAY
>> 10.201.100.22 dev eth3 lladdr 00:24:13:45:ce:d4 DELAY
>> 10.206.0.1 dev eth0 lladdr 00:24:13:45:ce:d5 REACHABLE
>>
>>
>> Thanks,
>> Varun
>>
>> On Wed, Sep 24, 2014 at 10:03 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
>>> On 09/24/2014 11:42 AM, Varun Bhatia wrote:
>>>> Thanks Vlad for your response but they are already on different subnets :(
>>>
>>> Look at your neighbor cache (ip neigh list).  If it shows the peer
>>> on the wrong interface, then you need arg_ignore|arp_announce changes.
>>>
>>> -vlad
>>>
>>>>
>>>> Sent from Iphone,
>>>> Varun
>>>>
>>>>> On 24-Sep-2014, at 18:36, Vlad Yasevich <vyasevich@gmail.com> wrote:
>>>>>
>>>>>> On 09/24/2014 08:56 AM, VARUN BHATIA wrote:
>>>>>> Hi,
>>>>>>
>>>>>> We have developed multihomed application now while testing my setup is:
>>>>>>
>>>>>> Eth4  as primary interface connected back to back to another machine.
>>>>>> Eth5 as secondary interface connected back to back to another machine.
>>>>>>
>>>>>> I make my porimary interface down now when the INIT is been sent it
>>>>>> reaches to peer machine seems using secondary interface but the source
>>>>>> ip address kept is of primary interface only due to which when peer
>>>>>> machine tries to respond INIT_ACK it tries to send on primary
>>>>>> interface ip which is down and due to ICMP it drops the packet.
>>>>>>
>>>>>> I am not too good in Routing but it seems that some routing has not
>>>>>> been configuered properly, why is it always using primary ip ?
>>>>>>
>>>>>> I have tested the same part when I have connected my primary &
>>>>>> secondary interface through router but facrd the same issue.
>>>>>>
>>>>>> Any inputs are appreciated as I am stuck in it since last 2 days.
>>>>>>
>>>>>
>>>>> Try to put the 2 interfaces into 2 different subnets.  That should fix
>>>>> your issue.  If you can't do that,  then you'd have to play with arp_ignore
>>>>> and arp_announce sysctl values to make it do what you want.
>>>>>
>>>>> -vlad
>>>
>>
>>
>>
>



-- 
Regards,
Varun Bhatia
