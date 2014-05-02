From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Fri, 02 May 2014 17:10:26 +0000
Subject: RE: SCTP throughput does not scale
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E334939@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E333BF5@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E333BF5@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

[root@slot2 ~]# tc -s qdisc show
qdisc netem 8002: dev p19p2 root refcnt 65 limit 1000 delay 25.0ms
 Sent 590200 bytes 7204 pkt (dropped 0, overlimits 0 requeues 0) 
 backlog 0b 0p requeues 0 
qdisc netem 8001: dev p19p1 root refcnt 65 limit 1000 delay 25.0ms
 Sent 997332352 bytes 946411 pkt (dropped 478, overlimits 0 requeues 1) 
 backlog 114b 1p requeues 1 


[root@slot3 ~]# tc -s qdisc show
qdisc netem 8002: dev p19p2 root refcnt 65 limit 1000 delay 25.0ms
 Sent 90352 bytes 1666 pkt (dropped 0, overlimits 0 requeues 0) 
 backlog 0b 0p requeues 0 
qdisc netem 8001: dev p19p1 root refcnt 65 limit 1000 delay 25.0ms
 Sent 29544962 bytes 475167 pkt (dropped 0, overlimits 0 requeues 2) 
 backlog 130b 1p requeues 2




-----Original Message-----
From: Vlad Yasevich [mailto:vyasevich@gmail.com] 
Sent: May-02-14 1:07 PM
To: Butler, Peter; Neil Horman
Cc: linux-sctp@vger.kernel.org
Subject: Re: SCTP throughput does not scale

On 05/02/2014 12:33 PM, Butler, Peter wrote:
> The only entries from "tc qdisc show" are the ones used to implement the 50 ms RTT, which applies to all packet types (not just SCTP).
> 

I am assuming that you are using netem.  What is the queue length?
What is the output of
 # tc -s qdisc show

look like.

Thanks
-vlad

> As for dropped frames, are you referring to SctpInPktDiscards?    SctpInPktDiscards is zero or very small (compared to the total number of transmitted packets).  For example, starting with all stats in /proc/net/sctp/snmp zeroed out, and then running one minute's worth of traffic with the same setup (50 ms RTT, 1000-byte messages, 2 MB tx/rx buffer size) I get the following data in /proc/net/sctp/snmp when running two parallel associations (only relevant lines shown here):
> 
> client side (sending DATA):
> SctpOutSCTPPacks                        938945
> SctpInSCTPPacks                         473209
> SctpInPktDiscards                       0
> SctpInDataChunkDiscards                 0
> 
> 
> server side (receiving DATA):
> SctpOutSCTPPacks                        473209
> SctpInSCTPPacks                         938457
> SctpInPktDiscards                       0
> SctpInDataChunkDiscards                 0
> 
> 
> 
> -----Original Message-----
> From: linux-sctp-owner@vger.kernel.org 
> [mailto:linux-sctp-owner@vger.kernel.org] On Behalf Of Neil Horman
> Sent: May-02-14 9:36 AM
> To: Butler, Peter
> Cc: linux-sctp@vger.kernel.org
> Subject: Re: SCTP throughput does not scale
> 
> On Fri, May 02, 2014 at 11:45:00AM +0000, Butler, Peter wrote:
>> I have tested with /proc/sys/net/sctp/[snd|rcv]buf_policy set to 0 and to 1.  I get the same behaviour both ways.  Note that my associations are all TCP-style SOCK_DGRAM associations, and not UDP-style SOCK_SEQPACKET associations.  As such, each association has its own socket - rather than all the associations sharing a single socket - and thus, to my understanding, the parameters in question will have no effect (as my testing has shown).  
>>
> You're correct, if you're using TCP style associations, the above policies won't change much.
> 
> Such consistent throughput sharing though still seems odd.  You don't have any traffic shaping or policing implimented on your network devices do you?  Either on your sending or receiving system?  tc qdisc show would be able to tell you.
> Such low throughput on a 10G interface seems like it could not be much other than that.  Are you seeing any droped frames in /proc/net/sctp/snmp or in /proc/net/snmp[6]?
> 
> Neil
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
> 

