Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B3E3431E6;
	Fri, 14 Aug 2026 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786698987; cv=pass; b=I5udNEWp8SZfSFTmunU8bm4yODI1bRK6uvKhK60LcNkbock7Z4xXgOrgYebNR4RkKtSGgEuctGF26gOY0P+chqzgmxQm7XZSAa0d50Jnrn+Qh4r3qXq/pizlBEn3mP/hzwH5TShubKj1VQ16qjklxeFJL7lCanXeoIEAa3QNPXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786698987; c=relaxed/simple;
	bh=JT61UcVRO+TmLppO1hbK9oylVSIiT/YW6MIEy7YC6pE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K5OKkjbA7zhwgd7IPv8O+L/tgxGb2YPROTJ0cgD5H3wkMQHCfkpDcsj9eMFYiHeOI7XCyZHhJ3a/mSWWV7h5Rzl8EnyvqFRMzm1HgMUJk2MZ7sD96W23IeDFVMfLyTAbknSciFAYqQLVUCj+vkWbNySUuWAYLmxgHLdS7MOzYT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net; spf=fail smtp.mailfrom=hartkopp.net; dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=dEFczraY; dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=wOZ292nW; arc=pass smtp.client-ip=81.169.146.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="dEFczraY";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="wOZ292nW"
ARC-Seal: i=1; a=rsa-sha256; t=1786698951; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=F9/sJWBEFAfWYdMzurfxd/QHrPUftK1dIrkzqb39Aq/DB2Y6OjqaS0sTZUvSCVK9Fb
    RQA3SnfzuqreXi2qTNiC1/DAGVP6jKty19Sw1nRiP46p1zdTw/nFwfGWY7nO+PHl62hi
    juDYJz4ZUaULVv1fF+kfhVjIODPWthTvDb/1IYX/VAAVfq/W8gQRQKxS5xPdpKLsFq+0
    9xTaevPHoM63Bm0k1A82+rSFxnquufFqQq517K2LL6Ohc2BZpLchQs3ZWljaRC4lEzS6
    6xmWA9V+Y4BLM04FHIrWhtz9LR1P1Byy5XIa19g6SKgCA5hKObUd1BO4w6Faiz4DxdE3
    9Xvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1786698951;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oZgbCxEMlVJlyq0o1LV13R79vv8aJXDKCqbvS7epk+c=;
    b=OU8QDjxq6Zjzn3uFeroFX5OdkuUqJmNVtn3kshhfEWQlwcbSNZtSITsI3laLm6uViW
    IUEGkmkD9cb4Yg13VIs7/sOV1IVPit44ogczKp8UPieAuy4Jz7aj+1SSJHlt5VA0Qwsz
    +rREGc7o3d43vCHJNpQ2HluRtRhSfF47binuIQJrEf0PY2O/TjEkcrenG9aqZB52lYCi
    DigXtHJ0Xc7mWbuO5CgV/60NFW1K04BeJB8M/tcL7+IKgXqQ8jgv7sTW2wpg2GK1iVPu
    knd77MFfaPSXy6K68+BImqj3bX2ybnXOofuC9OSEx3mJAZYhr/PnopWSnf155C0Vakwn
    nVdQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1786698951;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oZgbCxEMlVJlyq0o1LV13R79vv8aJXDKCqbvS7epk+c=;
    b=dEFczraYWpANz0x+VIhSnstisPo2z51o0dDU2z+2kc4aZYU3orjm2l8VbajskHT9nv
    Y5gHbwHYhkzstzBnXLlqOzGc7XHgB4g0niKQmhFdovMNTWglkHm4qt3UWB9vUUwrLqw0
    Ps0lFhCNJ+QX258MvZ67bVunrWCSNFWDxvJBDQsXIUfMOC/na7/XLFwRqES0NUQ5QO01
    DzW8KUa6Wj9XO1L8QSi5aYSVfHomWA87gG9bMPEWPvTSVCjPaaD2Se01tZzF0S4tlv4E
    rBqM6Du75hZAExOQUxOeDpHoTWa9lm7GRmCXotdwT3X/T+d/FgOCZUvXrHhE8fgIZJSP
    SvpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1786698951;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oZgbCxEMlVJlyq0o1LV13R79vv8aJXDKCqbvS7epk+c=;
    b=wOZ292nWasI1uvA5+ISKYgEX1tJYmp52Gyy83IlUZzcpY7Th8c0d61dpY7DgOGqR64
    SENfXUDyE/AHHOJHgVCQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjH4JKvMdQv2tTUsMrZpkO3Mw3lZ/t54cFxeEQ7s8bDup0Q=="
Received: from [IPV6:2a00:6020:4a38:6810::989]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id K171b727E9Fn2Q9
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 14 Aug 2026 11:15:49 +0200 (CEST)
Message-ID: <49dab6fa-94bc-42a9-81b9-167db8c35add@hartkopp.net>
Date: Fri, 14 Aug 2026 11:15:42 +0200
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3] net: Replace %pK output with 0
To: Jakub Kicinski <kuba@kernel.org>, bigeasy@linutronix.de
Cc: linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, herbert@gondor.apana.org.au, kuniyu@google.com,
 mkl@pengutronix.de, marcelo.leitner@gmail.com, ncardwell@google.com,
 pabeni@redhat.com, courmisch@gmail.com, horms@kernel.org,
 steffen.klassert@secunet.com, willemdebruijn.kernel@gmail.com,
 lucien.xin@gmail.com, pmladek@suse.com, thomas.weissschuh@linutronix.de,
 kees@kernel.org
References: <20260812110531.ITPqiY2O@linutronix.de>
 <20260814015800.2837019-2-kuba@kernel.org>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20260814015800.2837019-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 14.08.26 03:58, Jakub Kicinski wrote:

>> diff --git a/net/can/proc.c b/net/can/proc.c
>> index de4d05ae3459..4314180fd7a1 100644
>> --- a/net/can/proc.c
>> +++ b/net/can/proc.c
>> @@ -192,12 +192,11 @@ static void can_print_rcvlist(struct seq_file *m, struct hlist_head *rx_list,
>>   
>>   	hlist_for_each_entry_rcu(r, rx_list, list) {
>>   		char *fmt = (r->can_id & CAN_EFF_FLAG)?
>> -			"   %-5s  %08x  %08x  %pK  %pK  %8ld  %s\n" :
>> -			"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";
>> +			"   %-5s  %08x  %08x  %-20ps %8u %8ld  %s\n" :
>> +			"   %-5s     %03x    %08x  %-20ps %8u %8ld  %s\n";
>>   
>>   		seq_printf(m, fmt, DNAME(dev), r->can_id, r->mask,
>> -			   r->func, r->data, atomic_long_read(&r->matches),
>> -			   r->ident);
>> +			   r->func, 0, atomic_long_read(&r->matches), r->ident);
>>   	}
>>   }
> 
> [Severity: Medium]
> Does this widen what unprivileged readers can see, rather than narrow it?
> The rcvlist_* files are created world readable by can_init_proc():
> 
>    net/can/proc.c:can_init_proc() {
>        ...
>        net->can.pde_rcvlist_all = proc_create_net_single(CAN_PROC_RCVLIST_ALL,
>                        0644, net->can.proc_dir, can_rcvlist_proc_show,
>                        (void *)RX_ALL);
>        ...
>    }
> 
> Unlike %pK, %ps is not filtered by kptr_restrict and is never hashed.  With
> CONFIG_KALLSYMS=n, symbol_string() takes the fallback branch:

I got the point but the patch rendered the CAN proc outputs partly 
useless and it is definitely time to give it a rework.

It is pretty cool following your suggestion to be able to see the 
function calls like "bcm_rx_handler [can_bcm]". This is always what I 
wanted and brings no new security nor privacy issues. It mainly makes 
the ident string obsolete.

Instead of the other "data" it makes sense to provide the sock inode 
number to identify the relevant socket where possible (for raw/bcm/isotp).

If its ok for you I would provide a separate patch for can-next 
reworking the CAN proc output?!? So you would be able to continue with 
the other hunks only.

I'll put you and netdev ML in CC.

Best regards,
Oliver

> 
>    lib/vsprintf.c:symbol_string() {
>        ...
>        return string_nocheck(buf, end, sym, spec);
>    #else
>        return special_hex_number(buf, end, value, sizeof(void *));
>    #endif
>    }
> 
> so the raw kernel/module text address of the receive callback is printed to
> any local reader, even with kptr_restrict=2.
> 
> With CONFIG_KALLSYMS=y the address is not printed, but the symbol plus the
> owning module name is now disclosed unconditionally, since
> __sprint_symbol() appends the module:
> 
>    kernel/kallsyms.c:__sprint_symbol() {
>        ...
>        if (modname) {
>                len += sprintf(buffer + len, " [%s", modname);
>        ...
>    }
> 
> Previously kptr_restrict >= 1 censored this field for readers without
> CAP_SYSLOG.  Would the literal 0 placeholder used for the other 14 sites
> work here too?
> 
>> @@ -207,10 +206,7 @@ static void can_print_recv_banner(struct seq_file *m)
>>   	 *                  can1.  00000000  00000000  00000000
>>   	 *                 .......          0  tp20
>>   	 */
> 
> [Severity: Low]
> This example comment still shows the old layout, where the receive callback
> was an 8-hex-digit %pK value (the third 00000000 column) and userdata was a
> pointer.  can_print_rcvlist() now emits a left-justified symbol name via
> %-20ps and a constant 0 for userdata, so nothing the code can produce
> matches this example.  Should the comment be refreshed?
> 
>> -	if (IS_ENABLED(CONFIG_64BIT))
>> -		seq_puts(m, "  device   can_id   can_mask      function          userdata       matches  ident\n");
>> -	else
>> -		seq_puts(m, "  device   can_id   can_mask  function  userdata   matches  ident\n");
>> +	seq_puts(m, "  device   can_id   can_mask  function             userdata  matches  ident\n");
>>   }
> 
> [Severity: Low]
> The new banner advertises a fixed 20-character "function" column, but does
> the row format actually stay inside it?
> 
> Module symbols printed by %ps carry the module suffix, e.g.
> "bcm_rx_handler [can_bcm]" (24 chars), "j1939_can_recv [can_j1939]" (26)
> or "isotp_rcv [can_isotp]" (21), so userdata/matches/ident get pushed to
> the right whenever can_bcm, can_isotp or can_j1939 is loaded.
> 
> In the CONFIG_KALLSYMS=n case symbol_string() calls
> 
>        return special_hex_number(buf, end, value, sizeof(void *));
> 
> which discards the caller's spec, so the field is an unpadded 18-character
> 0xffffffffXXXXXXXX and the following columns shift left instead.
> 
> [Severity: Low]
> Documentation/networking/can.rst still documents the previous output of
> /proc/net/can/rcvlist_*:
> 
>          device   can_id   can_mask  function  userdata   matches  ident
>           vcan0     000    00000000  f88e6370  f6c6f400         0  raw
> 
> After this change the banner is spaced differently, "function" is a symbol
> name that may itself contain a space before "[module]", and "userdata" is
> always 0.  Should can.rst be updated in the same patch?
> 
>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>> index b8887cdd66c5..2cd8ae4a0e4b 100644
>> --- a/net/ipv4/tcp_ipv4.c
>> +++ b/net/ipv4/tcp_ipv4.c
> 
> [ ... ]
> 
>> @@ -2811,7 +2810,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
>>   					      READ_ONCE(tp->copied_seq), 0);
>>   
>>   	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
>> -			"%08X %5u %8d %llu %d %pK %lu %lu %u %u %d",
>> +			"%08X %5u %8d %llu %d 0 %lu %lu %u %u %d",
> 
> [Severity: Low]
> Documentation/networking/proc_net_tcp.rst still describes this field as the
> 
>      |          |    |     |    |------------------> location of socket in memory
> 
> and names tcp4_seq_show()/tcp6_seq_show() as the implementation, with a
> nonzero example value.  With get_tcp4_sock(), get_tcp6_sock(),
> get_openreq4()/get_openreq6() and get_timewait4_sock()/get_timewait6_sock()
> all emitting a literal 0 there, no code path can produce the documented
> value any more.  Could that documentation be adjusted along with this
> change?
> 
> [ ... ]

