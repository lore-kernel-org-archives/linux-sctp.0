From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 19 Dec 2013 17:24:09 +0000
Subject: Re: undetected closed apps
Message-Id: <52B32BB9.9020102@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/19/2013 09:26 AM, Jamal Hadi Salim wrote:
> On 12/18/13 12:58, Vlad Yasevich wrote:
>> On 12/18/2013 07:30 AM, Jamal Hadi Salim wrote:
> 
>> could you post an output for /proc/net/sctp/assocs for the association
>> in this bad state?
> 
> It's not eye candy (lines wrap around). But here's one i just
> reproduced with client/server on same machine via lo. It requires
> a few tries to make sure we have send failed for this to happen.
> 
> ----
> SSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE
> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC wmema
> wmemq sndbuf rcvbuf
>        0        0 2   7   4  29808   11        0        0       0     0

So, on this line socket state (SST) is 7 which is SCTP_SS_CLOSED.  This
means that you performed a close() call.  The association state (ST) is
4 which is SHUTDOWN_PENDING.  This means that when you tried to close
the socket, the association thought that there was some pending data.

I seem to remember you and I discussing this situation before, but I
can't find that thread.

I'll take another look at how PR interacts with queue state to see if
we can detect the proper empty state to send a SHUTDOWN.

However, what the above tells me is that you don't actually set
SO_LINGER on this socket.  If you did, instead of attempting SHUTDOWN,
we would have sent an abort.  That might be a good workaround until
we solve this "queue empty" problem.

-vlad

> 50902 30330  127.0.0.1 10.0.0.195 192.168.122.1 <-> *127.0.0.1      7500
>    10    10   10    0    0        0        1        0   212992   212992
>        0        0 2   1   3  31695   12        0        0    1000 55928
> 30330 50902  127.0.0.1 <-> *127.0.0.1 10.0.0.195 192.168.122.1      1500
>    10    10   10    0    0        0        1        0   212992   212992
> ---------
> 


> Server is at port 30330.
> 
> Actually i take back what i said earlier: When i write to this app,
> after it disconnects, i do see the socket queues grow for a short
> period and then get drained to zero. I dont know where those messages
> go. I monitor this by having the watch utility polling every second.
> 
> cheers,
> jamal

