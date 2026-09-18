Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E9F3612FE
	for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 19:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760777; cv=pass; b=ODfr/upKKAz+FNKGdnHdhAdpCI+eR9jcEt7LGBlYyMX8wvKWJYowq3wn+ZYC9ZRC+aFOTMenRWBURRL8VYeEHBjyBjatog3JXRC7A6V/7/Fe3yBDbwBDJYoPiH3Yk1LVOk4Z9Kd1fLTTGjTlsZM5nLs4vZiaMX4qA8RHfdKB1zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760777; c=relaxed/simple;
	bh=yVOHMmLi1bs36u1f0SMgBzXyQBm7WdNKgnvY4vmU7VU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TEI6KkgclVUFU1PjandV/4+CH0eRVTy3mpo1kC3cVaCbIDJg8YBizom4PMV9C8ZvZx00ApfAWbFMmWyR069y9MgPr9GKOuYf5Nmwq1vZmQTiSsN7JM1LL1Fnkhehx8o+Oc0trtlHwfk70VM7DJmjuwdwmc20VeWtuiqVs+NsWec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X2sRy9Yl; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X2sRy9Yl"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469e25187so738020b3a.2
        for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 12:46:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789760775; cv=none;
        d=google.com; s=arc-20260327;
        b=AJHxH7c0S5eBzlELC2ebgzTRyLHCYegVl86jIGOZU8SKHbrbYuAJGOg1nDW9pxOd5q
         1kgTWls7sewYM8zjtSoEmhpmGStFVb9W/PvFvMrQWLWk9XDldHu3lNNERqO+D5iBgZ0t
         OJP1aYG7nN5mtagNKcAJLBqVD3SFtJ4arC+5ALkrTwa0FdMo/3Wz3M3PIMbMTzoLQJkF
         MrNPxZ/RhwrlYkA19TRVr+8T+k//8gyGr3VoaysxB3ljq3ITwQcxzsZh7L39Qe+jEt38
         JT7WIOAo9r3itAfSLcv7wpolGQ6/v2t29QoQ2W+XBuBpw4ZXKHOn38W+gC08Fvl7uPdh
         TtLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yVOHMmLi1bs36u1f0SMgBzXyQBm7WdNKgnvY4vmU7VU=;
        fh=wlGv1i4fDAXcIz1cYwleohxscO34gRLB2x3yVSedHgU=;
        b=YwCteT2sdONK9IsbgJRZcTq5dovfdHy+YM89LHOG70GD+5T3uT/jbRICLJmgJT4xQo
         9KN4gjUJxqqM3Q3yVPOFE5oi7aYttcsZXrWYUrS1+ieVY5a3mRpVKticWyxvDJp6wE2j
         ZnnC9DpTLLRsGq+Hzi2L4Nk321NRYRd5li7Izp5SJDxUGEVBQ9EmwJgjDYIDxhcbqbE5
         KHCNOhshA8B6pU2OeGoknL0b6IOvIurjTp27PytIK4DHQbibG7UhaMOxwQn6X+L92s1G
         4VRzKyCvjGtck13sN35f1idiW7joAYf2NTshqPkpyQmaCfbCzLotfx9WKg8TEz0BxV8u
         kyGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789760775; x=1790365575; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yVOHMmLi1bs36u1f0SMgBzXyQBm7WdNKgnvY4vmU7VU=;
        b=X2sRy9Yln8yRuuIah4H/Xc8NW7bw+vcAKxO1otJm6TnMjxCgqBJ7gh1X9QX8bLrz79
         uVrKyi7PG59X7pdwGhFZ6LjChvwI68NiNl0Viz9DwfSzarnsiqu3HyTTfdnGf8xqhcv3
         MiSswnPlRzEv2A1mLEogKgSCLghhs0WWpbIVl8VdiJOruGLI3n9R5ti3vza9jpDv+6uO
         Wm3GB93JpdSJMs6kbKZSKxTHMMR5CWvB9p2BdmhYZdn3WNlSvvvag2FCd/oyBdssqHgl
         B82Hv3rT0Oe8bfPln0bQigdlTLs8u4ymBr1Y7lMlT0O6Vm34TAiysjxrbuHmkgh5v2Yz
         3eTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789760775; x=1790365575;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yVOHMmLi1bs36u1f0SMgBzXyQBm7WdNKgnvY4vmU7VU=;
        b=R2CW3WpEqUvLBoJ35ZB4aQ64cIK45sZAPdSfoQdQ4uJ5wrwOVb66xuoe3lk+H81/ET
         7IKh8wR3iM1N9J5011pQ+FKemYgin1s5BBAfWjQKyzNSmLtkYblUEVr0fkQijecRtTaI
         EdWliodt3tgtSKxHdGOfPxhQl/qPLi9zNWspz0r7b3pRtaRu2mHia4p2Gf6tik+9VP91
         elFQkp+1HHpTthqvVHyXPN1/IptRsCVcHkAawobyHcZBMG0WVLZE5O6Y3uQn403ZOnp2
         p8Q+WP5Rjiz8S1ZMQNf8/lRIo6us33vPFNjSu5fyIRyrhymyQ7hzma4zViVZKlXEsAJ5
         7pbw==
X-Gm-Message-State: AFuF++lKCEUPlh32zLuqXU8F2Fa3QRG+LNbxNKBY3CC3/lHyqQeg+OBt
	qDec7oDMONZBCFj+HOat8/UzXxpXG5XuWScShWYhKOoyihsF0R1DcJi4WfKUxzZjQnxTskOLhzv
	QbF3kuf+rXA1EmZHPCGn5QYLGI5LyM8o=
X-Gm-Gg: AYBFou0THjfk6HuanMRz4BH+3QYezSyoHxqzcZQfVL9aflUhbC5uJrrolaSvZJLB6V1
	nWxu85BnZ+nF8SzVKxDqtVOX3fMnaD8dW6RRPZ0eKfVN/KBma6H+3yk3vHxoB+OCDNOyFfoSG4+
	HZilKabWFoTFPNjsvQoJeNYontr6ZEooR35n3fM5IHnUUzNtJQqY56BXBNq+dUAYP4/I6GbUqQh
	h36lCZGFqc4hgKVoc/mvx2EZIcexfmnyBmaA4rDI7zLtikRJwNPZSct0X3mB0tFgx9s38wOstZy
	whadfVAOhfTToaPXpMIxRFYtmo/c93Q3ajmmhLj9z4lQaSwh5b8Y1JTCkGUNMFNxuJbeIxWWBo+
	tjGaAE8Y/KNMQEp/ofcQMWuv3MUloVqBq4UaVVAHgTo7SqEbVdXx3Q4Oq
X-Received: by 2002:a05:6a00:2913:b0:874:705d:f641 with SMTP id
 d2e1a72fcca58-874de509a17mr5880126b3a.35.1789760774819; Fri, 18 Sep 2026
 12:46:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACjaXw6GpV6E+G81qTtdYwPHBSrk1sDmgmOG1dGSryEF+kVVSQ@mail.gmail.com>
 <CADvbK_dNObq76nBsy+pHOYtw12m0Xi-3tvqevF4VjvK_SxzTQA@mail.gmail.com>
 <CACjaXw6s8prVMqN1tAkbiSZmSvjmxoNiXK1Ytc6GCrS0Hw-1gA@mail.gmail.com> <CACjaXw5cNfXasafrw4MjG7F_L1g+KOq5LajmVxdyZ78s7LjJhA@mail.gmail.com>
In-Reply-To: <CACjaXw5cNfXasafrw4MjG7F_L1g+KOq5LajmVxdyZ78s7LjJhA@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 18 Sep 2026 15:46:03 -0400
X-Gm-Features: AcwNN1U02HD1jFwti9RISz9dbX-qfCcBprpUg4qB5-3JG4cHin4dVIibwls9Ghc
Message-ID: <CADvbK_eec2HdmL=sFJ=iyVTX7ye_OqP65+E4__iGKj97cWNeEg@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: carry peer capabilities across an INIT collision
To: Warren Briggs <wbriggs@cellusys.com>
Cc: linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 12:18=E2=80=AFPM Warren Briggs <wbriggs@cellusys.co=
m> wrote:
>
> My mail client converted the tabs to spaces on the way out, so the
> inline patch in my previous mail may not apply. The same patch is
> attached as a file, content unchanged.
>

A couple of comments:

1.
hostname_address no longer exists in struct sctp_association since:
commit bd4b28189469 ("sctp: delete the obsolete code for the host name
address param")
so please remove:
asoc->peer.hostname_address =3D new->peer.hostname_address

2.
Each line of the commit message must not exceed 75 characters, please fix i=
t.

3.
you need to put a Fixes tag in the commit:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

4.
After fixing all above, run the patch format check:

# ./scripts/checkpatch.pl xxxxx.patch

to make sure no warning or error reported

5. Aim this patch to:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
with subjectprefix: "PATCH net":

6.
Sending the patch to upstream via 'git send-email' to these mailing
addresses below:

# ./scripts/get_maintainer.pl net/sctp/associola.c
Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> (maintainer:SCTP PROTOC=
OL)
Xin Long <lucien.xin@gmail.com> (maintainer:SCTP PROTOCOL)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING [GENERAL])
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [GENERAL])
Simon Horman <horms@kernel.org> (reviewer:NETWORKING [GENERAL])
linux-sctp@vger.kernel.org (open list:SCTP PROTOCOL)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)

Thanks.
