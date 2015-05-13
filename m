From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Wed, 13 May 2015 05:55:18 +0000
Subject: Re: Checksum at INIT ACK.
Message-Id: <F0EBF5C3-EAD5-48DA-923B-F5FCA5AE888F@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <FF69E842-A2CC-4870-9894-D355FFE80086@gmail.com>
In-Reply-To: <FF69E842-A2CC-4870-9894-D355FFE80086@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 13 May 2015, at 04:14, Moohyoung KIM <emusal@gmail.com> wrote:
> 
> Dear all,
> 
> I am currently trying to make an association with otter vendor's system. but it is failed.
> The engineer of peer side requests me to set checksum parameter into INIT Ack. message we sent.
> 
> Q1. is it possible to differently set checksum value for each associations on linux-sctp?
> Q2-1. If it is possible to set checksum separately, how to set the flag either use or not?
> Q2-2. If it is NOT possible, we MUST turn the checksum feature on for whole association? how to do that? I am using lksctp-1.0.10-7 on Linux 2.6.32-432 (RHEL6).
SCTP only uses CRC32c as the checksum and it is mandatory to use it. There is no
"checksum parameter" for negotiating it.
Does your peer still use the deprecated Adler32? It has been changed to CRC32c in
https://tools.ietf.org/html/rfc3309
The updated SCTP specification
https://tools.ietf.org/html/rfc4960
doesn't mention Adler32 anymore.

Best regards
Michael
> 
> Thanks--
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

