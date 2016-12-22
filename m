From: amar padmanabhan <amarpad@gmail.com>
Date: Thu, 22 Dec 2016 17:39:53 +0000
Subject: Re: Lingering associations on the server side after process dies
Message-Id: <CAPOWuK8w6bdNjXJG3_Wz6C4j8up63jN7GVJ1TcEfAc=mmw94wg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAPOWuK_mteeYoZyK6QGb6NK=-Rgs9djFUUoh+LGPH7J7zETzOQ@mail.gmail.com>
In-Reply-To: <CAPOWuK_mteeYoZyK6QGb6NK=-Rgs9djFUUoh+LGPH7J7zETzOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

ok yeah thanks!, I seem to be hitting this often enough by crashing
the application server, let me try to put together a minimal
reproducer
- Amar

On Thu, Dec 22, 2016 at 9:17 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Wed, Dec 21, 2016 at 11:11:46PM -0800, amar padmanabhan wrote:
>> I am trying to figure out an issue where after a process crash
>> associations are lingering.
>>
>> On the server:
>> vagrant@magma-dev:~/build/oai_sgw$ sudo cat /proc/net/sctp/assocs
>>  ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
>> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC wmema
>> wmemq sndbuf rcvbuf
>> ffff8800b58c7000 ffff8800da4d0bc0 2   1   3  0       9        0
>> 0       0     0 36412 36412  192.168.60.142 <-> *192.168.60.141
>> 7500     3     8   10    0    7        0        1        0   212992
>> 212992
>>
>> sudo lsof | grep ffff8800da4d0bc0
>>
>> after the application server restarts the client retries with INIT and
>> COOKIE_ECHO and the server replies back with INIT_ACK and COOKIE_ACK
>> without any notification to the application server and any subsequent
>> request from the client is not seen on the server.
>
> Sounds like the asoc leaked. It's lingering, maybe waiting for
> something to complete or simply leaked.
> Thus, when the client issues a new INIT, it's actually this old asoc
> that is catching and replying it, and not the new server process, so it
> doesn't/can't see the new request.
>
>>
>> Some pointers would be useful
>> 1. Why can't I see the socket in lsof.
>
> Not sure.
>
>> 2. How do I shutdown the existing association, so the server can
>> rebuild the state on the associations, and restart cleanly.
>
> We should confirm if it's really leaked, and fix the leak instead.
>
> The proc output above contains wmema: 1, probably comes from a
> sctp_packet_set_owner_w() call, indicating a sk_buff is still live and
> holding the asoc.
>
> We had similar issues in recent past but they should be fixed in the
> kernel you're using. They were related to error handling situations.
>
> Can you try to come with a minimal reproducer for this?
>
>>
>> vagrant@magma-dev:~/build/oai_sgw$ uname -a
>> Linux magma-dev 4.7.4-040704-generic #201609150330 SMP Thu Sep 15
>> 07:32:22 UTC 2016 x86_64 GNU/Linux
>>
>> vagrant@magma-dev:~/build/oai_sgw$ sudo modinfo sctp
>> filename:       /lib/modules/4.7.4-040704-generic/kernel/net/sctp/sctp.ko
>> license:        GPL
>> description:    Support for the SCTP protocol (RFC2960)
>> author:         Linux Kernel SCTP developers <linux-sctp@vger.kernel.org>
>> alias:          net-pf-10-proto-132
>> alias:          net-pf-2-proto-132
>> depends:        libcrc32c
>> intree:         Y
>> vermagic:       4.7.4-040704-generic SMP mod_unload modversions
>> parm:           no_checksums:Disable checksums computing and verification (bool)
>>
>> The code can be found here:
>> https://gitlab.eurecom.fr/oai/openair-cn/blob/develop/SRC/SCTP/sctp_primitives_server.c#L352
>>
>> Thanks
>> Amar
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
