From: "Bibhuti Bhusan Tosh" <bibhuti.tosh@nethawkgroup.com>
Date: Thu, 30 Apr 2009 06:06:54 +0000
Subject: RE: [Lksctp-developers] Regarding SCTP_DELAYED_ACK_TIME
Message-Id: <97EB51EB8AEF4D4D83F9D9BA58DA502E@nethawk.fi>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

HI All

Please let me know which version of linux and lksctp-tools is currently
supporting this SACK timer customisation?

Best Regards,
--Bibhuti


-----Original Message-----
From: Vlad Yasevich [mailto:vladislav.yasevich@hp.com] 
Sent: Wednesday, April 29, 2009 5:59 PM
To: Padmalochan Moharana
Cc: linux-sctp@vger.kernel.org; lksctp-developers@lists.sourceforge.net
Subject: Re: [Lksctp-developers] Regarding SCTP_DELAYED_ACK_TIME

Padmalochan Moharana wrote:
> Hello,
> 
> In my application I have tried to set the SACK timer to 400 Milli 
> second by writing following code.
> 
> struct sctp_assoc_value sack_timer ;
> bzero(&sack_timer, sizeof(sack_timer)); sack_timer.assoc_id =1 ; 
> sack_timer.assoc_value = 400 ; int res = setsockopt(socketFD, 
> IPPROTO_SCTP, SCTP_DELAYED_ACK_TIME, &sack_timer,sizeof(struct 
> sctp_assoc_value ));
> 
> But setsockopt() returns error ("Protocol not available").
> 
> The kernel version i have used is : 2.6.9-55.EL lksctp version: 1.0.8

This kernel does not support the socket option you are trying to use.
You need to upgrade the kernel.

-vlad

> 
> Please let me know how can i set SCTP_DELAYED_ACK_TIME value in my
application.
> 
> Br,
> Padmalochan
> 


----------------------------------------------------------------------------
--
Register Now & Save for Velocity, the Web Performance & Operations
Conference from O'Reilly Media. Velocity features a full day of expert-led,
hands-on workshops and two days of sessions from industry leaders in
dedicated Performance & Operations tracks. Use code vel09scf and Save an
extra 15% before 5/3. http://p.sf.net/sfu/velocityconf
_______________________________________________
Lksctp-developers mailing list
Lksctp-developers@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/lksctp-developers

