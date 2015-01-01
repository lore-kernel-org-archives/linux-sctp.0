From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 01 Jan 2015 13:23:04 +0000
Subject: Re: SCTP Compliance
Message-Id: <54A54A38.7000402@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Peter,

On 12/15/2014 10:26 PM, Butler, Peter wrote:
> I am looking for a formal LKSCTP compliance statement.  Is there one?

You may want to try out [1] for a partial answer to your question.
The test cases are mostly related to RFC4960 itself, though. Other
than that, RFC3758 is not yet implemented, the rest certainly has
some form of implementation in the stack, but a formal 100%-compliance
statement wrt the RFC, I cannot tell/make right now.

Thanks,
Daniel

> Is LKSCTP 100% compliant with the following?
>
>      RFC 2960 - SCTP (obsoleted by RFC 4960)
>      RFC 3309 - SCTP Checksum Change (obsoleted by RFC 4960)
>      RFC 3758 - SCTP Partial Reliability Extension
>      RFC 3873 - SCTP MIB
>      RFC 4460 - SCTP Errata and Issues
>      RFC 4895 - Authenticated Chunks for SCTP
>      RFC 4960 - SCTP
>      RFC 5061 - SCTP Dynamic Address Reconfiguration
>      RFC 5062 - Security Attacks Against SCTP

   [1] http://networktest.sourceforge.net/overview.html
