From: Lorenzo Colitti <lorenzo@google.com>
Date: Thu, 19 Dec 2019 09:35:13 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <CAKD1Yr1m-bqpeZxMRVs84WvvjRE3zp8kJVx57OXf342r2gzVyw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com> <20191213114934.GB5449@hmswarspite.think-freely.org>
In-Reply-To: <20191213114934.GB5449@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, "David S . Miller" <davem@davemloft.net>, Linux NetDev <netdev@vger.kernel.org>, Sean Tranchetti <stranche@codeaurora.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

On Fri, 13 Dec 2019, 20:49 Neil Horman, <nhorman@tuxdriver.com> wrote:
> Just out of curiosity, why are the portreserve and portrelease utilities not a
> solution to this use case?

As I understand it, those utilities keep the ports reserved by binding
to them so that no other process can. This doesn't work for Android
because there are conformance tests that probe the device from the
network and check that there are no open ports.
