From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 19 Dec 2013 14:26:26 +0000
Subject: Re: undetected closed apps
Message-Id: <52B30212.5000607@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/18/13 12:58, Vlad Yasevich wrote:
> On 12/18/2013 07:30 AM, Jamal Hadi Salim wrote:

> could you post an output for /proc/net/sctp/assocs for the association
> in this bad state?

It's not eye candy (lines wrap around). But here's one i just
reproduced with client/server on same machine via lo. It requires
a few tries to make sure we have send failed for this to happen.

----
SSOC     SOCK   STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE 
LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC wmema 
wmemq sndbuf rcvbuf
        0        0 2   7   4  29808   11        0        0       0     0 
50902 30330  127.0.0.1 10.0.0.195 192.168.122.1 <-> *127.0.0.1      7500 
    10    10   10    0    0        0        1        0   212992   212992
        0        0 2   1   3  31695   12        0        0    1000 55928 
30330 50902  127.0.0.1 <-> *127.0.0.1 10.0.0.195 192.168.122.1      1500 
    10    10   10    0    0        0        1        0   212992   212992
---------

Server is at port 30330.

Actually i take back what i said earlier: When i write to this app, 
after it disconnects, i do see the socket queues grow for a short
period and then get drained to zero. I dont know where those messages
go. I monitor this by having the watch utility polling every second.

cheers,
jamal
