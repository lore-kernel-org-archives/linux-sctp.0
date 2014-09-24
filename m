From: Varun Bhatia <varuninbharti@gmail.com>
Date: Wed, 24 Sep 2014 15:54:35 +0000
Subject: Re: SCTP Multihoming Always sending primary interface ip I
Message-Id: <7ACBFD95-A2A3-47BB-9E8C-6A567F110907@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
In-Reply-To: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Thanks Vlad for your response but they are already on different subnets :(

Sent from Iphone,
Varun

> On 24-Sep-2014, at 18:36, Vlad Yasevich <vyasevich@gmail.com> wrote:
> 
>> On 09/24/2014 08:56 AM, VARUN BHATIA wrote:
>> Hi,
>> 
>> We have developed multihomed application now while testing my setup is:
>> 
>> Eth4  as primary interface connected back to back to another machine.
>> Eth5 as secondary interface connected back to back to another machine.
>> 
>> I make my porimary interface down now when the INIT is been sent it
>> reaches to peer machine seems using secondary interface but the source
>> ip address kept is of primary interface only due to which when peer
>> machine tries to respond INIT_ACK it tries to send on primary
>> interface ip which is down and due to ICMP it drops the packet.
>> 
>> I am not too good in Routing but it seems that some routing has not
>> been configuered properly, why is it always using primary ip ?
>> 
>> I have tested the same part when I have connected my primary &
>> secondary interface through router but facrd the same issue.
>> 
>> Any inputs are appreciated as I am stuck in it since last 2 days.
>> 
> 
> Try to put the 2 interfaces into 2 different subnets.  That should fix
> your issue.  If you can't do that,  then you'd have to play with arp_ignore
> and arp_announce sysctl values to make it do what you want.
> 
> -vlad
