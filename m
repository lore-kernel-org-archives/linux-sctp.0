From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 17 Jan 2017 16:38:39 +0000
Subject: Re: Issue with Forward-TSN-Chunks containing high cum_tsn
Message-Id: <20170117163839.GK3781@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117130752.GB6494@aomx-netbook>
In-Reply-To: <20170117130752.GB6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jan 17, 2017 at 02:07:52PM +0100, Julian Cordes wrote:
> When a FORWARD-TSN-Chunk with a relative high cum-tsn-value is injected
> then the linux kernel ignores this valid FORWARD-TSN-Chunk.
> It should instead send an SACK-Chunk where the cum_tsn is equal to the
> cum_tsn specified in the FORWARD-TSN.

You mean, with the cum_tsn specified on the *injected* FORWARD-TSN.
Is that so?

> 
> Testscript available at:
> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/receiver-side-implementation-11.pkt


