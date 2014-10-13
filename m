From: VARUN BHATIA <varuninbharti@gmail.com>
Date: Mon, 13 Oct 2014 13:38:52 +0000
Subject: Re: SCTP Multihoming Always sending primary interface ip I
Message-Id: <CAFi7Gbx3+QBP9JvA+Pme7yDMATSF9=MCa+pbkve5SCk_c=Aa9Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
In-Reply-To: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Neil,

The expectation is to support full mesh sctp association which is
capability to establish crossed paths inside SCTP association in
addition to direct paths between SCTP peers (IP addresses).

Not sure whether this can be done through routing or making changes in SCTP ?

Thanks,
Varun



On Wed, Oct 8, 2014 at 6:47 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Wed, Oct 08, 2014 at 12:37:04PM +0530, VARUN BHATIA wrote:
>> Hi,
>>
>> I have made some changes in routing and it seems started working but
>> having some doubts in that:
>>
>> ip route add 10.204.200.200 dev eth2 src 10.204.100.100
>>
>> ip route add 10.205.200.200 dev eth3 src 10.205.100.100
>>
>> 1. My all the ips are plumbed interfaces so whether it is required to
>> provide precise dev such as eth2:3 or eth3:2 ?
>>
> I don't think so, no.
>
>> 2. After adding this routing I am expecting symmetric routing that is
>> primary<->primary & secondary<->secondary, but my peer supports
>> assymetric also such as it secondary sends packet to my primary too,
>> how should that part be handled ?
>>
> Under what conditions do you want assymetric routing to occur?
>
> Neil
>
>> Thanks,
>> Varun
>>
>> On Tue, Oct 7, 2014 at 1:02 PM, VARUN BHATIA <varuninbharti@gmail.com> wrote:
>> > Hi Vlad,
>> >
>> > For clearing this doubt I created a rule in raw table that it should
>> > bypass my netfilter module but the issue is still coming:
>> >
>> > iptables -t raw -I PREROUTING -i eth3 -j CT --notrack
>> > iptables -t raw -I PREROUTING -i eth2 -j CT --notrack
>> >
>> > Where eth2 is my primary interface.
>> >
>> > Thanks,
>> > Varun
>> >
>> > On Fri, Oct 3, 2014 at 8:24 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
>> >> On 10/01/2014 09:58 AM, VARUN BHATIA wrote:
>> >>> Hi,
>> >>>
>> >>> They both are on different subnets one is on 10.204 & other o 10.205.
>> >>>
>> >>> Kindly let me know what route will be required for this as I am still
>> >>> stuck in this issue.
>> >>>
>> >>
>> >> If I had to guess, there is some kind of issue in nat/iptables handling....
>> >>
>> >> Any change you try without iptables?
>> >>
>> >> -vlad
>> >>
>> >>> Thanks,
>> >>> Varun
>> >>>
>> >>> On Thu, Sep 25, 2014 at 6:06 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> >>>> On Thu, Sep 25, 2014 at 03:53:13PM +0530, VARUN BHATIA wrote:
>> >>>>> The mask kept is /16, I placed wrong information correcting it:
>> >>>>>
>> >>>>>                   Host A                                      Host B
>> >>>>> Primary    10.204.200.200                          10.204.100.100
>> >>>>> Secondary 10.205.200.200                         10.205.100.100
>> >>>>>
>> >>>>> We are having our customized linux.
>> >>>>>
>> >>>>> ip neigh list
>> >>>>> fe80::224:13ff:fe45:ced4 dev eth3 lladdr 00:24:13:45:ce:d4 router STALE
>> >>>>> fe80::224:13ff:fe45:ced5 dev eth0 lladdr 00:24:13:45:ce:d5 router STALE
>> >>>>> 10.205.100.100 dev eth3 lladdr 00:0b:ab:55:57:01 REACHABLE
>> >>>>>
>> >>>>> I tried for a workaround and played with nat rules:
>> >>>>>
>> >>>>> iptables -t nat -I POSTROUTING -o eth2 -d 10.204.100.100 -j SNAT -p
>> >>>>> sctp --to 10.204.200.200
>> >>>>> iptables -t nat -I POSTROUTING -o eth3 -d 10.205.100.100 -j SNAT -p
>> >>>>> sctp --to 10.205.200.200
>> >>>>>
>> >>>>> After this it started working though it is not the correct solution,
>> >>>>> but yet after this it seems due to some conntrack table entries when I
>> >>>>> receive request from peer end it is not working proparly:
>> >>>>>
>> >>>>>   3.484280 10.205.200.200 -> 10.205.100.100 SCTP 98 INIT
>> >>>>>   3.488652 10.205.100.100 -> 10.205.200.200 SCTP 354 INIT_ACK
>> >>>>>   3.488706 10.205.200.200 -> 10.205.100.100 SCTP 310 COOKIE_ECHO
>> >>>>>   3.488923 10.205.100.100 -> 10.205.200.200 SCTP 60 COOKIE_ACK
>> >>>>>
>> >>>>>   3.497282 10.205.200.200 -> 10.205.100.100 SCTP 62 SACK
>> >>>>>
>> >>>>>   6.512476 10.205.100.100 -> 10.205.200.200 SCTP 98 INIT
>> >>>>>   6.512575 10.204.200.200 -> 10.205.100.100 SCTP 354 INIT_ACK
>> >>>>>
>> >>>>>  21.240776 10.205.100.100 -> 10.205.200.200 SCTP 310 COOKIE_ECHO
>> >>>>>  21.240866 10.204.200.200 -> 10.205.100.100 SCTP 50 COOKIE_ACK
>> >>>>>  21.242183 10.205.100.100 -> 10.205.200.200 SCTP 60 SHUTDOWN
>> >>>>>  21.242237 10.205.200.200 -> 10.205.100.100 SCTP 50 SHUTDOWN_ACK
>> >>>>>  21.242353 10.205.100.100 -> 10.205.200.200 SCTP 60 SHUTDOWN_COMPLETE
>> >>>>>
>> >>>>> When peer end sends INIT my box again send INIT_ACK using primary ip
>> >>>>> address simlarly for COOKIE_ACK also, but SHUTDOWN ACK it is sending
>> >>>>> correct.
>> >>>>>
>> >>>>> Not sure what I am missing here, kindly provide your inputs on this ?
>> >>>>>
>> >>>>> Thanks,
>> >>>>> Varun
>> >>>>>
>> >>>>
>> >>>> This is working as designed.  Since both your host addresses are on the same
>> >>>> subnet, and since ip addresses are owned by the system in linux, not the
>> >>>> interface, its not really relevant which source address is used.  If you want to
>> >>>> force source ip addresses to be used for the interface you are sending from,
>> >>>> you'll want to add higher priority routes that specify the src address.
>> >>>>
>> >>>> Neil
>> >>>>
>> >>>
>> >>>
>> >>>
>> >>
>> >
>> >
>> >
>> > --
>> > Regards,
>> > Varun Bhatia
>>
>>
>>
>> --
>> Regards,
>> Varun Bhatia
>>



-- 
Regards,
Varun Bhatia
