From: "Frank Ch. Eigler" <fche@redhat.com>
Date: Thu, 06 Dec 2012 21:39:35 +0000
Subject: Re: Possible SCTP peer receive window bug
Message-Id: <20121206213935.GB15562@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
In-Reply-To: <B1BF0D5B21C20F4D8AE9BB4366C9BFCA6D387197@ENFIRHMBX1.datcon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi -

Jamie.Parsons (@UNKNOWN_DOMAIN :-() wrote:

> [...] There is still a bug in the system tap script as the exit
> value of functions is always returned as the same as the entry value
> to functions.  [...]

This is an occasionally confusing aspect of systemtap .return probes.
As per the stapprobes man page and elsewhere, most $context variables
accessed from .return probes represent function *entry-time snapshots*.

Try instead use of the @entry() construct, which makes explicit
which values you wish to be entry-time evaluated, and which later.

probe module("sctp").function("sctp_process_init").return {
     printf("sctp_process_init updates assoc %p peer rwnd to %d\n", 
     @entry($asoc), 
     @cast(@entry($asoc),"sctp_association")->peer->rwnd);
     /* evaluated at .return time:          ^^^^^^^^^^^^ */
}

(http://sourceware.org/PR14437 should make the @cast unnecessary
eventually.)

- FChE
