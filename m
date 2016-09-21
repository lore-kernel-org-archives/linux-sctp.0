From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 21 Sep 2016 10:21:43 +0000
Subject: RE: [PATCH next 1/2] sctp: fix the handling of SACK Gap Ack blocks
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DB0105BBB@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1474405559.git.marcelo.leitner@gmail.com>
 <18f5ac1b303b60a4363cff8e002e8fea66666a08.1474405559.git.marcelo.leitner@gmail.com>
In-Reply-To: <18f5ac1b303b60a4363cff8e002e8fea66666a08.1474405559.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

From: Marcelo Ricardo Leitner
> Sent: 20 September 2016 22:19
> sctp_acked() is using 32bit arithmetics on 16bits vars, via TSN_lte()
> macros, which is weird and confusing.
> 
> Once the offset to ctsn is calculated, all wrapping is already handled
> and thus to verify the Gap Ack blocks we can just use pure
> less/big-or-equal than checks.
> 
> Also, rename gap variable to tsn_offset, so it's more meaningful, as
> it doesn't point to any gap at all.
> 
> Even so, I don't think this discrepancy resulted in any practical bug.

I think it might if gab.start/end are greater than 32767

...
> -	gap = tsn - ctsn;
> -	for (i = 0; i < ntohs(sack->num_gap_ack_blocks); ++i) {
> -		if (TSN_lte(ntohs(frags[i].gab.start), gap) &&
> -		    TSN_lte(gap, ntohs(frags[i].gab.end)))
> +	blocks = ntohs(sack->num_gap_ack_blocks);
> +	tsn_offset = tsn - ctsn;
> +	for (i = 0; i < blocks; ++i) {
> +		if (tsn_offset >= ntohs(frags[i].gab.start) &&
> +		    tsn_offset <= ntohs(frags[i].gab.end))
...

	David

