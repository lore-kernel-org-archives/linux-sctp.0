From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 02 May 2014 13:35:55 +0000
Subject: Re: SCTP throughput does not scale
Message-Id: <20140502133555.GE15335@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E333BF5@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E333BF5@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, May 02, 2014 at 11:45:00AM +0000, Butler, Peter wrote:
> I have tested with /proc/sys/net/sctp/[snd|rcv]buf_policy set to 0 and to 1.  I get the same behaviour both ways.  Note that my associations are all TCP-style SOCK_DGRAM associations, and not UDP-style SOCK_SEQPACKET associations.  As such, each association has its own socket - rather than all the associations sharing a single socket - and thus, to my understanding, the parameters in question will have no effect (as my testing has shown).  
> 
You're correct, if you're using TCP style associations, the above policies won't
change much.

Such consistent throughput sharing though still seems odd.  You don't have any
traffic shaping or policing implimented on your network devices do you?  Either
on your sending or receiving system?  tc qdisc show would be able to tell you.
Such low throughput on a 10G interface seems like it could not be much other
than that.  Are you seeing any droped frames in /proc/net/sctp/snmp or in
/proc/net/snmp[6]?

Neil

