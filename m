From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 19 Sep 2016 10:41:34 +0000
Subject: RE: [PATCH net] sctp: fix SSN comparision
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DB01031D2@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
In-Reply-To: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: 'Marcelo Ricardo Leitner'
> Sent: 16 September 2016 18:22
...
>         frags = sack->variable;
> -       gap = tsn - ctsn;
> -       for (i = 0; i < ntohs(sack->num_gap_ack_blocks); ++i) {
> -               if (TSN_lte(ntohs(frags[i].gab.start), gap) &&
> -                   TSN_lte(gap, ntohs(frags[i].gab.end)))
> +       blocks = ntohs(sack->num_gap_ack_blocks);
> +       for (i = 0; i < blocks; ++i) {
> +               if (TSN_lte(ctsn + ntohs(frags[i].gab.start), tsn) &&
> +                   TSN_lte(tsn, ctsn + ntohs(frags[i].gab.end)))
>                         goto pass;

I think I now understand what all the values are!
The correct test is just:
			if (gap > ntohs(frags[i].gab.start) &&
			    gap <= ntohs(frags[i].gab.end))
(I think the ends are right).
gab.start/end are 16bit unsigned offsets from ctsn.
All the module arithmetic is sorted out when 'tsn' is converted to an
offset from ctsn. 'gap' is a very bad name for the tsn_offset.

Looks like gap.start/end should be saved in host order though.

	David

