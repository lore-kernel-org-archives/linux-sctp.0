From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 16 Sep 2016 09:51:56 +0000
Subject: RE: [PATCH next] sctp: make use of WORD_TRUNC macro
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DB00FF62C@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <b40b1bd4adff2d389588d9a4710af0399ce68d1e.1473963064.git.marcelo.leitner@gmail.com>
In-Reply-To: <b40b1bd4adff2d389588d9a4710af0399ce68d1e.1473963064.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

From: Marcelo Ricardo Leitner
> Sent: 15 September 2016 19:13
> No functional change. Just to avoid the usage of '&~3'.
...
> -	max_data = (asoc->pathmtu -
> -		sctp_sk(asoc->base.sk)->pf->af->net_header_len -
> -		sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk)) & ~3;
> +	max_data = asoc->pathmtu -
> +		   sctp_sk(asoc->base.sk)->pf->af->net_header_len -
> +		   sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk);
> +	max_data = WORD_TRUNC(max_data);

Hmmm....
Am I the only person who understands immediately what & ~3 does
but would have to grovel through the headers to find exactly what
WORD_TRUNC() does.

How big is a 'WORD' anyway??

	David
