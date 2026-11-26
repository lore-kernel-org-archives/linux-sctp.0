Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795731471;
	b=3QjfwKdOASg/hnhXY/g4RGghbYpHjLS592TY9oF8sAu90HZv8Jj1RC1cS1Qag9xktHx2
	 QjRKv0BcDGNw4YB4X9uCMLR9T3qES5zImKijHkxZw+C5e6koriBfPE3a+vjB5xZ6kWAAQ
	 lCp7Lc7VHYuXdetXiKHmSBBFAC6Tg7upe/QiCg0ceHg4R5gNUkUiW4mU3UuyA9gH+LjJl
	 kjk5MLzaCAg5xj4B9joqTWwodCFYA/Z+kBvPiGslQnk37+qFVma1WZo0Yz6iam7xRNVMl
	 7O9lm0KM2AFjpBCcdWaWjzvb1SaIOgRPTV5jOTZyGl5wrdj5qPtmDKOuCSA8d2Cex+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795731471;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=c2tEduRMoiFSHBLu5Q9nqBDDd0VQZ8FBlT2itXebdq4=;
	b=PLKALt3n0qrJ0Mi9WNf3RHA3sgzOCn+9BimDJUpb6Rvyw5wiEZ/SocZ6fP5mw2ljRMtn
	 HAY3tPWGLnJYX28IZXb872iPnN/X8VLy4caxvEezWvUUG+5RNbSerkoNdL6Q5CPjo+Yu3
	 aXOpxvog1TDEkhE1Y4BzX/rAtlrUvbmbqLuR0P0+QRxXyYO8DE4t4sfTPR6HYofeV31PU
	 mv0En+GvWTDVO7yJVuw3rLPT+19ehgITa/UEPrstlhC0WFYjujsKcAJMUz/LFMUNpjWxd
	 wB1QCYVpK1KNcxmnPJvKqVmuh0Cg0Rg1kA7igFkRcr9yUTvhsG48KKBpz8L4Z1YtQgg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=asnc4qvZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD083606A321
	for <linux-sctp@vger.kernel.org>; Thu, 26 Nov 2026 22:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD083606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=asnc4qvZ
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdb2893531bso3908003a12.1
        for <linux-sctp@vger.kernel.org>; Thu, 26 Nov 2026 14:17:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795731470; cv=none;
        d=google.com; s=arc-20260327;
        b=AZrcpj0iZ3UqPmbiUoPuDOVADICgdAot/mO6vbeTg8IY23lWGTOO9InPQbirzsUhYa
         QKXG4fOBUHJW0Yiwh6+1H6LZQqQJwdtqz05v1Gqk2mn0qHcNEYAlYB8VEXl97gdx/mXb
         rn+7me9lFCVvmYgRWEu/NfAFkdAD1QdbKPeO5oexGnLSvZI26su0KqOL10OFeKrGLaoR
         gMYssLStHqynnYggO9tmXzYHWF7WW+LvNktdeRiubipEnnsNqs3uy68DcEWNkbr9f7b6
         cymAYjvda/odoO+HbV3stoaWXpmzQVe47opMwKQzYsS4QyZ9SMA3kgJqTjm6iEoY/7t2
         MEuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c2tEduRMoiFSHBLu5Q9nqBDDd0VQZ8FBlT2itXebdq4=;
        fh=3ySDyunJoCWmFOmvRfxVH9jzJbRujvW4HiTvZgZirI4=;
        b=Ui/kpNwm3rJKncjM9JIh0h8ZcGu7eIderfeRJr6jZJ8i9U78sRGABhseiKJlgQsB+5
         Dqqo0eRevyrSqrBAwS3DFOZ/IklXZyuPGsEfXqSGMEBtt9eo9dVDAsPECQ+6QjkIa+sW
         JtMFAP+6JI+5EEpREPP2g9Ft8iOYv43v3NfjgjFmFj5EEXlObtHuaBvVTwrHMgU32I9k
         SKLb3G7N0BRR8nxEA6Bz9cjiIRm5qqzTKbDK2DTIb5KLQJnlx/NU+dcd1mEFfvsmRyrO
         6W7tE33F02Gn+pNkoEGZbGfiYt9oTinjUHHxMRp+Ko30l/1JPjXTby1uk9Zgoyn8DUAL
         CHCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795731470; x=1796336270; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c2tEduRMoiFSHBLu5Q9nqBDDd0VQZ8FBlT2itXebdq4=;
        b=asnc4qvZipYKLzXuO5yLWcwTJ0FqQSkHFl0/jfo1PguRjBtUJQf4CS0Y8cQ97XwVV3
         HWL8CYW2z+NKV5yd+VWv95R3c3A07GE3z68G5iWonjTykjh5A7/y1uMzpxJK8ghHz37j
         ZpH9uJhqxOP6OP+3NAMUnTWO2eRTNpChOYtCjxdlHZ/IQyphothTFw6SU0DeDYMNcG7V
         LrbNULmrqkHOjgKpotWL6SdCL7l0GQ3hGEfht9fhTodFxtKR0TD1kLbdHXbLD+2YqPw8
         Z03PEs5PlpU2J5PdvW82hIHW59QHPwXyHkKgijrWdKLnbPHJYZDsQAnZChKc9Uz0ce9U
         w1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795731470; x=1796336270;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c2tEduRMoiFSHBLu5Q9nqBDDd0VQZ8FBlT2itXebdq4=;
        b=i2RjnomUNA7OJl19suqkOpsQwTz1fHzXABHykjoPSsYs010FQTfDaY3jD76I51OlCJ
         DfGOfvwA0VwXnznLK0qL5WB79WdTcf9mFoij+tNYEwtr6KBW+q5lQtWqkym6S8Iv2pOa
         F0jGcJ6pm028U49HnRjg1DC9kx0YLUfF1GwIMi6HpZa4x6H36ykl/CP+/cxJWHuszam6
         jFVwvLDpkLc/w27b4E8hdKSpmzMPsF5PnzsOYUGCda7tFAfrHNMIzmVBIuiTptn1JxBz
         xsNk/l6M+AurH/M99QR5HakkYN81fHlVCdtGJcXxp1qE0s0Jjr9EX8uO+NS5hEom2Xko
         BpuA==
X-Forwarded-Encrypted: i=1; AL+hErH+LZvetxruD0TynhZurzBrFlgjBKd/GvVNdx9y8HyWx4strmoMrOVIobMHjH4yXVI6NuK/Lef50ZFj@vger.kernel.org
X-Gm-Message-State: APuU4Z8szdxeQMZX1WmdcENPG5P+30GXTYrfHfeyxdzj8xfsjnjExamO
	PC+t+CjPJlLkWljrEyAgXb4pMfuihSPclbHE6vD6q86DOA9jqYJ9Gq9bDrUHBEhnAebsjaT2k3/
	RCVanq+/xFqCK9HPuq/vBn5GlQvDQeP4=
X-Gm-Gg: AZFdTZetJIOlssM91FD9Tsozu4sWpBsOuXdtUwcwPd3JXQN+G9roaYf+eIbI2ZUNaQ7
	Vq/CngAToWFXGOCjs/DYlxxBG8PU+nsoHcwYrrhTcCmSXRap4se/AyWg8jJXQGXQHQnxQr94rwP
	0FpBi3e+BO0I5gisq4pGK+kiyoIC1qLK6MzN6f0mv3cxJToqjE/lOnxQXc4BIRSOlt7czgisgjk
	HCf7SsStyz5RJhuUgxwN51OIlybXpOgqOKQN4G0o40MCwy8OjBjLLcaeQ3HdG0mHk6Xtqp4R9MZ
	2d46lRYZ2JK5Kf7C9ITslBF0Oj8Utmi12QcfkIW6NtAiaSk6uGKi0PZCvtjxjZSmEp4y4fPRL4w
	rd6V1w+sJVoBl2SKgzBjZrbCPK3N+47QNKls042CGOSNoTl8U+ztlESNeRwgZBq2YMN0JaT0yyf
	R8o42cu3p4aDLtjAf3tHejwCIP0aTzXKobfRQ=
X-Received: by 2002:a05:6a20:b719:b0:402:839c:5270 with SMTP id
 adf61e73a8af0-402839c53d8mr15789135637.72.1795731469817; Thu, 26 Nov 2026
 14:17:49 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119170342.1508789-1-irogers@google.com> <CADvbK_fM=xmwthLnz=j7YqRghc6ncDo8ESVYgWYeR0t_Byubhg@mail.gmail.com>
 <willemb.10dbd5ae83053@google.com>
In-Reply-To: <willemb.10dbd5ae83053@google.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Nov 2026 17:17:38 -0500
X-Gm-Features: Aa3M54q8WkSHQv33xwtpxDfJjDnGYSDn3EBE1V_pV0zoMgfNd656Lr7xP2iG1XM
Message-ID: <CADvbK_dWxgqXMjEpAO420-E=d=0HH=jGpef0XL3GHSq0By5dmg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: initialize new_value in custom proc_dointvec
 sysctl handlers
To: willemb@google.com
Cc: Ian Rogers <irogers@google.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Elkin Cruz <elkin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 8:43=E2=80=AFPM <willemb@google.com> wrote:
>
> Xin Long wrote:
> > On Thu, Nov 19, 2026 at 12:03=E2=80=AFPM Ian Rogers <irogers@google.com=
> wrote:
> > >
> > > proc_sctp_do_rto_min(), proc_sctp_do_rto_max(), proc_sctp_do_auth(),
> > > proc_sctp_do_udp_port(), and proc_sctp_do_probe_interval() point
> > > tbl.data at an uninitialized stack variable new_value on writes befor=
e
> > > calling proc_dointvec().
> > >
> > > proc_dointvec() can return 0 without writing to tbl.data, for example=
 on
> > > a zero-length write (*lenp =3D=3D 0) or on a write at a non-zero file=
 offset
> > > ignored by proc_first_pos_non_zero_ignore() (such as pwrite(fd, "1\n"=
,
> > > 2, 1) or a split write where the trailing newline is written
> > separately).
> > >
> > > When that happens:
> > > - proc_sctp_do_auth() unconditionally stores the uninitialized stack =
int
> > >   into net->sctp.auth_enable and sctp_sk(sk)->ep->auth_enable, both
> > >   corrupting SCTP authentication state and leaking 4 bytes of kernel
> > >   stack memory back on subsequent sysctl reads.
> > > - proc_sctp_do_rto_min(), proc_sctp_do_rto_max(),
> > >   proc_sctp_do_udp_port(), and proc_sctp_do_probe_interval() validate
> > >   the uninitialized value and overwrite the netns setting whenever st=
ack
> > >   bytes happen to fall within range.
> > > - proc_sctp_do_udp_port() also stops and restarts the UDP encapsulati=
on
> > >   socket even when the port number did not change.
> > >
> > > Initialize new_value to the current netns setting before calling
> > > proc_dointvec() (matching proc_dobool()), and skip tearing down and
> > > restarting the UDP encapsulation socket in proc_sctp_do_udp_port() wh=
en
> > > new_value equals net->sctp.udp_port.
> > >
> > > Found by enabling Clang's -Wconditional-uninitialized on an x86_64
> > > allyesconfig build, with AI coding assistant help to audit the warnin=
g
> > > and prepare the fix. Build-tested with Clang; not runtime-tested.
> > >
> > > Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
> > > Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
> > > Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
> > > Fixes: d1e462a7a5f3 ("sctp: add probe_interval in sysctl and
> > sock/asoc/transport")
> > > Signed-off-by: Ian Rogers <irogers@google.com>
> > > ---
> > >  net/sctp/sysctl.c | 39 +++++++++++++++++++++++----------------
> > >  1 file changed, 23 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> > > index 2b94c211427d..0c33f05fa532 100644
> > > --- a/net/sctp/sysctl.c
> > > +++ b/net/sctp/sysctl.c
> > > @@ -425,8 +425,9 @@ static int proc_sctp_do_rto_min(const struct
> > ctl_table *ctl, int write,
> > >         struct net *net =3D container_of(ctl->data, struct net,
> > sctp.rto_min);
> > >         unsigned int min =3D *(unsigned int *) ctl->extra1;
> > >         unsigned int max =3D *(unsigned int *) ctl->extra2;
> > > +       int new_value =3D net->sctp.rto_min;
> > >         struct ctl_table tbl;
> > > -       int ret, new_value;
> > > +       int ret;
>
>      Initializing new_value with a plain unlocked load here (and in
>      proc_sctp_do_rto_max(), proc_sctp_do_auth(), and
> proc_sctp_do_probe_interval())
>      does not actually match proc_dobool(), which uses READ_ONCE() /
> WRITE_ONCE(),
>      and introduces a new unmarked-read vs. unmarked-write data race agai=
nst
>      concurrent writers (even on read-only !write calls where new_value i=
s
> unused).
>
>      In addition, on an ignored write (*lenp =3D=3D 0 or *ppos > 0), thes=
e four
>      handlers still execute the post-proc_dointvec() commit block
> unconditionally:
>      if another writer updates the setting between the initial load and t=
he
> store,
>      the no-op write overwrites it with the stale pre-call value (and in
>      proc_sctp_do_auth(), needlessly acquires lock_sock(net->sctp.ctl_soc=
k)
> and
>      reverts ep->auth_enable as well).
>
>      Returning early on reads (`if (!write) return proc_dointvec(ctl, wri=
te,
>      buffer, lenp, ppos);`), initializing `old_value =3D READ_ONCE(...)` =
/
>      `new_value =3D old_value` unconditionally on the write path (keeping
> Clang's
>      -Wconditional-uninitialized happy), and gating the commit block on
>      `new_value !=3D old_value` with WRITE_ONCE() avoids both the data ra=
ce and
>      stale writebacks on ignored writes.
Right.

I think you can replace proc_sctp_do_rto_min() and proc_sctp_do_rto_max()
with proc_dointvec_minmax().

Then apply Willem's suggestion only to proc_sctp_do_auth() and
proc_sctp_do_probe_interval().

We may also need to use READ_ONCE() when accessing these net->sctp.xxx
fields elsewhere in the SCTP stack, but that can be addressed in a separate
patch.

> > >
> > >         memset(&tbl, 0, sizeof(struct ctl_table));
> > >         tbl.maxlen =3D sizeof(unsigned int);
> > > @@ -453,8 +454,9 @@ static int proc_sctp_do_rto_max(const struct
> > ctl_table *ctl, int write,
> > >         struct net *net =3D container_of(ctl->data, struct net,
> > sctp.rto_max);
> > >         unsigned int min =3D *(unsigned int *) ctl->extra1;
> > >         unsigned int max =3D *(unsigned int *) ctl->extra2;
> > > +       int new_value =3D net->sctp.rto_max;
> > >         struct ctl_table tbl;
> > > -       int ret, new_value;
> > > +       int ret;
> > >
> > >         memset(&tbl, 0, sizeof(struct ctl_table));
> > >         tbl.maxlen =3D sizeof(unsigned int);
> > > @@ -489,8 +491,9 @@ static int proc_sctp_do_auth(const struct ctl_tab=
le
> > *ctl, int write,
> > >                              void *buffer, size_t *lenp, loff_t *ppos=
)
> > >  {
> > >         struct net *net =3D container_of(ctl->data, struct net,
> > sctp.auth_enable);
> > > +       int new_value =3D net->sctp.auth_enable;
> > >         struct ctl_table tbl;
> > > -       int new_value, ret;
> > > +       int ret;
> > >
> > >         memset(&tbl, 0, sizeof(struct ctl_table));
> > >         tbl.maxlen =3D sizeof(unsigned int);
> > > @@ -522,8 +525,9 @@ static int proc_sctp_do_udp_port(const struct
> > ctl_table *ctl, int write,
> > >         struct net *net =3D container_of(ctl->data, struct net,
> > sctp.udp_port);
> > >         unsigned int min =3D *(unsigned int *)ctl->extra1;
> > >         unsigned int max =3D *(unsigned int *)ctl->extra2;
> > > +       int new_value =3D net->sctp.udp_port;
> > >         struct ctl_table tbl;
> > > -       int ret, new_value;
> > > +       int ret;
> > >
> > >         memset(&tbl, 0, sizeof(struct ctl_table));
> > >         tbl.maxlen =3D sizeof(unsigned int);
> > > @@ -541,18 +545,20 @@ static int proc_sctp_do_udp_port(const struct
> > ctl_table *ctl, int write,
> > >                         return -EINVAL;
> > >
> > >                 mutex_lock(&sctp_sysctl_mutex);
> > > -               net->sctp.udp_port =3D new_value;
> > > -               sctp_udp_sock_stop(net);
> > > -               if (new_value) {
> > > -                       ret =3D sctp_udp_sock_start(net);
> > > -                       if (ret)
> > > -                               net->sctp.udp_port =3D 0;
> > > +               if (new_value !=3D net->sctp.udp_port) {
> > > +                       net->sctp.udp_port =3D new_value;
> > > +                       sctp_udp_sock_stop(net);
> > > +                       if (new_value) {
> > > +                               ret =3D sctp_udp_sock_start(net);
> > > +                               if (ret)
> > > +                                       net->sctp.udp_port =3D 0;
> > > +                       }
>
>      net->sctp.udp_port is mutated under sctp_sysctl_mutex, including a
> transient
>      store of new_value before sctp_udp_sock_start() can fail and reset i=
t
> to 0.
>      Reading net->sctp.udp_port outside sctp_sysctl_mutex (and without
> READ_ONCE())
>      both introduces a new KCSAN data race on every read/write of udp_por=
t
> and
>      creates a TOCTOU race for the ignored-write case:
>
>        1. Initial net->sctp.udp_port =3D=3D 0.
>        2. Thread A starts a no-op write (e.g. *lenp =3D=3D 0 or trailing =
"\n" at
>           *ppos > 0) and reads new_value =3D 0 before locking
> sctp_sysctl_mutex.
>        3. Thread B writes "9899" at *ppos =3D=3D 0, takes sctp_sysctl_mut=
ex, sets
>           net->sctp.udp_port =3D 9899, starts the UDP tunnel sockets, and
> unlocks.
>        4. Thread A's proc_dointvec() ignores the write and returns 0 with
>           new_value still 0. Thread A takes sctp_sysctl_mutex, sees
>           new_value (0) !=3D net->sctp.udp_port (9899), tears down Thread=
 B's
> UDP
>           sockets, and resets net->sctp.udp_port =3D 0.
>
>      Conversely, if Thread A reads net->sctp.udp_port while Thread B is
> inside a
>      failing sctp_udp_sock_start(), Thread A's ignored write captures the
> transient
>      port and can attempt to bind it after Thread B rolls net->sctp.udp_p=
ort
> back
>      to 0.
>
>      Since proc_sys_call_handler() already copies the write buffer into
> kernel
>      memory before invoking ->proc_handler(), handle !write with an early
>      `return proc_dointvec(ctl, write, buffer, lenp, ppos);` and acquire
>      sctp_sysctl_mutex before initializing `new_value =3D net->sctp.udp_p=
ort`
> and
>      calling proc_dointvec() on writes (using WRITE_ONCE() for the stores
> under
>      the mutex so lockless readers stay KCSAN-clean).
Makes sense.

With sctp_sysctl_mutex, we don't need the extra old_value variable, unlike
in proc_sctp_do_auth() and proc_sctp_do_probe_interval() above.

Thanks for the comment.

> > > +
> > > +                       /* Update the value in the control socket */
> > > +                       lock_sock(sk);
> > > +                       sctp_sk(sk)->udp_port =3D
> > htons(net->sctp.udp_port);
> > > +                       release_sock(sk);
> > >                 }
> > > -
> > > -               /* Update the value in the control socket */
> > > -               lock_sock(sk);
> > > -               sctp_sk(sk)->udp_port =3D htons(net->sctp.udp_port);
> > > -               release_sock(sk);
> > >                 mutex_unlock(&sctp_sysctl_mutex);
> > >         }
> > >
> > > @@ -564,8 +570,9 @@ static int proc_sctp_do_probe_interval(const stru=
ct
> > ctl_table *ctl, int write,
> > >  {
> > >         struct net *net =3D container_of(ctl->data, struct net,
> > >                                        sctp.probe_interval);
> > > +       int new_value =3D net->sctp.probe_interval;
> > >         struct ctl_table tbl;
> > > -       int ret, new_value;
> > > +       int ret;
> > >
> > >         memset(&tbl, 0, sizeof(struct ctl_table));
> > >         tbl.maxlen =3D sizeof(unsigned int);
> > > --
> > > 2.56.1.708.g77570a6a1d-goog
> > >
>
> > Acked-by: Xin Long <lucien.xin@gmail.com>
>
>
