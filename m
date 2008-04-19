From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sat, 19 Apr 2008 06:13:23 +0000
Subject: Re: [Lksctp-developers] A lot of socket api work needs to be done.
Message-Id: <48098D83.50402@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi All:

Vlad Yasevich wrote:
> Hi  All
>
> We are severely lacking in our implementation of the socket API and I'd like to revitalize
> the effort to get this updated.
>
> Note:  I am ignoring the AUTH pieces since I've had this implemented, but have been
> waiting for the API to stabilize.
>
> As such, the following is a set of sections that need to be implemented:
>
> 	5.2.2. SCTP Header Information Structure (SCTP_SNDRCV)	
> 		- SCTP_SENDALL will require reworking how we copy data from
>
> 	5.2.3.  Extended SCTP Header Information Structure
>
> 	7.1.26. Set or Get the use of extended receive info SCTP_USE_EXT_RCVINFO)
>
> 	7.1.23. Get or set delayed ack timer (SCTP_DELAYED_SACK)
>   
Is anyone doing about this one? If nobody do this, I'd link to take it.

BTW: This one is need to be updated to latest spec,  no to be 
implemented, is this right?
I see some code in the kernel code as that:

7.1.23. Delayed Ack Timer (SCTP_DELAYED_ACK_TIME)

static int sctp_setsockopt_delayed_ack_time()

static int sctp_getsockopt_delayed_ack_time()


> 	7.1.27. Set or Get the auto asconf flag (SCTP_AUTO_ASCONF)
> 	
> 	7.1.30. Enable or disable explicit EOR marking (SCTP_EXPLICIT_EOR)
>
> 	7.1.31. Enable SCTP port reusage (SCTP_REUSE_PORT)
>
> 	8.11. sctp_sendx()
>
>
> Also, the following need to be updated to conform to the latest spec:
>
> 	3.1.4.  sendmsg() and recvmsg() - one-to-many style socket
> 		- need to handle new text wrt NULL data with SCTP_ flags.
>
> 	5.2.2. SCTP Header Information Structure (SCTP_SNDRCV)
> 		- update for Partial Reliability extensions
> 		 
>
> 	7.1.13. Peer Address Parameters (SCTP_PEER_ADDR_PARAMS)
>         	- need flowlable and tos implementation.
>
> 	7.1.24. Get or set fragmented interleave (SCTP_FRAGMENT_INTERLEAVE)
> 		- specifically Level 2 interleave.  (note, this is a lot of work).
>
> 	7.1.28. Set or Get the maximum burst (SCTP_MAX_BURST)
> 		- new data structure.
>
> 	8.9. sctp_connectx()
> 		- updated argument list.
>
> I am looking for volunteers to take up line items from the above.  I would really like to
> get this most of this work submitted to 2.6.26.
>
> If you have the time to work on one of the above times, please drop a note to the list
> saying what you are working on so we don't have duplicated effort.
>
> Thanks
> -vlad
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Lksctp-developers mailing list
> Lksctp-developers@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>
>
>   


-- 
--------------------------------------------------
Wei Yongjun
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
8/F., Civil Defense Building, No.189 Guangzhou Road,
Nanjing, 210029, China
TEL: +86+25-86630523-836
COINS: 79955-836
FAX: +86+25-83317685
MAIL: yjwei@cn.fujitsu.com
--------------------------------------------------
This communication is for use by the intended recipient(s) only and may contain information that is privileged, confidential and exempt from disclosure under applicable law. If you are not an intended recipient of this communication, you are hereby notified that any dissemination, distribution or copying hereof is strictly prohibited.  If you have received this communication in error, please notify me by reply e-mail, permanently delete this communication from your system, and destroy any hard copies you may have printed

