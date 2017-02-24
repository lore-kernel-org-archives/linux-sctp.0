From: "Jonathan T. Leighton" <jtleight@udel.edu>
Date: Fri, 24 Feb 2017 02:52:25 +0000
Subject: Re: netinet/sctp.h or linux/sctp.h?
Message-Id: <f6c7d7ea-f8f7-d0f8-7d32-0ef1e729e68b@udel.edu>
List-Id: <linux-sctp.vger.kernel.org>
References: <333c3b86-5715-b8e7-5b7d-36051456ffdd@udel.edu>
In-Reply-To: <333c3b86-5715-b8e7-5b7d-36051456ffdd@udel.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 2/23/17 5:42 PM, Jonathan T. Leighton wrote:
> I typically include netinet/sctp.h, but I've noticed that linux/sctp.h
> contains some definitions that are not in netinet/sctp.h and which give
> me access to a few additional socket options, such as SCTP_RECVRCVMSG.
> Why does netinet/sctp.h not contain definitions for a few of the options
> that the kernel supports?
>
> - Jon

Ah - I think it's because I'm running a pre-release kernel. Is there a 
way to get a corresponding pre-release for libsctp-dev (currently at 
1.0.16+dfsg-3)? My linux kernel is 4.10.0-rc6+.

- Jon
