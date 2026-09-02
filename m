Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D707D424649;
	Wed,  2 Sep 2026 22:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788387032; cv=none; b=bx8JtQReb1ACPaXcLA2SjJzbRa2NOsKTa05IwjPjaBDKY8rYyd7LrPmZV1vTr4uAmJDpAsgOb+vSclQs3Ghg0fAm3OPmKwRvOTSgKbvrh3R9RvNIOX57LJ6kxw+dLYECAwj8S1gFfNOWCoGuAYROz8Ak78PItRrCJ2vCCYpnkp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788387032; c=relaxed/simple;
	bh=K0a7UCSTlR5TQ0bfImvIwbLW4H0HJIEmdBKpG3wev2Q=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h1Kv78XauI7gumtK8vCI/FbaIds9aV518+RRRYK6/Qc0aB0nCUnBUEDRgbMCKpzWjaeOzW2mnQcMIV9DFBZmLixFx9mH0N9x6ZBUcEOS4Bq7Jo1+tmiduNfrBqPb7o7uRU1GMWVShUqp0Q7iPhbESP8pbf4nlYexMSsm2mxXcOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qukjg1EA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qukjg1EA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273EC1F000E9;
	Wed,  2 Sep 2026 22:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788387026;
	bh=ZHxKxx1+VQVcsR9PoWaPh1Uk1GeVkL+9iDr0NhHJZz0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Qukjg1EAk73liBi8FkNRZjYuLw+KwYrPDhPO5ordTwLdACrozNPfvcC9Cim5awhpD
	 C6naHQLp+fvEvckCRmVjWnh6Y10NgfNYEfR8/B+fUO6NMCyfXrATdxx4dvX9fc+/hy
	 XyvtqrMqNAzlbjdW132IYfUm4blsn7woUBIsbhQ+uatBEwb1EBsdiUKXG/vxXObTl6
	 fx09dQHqUg/ZYSpwm5x6wfFYVL0tOs2gRqtfqLkiB7HKrjLI16XdU2HqRhcsM+Q4xg
	 kQqMlL7Vf9XzYELbrlThyxoGgc9Ss95dUGNQwJzYDrlaS4ydnZX811kUP/KsNDsF3b
	 M9Wp9cfOx8xiw==
Subject: Re: [net-next,real,v4] net: Replace %pK output with 0
From: netdev-bot+sashiko@kernel.org
To: bigeasy@linutronix.de
Cc: socketcan@hartkopp.net, linux-atm-general@lists.sourceforge.net,
 linux-can@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, herbert@gondor.apana.org.au,
 kuba@kernel.org, kuniyu@google.com, mkl@pengutronix.de,
 marcelo.leitner@gmail.com, ncardwell@google.com, pabeni@redhat.com,
 courmisch@gmail.com, horms@kernel.org, steffen.klassert@secunet.com,
 willemdebruijn.kernel@gmail.com, lucien.xin@gmail.com, pmladek@suse.com,
 thomas.weissschuh@linutronix.de, kees@kernel.org
Date: Wed, 02 Sep 2026 22:10:24 +0000
Message-ID: <178838702467.3394541.6607347117257503033@kernel.org>
In-Reply-To: <20260901160345.eeknHmY2@linutronix.de>
References: <20260901160345.eeknHmY2@linutronix.de>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 1

- [Medium] Incomplete conversion relative to the commit's stated scope:
  after this patch net/ still contains %pK socket/object-pointer output.
- [Low] The updated /proc/net/tcp example in
  Documentation/networking/proc_net_tcp.rst does not match the…

--

net: Replace %pK output with 0

This replaces the %pK pointer output in the various /proc/net seq_file
printers with a literal 0, adjusting field spacing and header strings so
the column layout stays intact. Documentation/networking/proc_net_tcp.rst
is updated to describe the field as always 0.

> net: Replace %pK output with 0
[ ... ]
>     Replace the %pK annotation with 0 value. Correct the spacing for the
>     cases where pointer is at the beginning.

[Severity: Medium]
The subject and this sentence read as if net/ no longer emits pointers,
but three files under net/ still use %pK after this commit:

  net/bluetooth/af_bluetooth.c:bt_seq_show()
	seq_printf(seq,
		   "%pK %-6d %-6u %-6u %-6u %-6llu %-6llu",
		   sk,

  net/can/proc.c:can_print_rcvlist()
	char *fmt = (r->can_id & CAN_EFF_FLAG)?
		"   %-5s  %08x  %08x  %pK  %pK  %8ld  %s\n" :
		"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";

  net/can/bcm.c:bcm_proc_show()
	seq_printf(m, ">>> socket %pK", sk->sk_socket);
	seq_printf(m, " / sk %pK", sk);
	seq_printf(m, " / bo %pK", bo);

bt_seq_show() is installed by bt_procfs_init() for every Bluetooth
protocol, so /proc/net/l2cap, /proc/net/sco, /proc/net/rfcomm*,
/proc/net/hci*, /proc/net/iso, /proc/net/bnep and /proc/net/hidp keep
printing the struct sock pointer.

The changelog below the '---' line says the CAN changes were dropped on
purpose, but that text is discarded when the patch is applied, and the
Bluetooth site is not mentioned at all. Could the commit message name the
remaining sites so git log does not suggest net/ was fully converted?

> diff --git a/Documentation/networking/proc_net_tcp.rst b/Documentation/networking/proc_net_tcp.rst
> index 7d9dfe36af45b..4fa2e58429b95 100644
> --- a/Documentation/networking/proc_net_tcp.rst
> +++ b/Documentation/networking/proc_net_tcp.rst
> @@ -30,16 +30,16 @@ up into 3 parts because of the length of the line)::
>        |        |----------------------> receive-queue
>        |-------------------------------> transmit-queue
>  
> -   1000        0 54165785 4 cd1e6040 25 4 27 3 -1
> -    |          |    |     |    |     |  | |  | |--> slow start size threshold,
> -    |          |    |     |    |     |  | |  |      or -1 if the threshold
> -    |          |    |     |    |     |  | |  |      is >= 0xFFFF
> -    |          |    |     |    |     |  | |  |----> sending congestion window
> -    |          |    |     |    |     |  | |-------> (ack.quick<<1)|ack.pingpong
> -    |          |    |     |    |     |  |---------> Predicted tick of soft clock
> -    |          |    |     |    |     |              (delayed ACK control data)
> -    |          |    |     |    |     |------------> retransmit timeout
> -    |          |    |     |    |------------------> location of socket in memory
> +   1000        0 54165785 4  0  25 4 27 3 -1

[Severity: Low]
Does the example still match what the kernel prints? The example shows two
spaces on each side of the new always-zero field, while get_tcp4_sock() in
net/ipv4/tcp_ipv4.c and get_tcp6_sock() in net/ipv6/tcp_ipv6.c both emit a
single space on each side:

	"%08X %5u %8d %llu %d 0 %lu %lu %u %u %d"

so the real line is:

   1000        0 54165785 4 0 25 4 27 3 -1

Should the example (and the arrow alignment below it) use the single-space
spacing, or should the format strings pad the field if the wider column is
intended?

> +    |          |    |     |  |  |  | |  | |-------> slow start size threshold,
> +    |          |    |     |  |  |  | |  |           or -1 if the threshold
> +    |          |    |     |  |  |  | |  |           is >= 0xFFFF
> +    |          |    |     |  |  |  | |  |---------> sending congestion window
> +    |          |    |     |  |  |  | |------------> (ack.quick<<1)|ack.pingpong
> +    |          |    |     |  |  |  |--------------> Predicted tick of soft clock
> +    |          |    |     |  |  |                   (delayed ACK control data)
> +    |          |    |     |  |  |-----------------> retransmit timeout
> +    |          |    |     |  |--------------------> always 0 (was memory location).
>      |          |    |     |-----------------------> socket reference count
>      |          |    |-----------------------------> inode
>      |          |----------------------------------> unanswered 0-window probes

[ ... ]

> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 9f053eb8b46e2..142e7b048229e 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2811,7 +2810,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
>  				      READ_ONCE(tp->copied_seq), 0);
>  
>  	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
> -			"%08X %5u %8d %llu %d %pK %lu %lu %u %u %d",
> +			"%08X %5u %8d %llu %d 0 %lu %lu %u %u %d",
>  		i, src, srcp, dest, destp, state,
>  		READ_ONCE(tp->write_seq) - tp->snd_una,
>  		rx_queue,

[ ... ]

> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index df9c29eb5c1f4..b55d036c7f4da 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -2171,7 +2171,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
>  
>  	seq_printf(seq,
>  		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
> -		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %lu %lu %u %u %d\n",
> +		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %lu %lu %u %u %d\n",
>  		   i,
>  		   src->s6_addr32[0], src->s6_addr32[1],
>  		   src->s6_addr32[2], src->s6_addr32[3], srcp,

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901160345.eeknHmY2%40linutronix.de
