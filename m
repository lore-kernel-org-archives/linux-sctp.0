From: Neil Horman <nhorman@tuxdriver.com>
Date: Sat, 05 Jul 2014 13:03:49 +0000
Subject: Re: Ooops with SCTP
Message-Id: <20140705130349.GA14710@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140705001606.GA29369@obsidianresearch.com>
In-Reply-To: <20140705001606.GA29369@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jul 04, 2014 at 06:16:06PM -0600, Jason Gunthorpe wrote:
> Hello All,
> 
> I've recently started doing some work with SCTP and noticed a few
> bugs, the worst being a kernel oops.
> 
>  1) Requesting COOKIE_ACK to be auth'd but not COOKIE_ECHO (or vice
>     versa) caused an immediate panic in a IRQ context, 'go reboot your
>     machine' with sctp traceback. I would need to setup in a VM to
>     capture the oops text..

Do you have the panic backtrace?

>  2) SCTP_I_WANT_MAPPED_V4_ADDR returns a 0 AF_INET6 for all IPv4
>     addresses, looking at the code I think the functionality is just
>     not implemented?
No, its implemented, not sure why you would get a 0 address here.

>  3) Using auth on COOKIE_ECHO and COOKIE_ACK and combining that with
>     peer-peer connection does not seem to work. If the peers collide
>     the handshake never completes. Works if the peers do not collide.
> 
>   1   0.000000   10.0.0.161 -> 10.0.0.177   SCTP 174 INIT 
>   5   1.037194   10.0.0.177 -> 10.0.0.161   SCTP 146 INIT 
>   6   1.037313   10.0.0.161 -> 10.0.0.177   SCTP 494 INIT_ACK 
>   7   1.037649   10.0.0.177 -> 10.0.0.161   SCTP 402 AUTH COOKIE_ECHO 
>   8   3.003226   10.0.0.161 -> 10.0.0.177   SCTP 174 INIT 
>   9   3.003588   10.0.0.177 -> 10.0.0.161   SCTP 466 INIT_ACK 
>  10   3.003641   10.0.0.161 -> 10.0.0.177   SCTP 402 AUTH COOKIE_ECHO 
>  11   4.042864   10.0.0.177 -> 10.0.0.161   SCTP 402 AUTH COOKIE_ECHO 
>  12   6.011268   10.0.0.161 -> 10.0.0.177   SCTP 402 AUTH COOKIE_ECHO 
> 
>     I see in the RFCs there is a corner case here in how to choose the
>     proper keying material.
> 
> If there is someone out there interested in these things I can
> probably provide code to reproduce?
> 
> Thanks,
> Jason
> 
