From: David Miller <davem@davemloft.net>
Date: Fri, 21 Sep 2018 14:45:24 +0000
Subject: Re: [PATCH net] sctp: update dst pmtu with the correct daddr
Message-Id: <20180921.074524.348596771582256001.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <dbed84b3964b13a0c15b3a5c8e825940819a2918.1537435648.git.lucien.xin@gmail.com>
        <20180920.113113.1168948449098131783.davem@davemloft.net>
        <CADvbK_djerrPki_weXxxwpf3ncT=k2PxK2=gB0BUKToznBRyCA@mail.gmail.com>
In-Reply-To: <CADvbK_djerrPki_weXxxwpf3ncT=k2PxK2=gB0BUKToznBRyCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 21 Sep 2018 15:55:34 +0800

> It's under the protection of the sock lock, I think any other places
> that want to access the address also need to acquire this sock lock
> first.

Hash table lookups don't even have a socket context yet, so can't hold
the sock lock, but look at the address for comparisons.

Anything visible in a table lookup has to have stable keying
information.
