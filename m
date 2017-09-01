From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 01 Sep 2017 13:32:52 +0000
Subject: Re: Question on sctp state machine
Message-Id: <20170901133252.GA4110@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAPOWuK88cyT8Ui_8va+J9VqsWZ_jS=NNy9S8GBvBt5qt5a9SwA@mail.gmail.com>
In-Reply-To: <CAPOWuK88cyT8Ui_8va+J9VqsWZ_jS=NNy9S8GBvBt5qt5a9SwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Aug 31, 2017 at 11:25:16PM -0700, amar padmanabhan wrote:
> Hi all,
> I am trying to create a simpler repro for an issue where an
> association lingers/leaks and am observing something that I fully
> don't fully follow:
> 
> Scenario:
> Client initiates 4 way handshake completes it, sends some user data,
> dies, reinitiates the 4 way handshake, completes sends some user data
> dies. Repeat forever.
> Server is running all through.
> 
Are you forcing that connection failure?  Or is it happening on its own?  I'm
trying to figure out where the ICMP proto unreachable messsages are originating
from.  Its sort of an odd ICMP code to hit.

> In the attached pcap the third INIT gets an INIT ACK but the COOKIE
> ECHO doesn't get a corresponding COOKIE_ACK response from the server.
> The only thing I see here is that the initiate tag is the same between
> the second and third run.
That suggests to me that we're considering this an unexpected init, and
processing it as such in sctp_sf_do_unexpected_init, by creating a new
association and copying over the tags.  Then we handle the cookie in
sctp_sf_do_5_2_4_dupcook and silently discard it for one of several reasons.
I'd suggest writing a stap script to probe the return and error value of
sctp_unpack_cookie to see how the last cookie is getting handled.

Neil


> Please find the trace in the attached pcap. The post handshake
> exchange can be ignored for the most part.
> 
> vagrant@magma-dev:~$ uname -a
> Linux magma-dev 4.9.0-0.bpo.1-amd64 #1 SMP Debian 4.9.2-2~bpo8+1
> (2017-01-26) x86_64 GNU/Linux
> 
> Thanks
> Amar


