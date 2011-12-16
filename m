From: Xi Wang <xi.wang@gmail.com>
Date: Fri, 16 Dec 2011 22:25:37 +0000
Subject: Re: [PATCH v2] sctp: fix incorrect overflow check on autoclose
Message-Id: <D216BA11-0779-45C8-85DB-3E553069215C@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1323393883-3759-1-git-send-email-xi.wang@gmail.com> <4EE919B5.3090901@gmail.com> <4EEA6176.9020704@hp.com> <0BF79838-C86F-4C3F-8D51-4223D579764C@gmail.com> <4EEB40D5.7030906@hp.com>
In-Reply-To: <4EEB40D5.7030906@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrei Pelinescu-Onciul <andrei@iptel.org>, "David S. Miller" <davem@davemloft.net>

On Dec 16, 2011, at 8:00 AM, Vlad Yasevich wrote:
> This would work as well.  I do like the max configurable though as it
> might be a nice feature, but the above code is exactly what I was
> thinking about too.

Okay I will do a v3 based on that with the max autoclose. ;-)

- xi
