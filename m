From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 03 Dec 2014 11:30:33 +0000
Subject: Re: wrong family for IP addresses given by sctp library
Message-Id: <547EF459.9000804@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 12/03/2014 12:25 PM, Michael Tuexen wrote:
> On 03 Dec 2014, at 11:50, Boiteux Frederic <fboiteux@prosodie.com> wrote:
>
>>           Hello,
>>
>> I'm trying to use SCTP on Linux machines with 'old' kernels (Debian 5, 2=
.6.26 kernel and Debian 7, 3.2 kernel). I've setup a program which can hand=
les IPv4 and IPv6 addresses, and for that, I use a socket with AF_INET6 fam=
ily, then I bind it to IPv4 or v6 addresses with sctp_bindx() (its manual p=
age says this call can handle both v4 and v6 adresses if the socket is an I=
Pv6 one).
>> It seems to work well, but I have a strange behavior : on a test platfor=
m with only IPv4 addresses, when I get messages or notifications (using sct=
p_recvmsg()), the addresses given in it (IP address of the sender, or confi=
rmation/fail of some peer addresses) are always from the IPv6 family !
> Is it possible that the address are mapped V4 addresses?

Hmm, Frederic, could you try with a current kernel? We've had fixes
in the past such as ...

commit 299ee123e19889d511092347f5fc14db0f10e3a6
Author: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date:   Wed Jul 30 12:40:53 2014 -0600

     sctp: Fixup v4mapped behaviour to comply with Sock API

> Best regards
> Michael
>> For example, for received messages, the =AB from =BB socket address retu=
rned by sctp_recvmsg() has always a sa_family field to AF_INET6, even if th=
e address is in fact an IPv4 address ! Using getnameinfo() with NI_NUMERICH=
OST option, I  can get the ascii representation of the address, a 4 dotted =
address, and then I have to fix the address to use it with its real family =
(as I expected to receive).
>> It seems to be directly related to the AF_INET6 family of the socket, bu=
t I don't know if it' s a known problem, possibly fixed since then in lates=
t linux-sctip library, or probably a programmatic error from me.
>>
>>   Have you ever heard for such problem ? What is your feeling about ?
>>
>> 	With regards,
>>                       Fred.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
