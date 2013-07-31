From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 31 Jul 2013 13:36:37 +0000
Subject: Re: Association issue.
Message-Id: <51F912E5.5080701@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
In-Reply-To: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 07/31/2013 01:03 AM, Vipul Singhania wrote:
> Thanks for reply.
>
> There is no firewall in that network. This is just separate network.
> and I can say they are directly connected to each other using L1
> switch and no other connection to outside world.
>
> It was jut testing that I have giving public IP to one of interface in one host.
>
> - The association look like with public IP.
>
> sh-3.2# cat /proc/net/sctp/assocs
>   ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
> ffff8800089b0000 ffff8800335944c0 2   1   3  37916    3      516
>   0       0 10635 48520  7168  127.3.253.1 127.3.21.1 127.4.253.1
> 127.2.253.1 127.1.221.1 164.48.1.1 127.3.254.1 <-> *127.4.252.1
>   7500   300   300   10    0    0        0
> ffff8800089b2000 ffff880033594000 2   1   3  50717    4      516
>   0       0 10634 60890  7169  127.3.253.1 127.3.21.1 127.4.253.1
> 127.2.253.1 127.1.221.1 164.48.1.1 127.3.254.1 <-> *127.4.252.1
>   7500   300   300   10    0    0        0
>
> -----------------------------------------------------------------------------
> - But if I give private IP (10.1.1.1) this look like.
>
> sh-3.2# cat /proc/net/sctp/assocs
>   ASSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
> ffff88003c721800 ffff8800335944c0 2   1   3  22045    2        0
>   0       0  5674 47434  7169  127.3.253.1 127.3.21.1 127.4.253.1
> 127.2.253.1 127.1.221.1 <-> *127.4.252.1         7500   300   300   10
>     0    0        0
> ffff88003c720800 ffff880033594000 2   1   3  36124    1        0
>   0       0  5673 58513  7168  127.3.253.1 127.3.21.1 127.4.253.1
> 127.2.253.1 127.1.221.1 <-> *127.4.252.1         7500   300   300   10
>     0    0        0
>
>
> - I may be wrong but is it possible that when we do bind with on IP
> (and if multi homing is enabled) it'll build with all available
> interfaces?

Try this test after you do:
	echo "2" > /proc/sys/net/sctp/addr_scope_policy

The default policy will not use private addresses if global ones are 
available.

-vlad

>
> Please forgive if I ask stupid question. First time I am doing network
> programing and trying to learn this.
>
>
> On Tue, Jul 30, 2013 at 6:36 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> On Tue, Jul 30, 2013 at 04:52:52PM +0530, Vipul Singhania wrote:
>>> Hi All,
>>>
>>>
>>> I have one test case in which I have 2 interfaces on each machine (two hosts).
>>>
>>> One is working as server and one is as client.
>>>
>>> If in server I make one interface as public (IP address 164.x.x.x)
>>> then the server sends reset to the client).
>>>
>>> So question is does SCTP support association between public to private
>>> range IP address?
>>>
>> Sort of, SCTP will gladly use any available ip address in the establishment of an
>> association.  That said, you do need to take care that your firewalls aren't
>> going to mess with those addresses. That is to say, if you have an address that
>> is 'private' in the sense that it is behind a nat firewall, you will likely get
>> a reset from the use of that address, because the peer will see connections from
>> that address as comming from the public natted address, which was not in the
>> association init chunk, hence the abort.
>> Neil
>>
>>>
>>> Thanks in advance.
>>> --
>>> -=vipsy
>>> http://through-dlens.blogspot.in
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
>
>

