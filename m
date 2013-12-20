From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 20 Dec 2013 17:00:31 +0000
Subject: Re: undetected closed apps
Message-Id: <52B477AF.3070209@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/20/13 07:23, Jamal Hadi Salim wrote:
> On 12/19/13 12:24, Vlad Yasevich wrote:

> I will give this a try when i get to the office. I am certain we linger
> on the server. On client side, at one point we turned off heartbeats on
> the client side and that typically goes with linger on. I will double
> check.
>

Linger was on only on server->client side. Turning it on the other way
seems to have fixed the issue - still hammering at it trying to see
if we can reproduce it. But looking good so far. Thanks!
Building kernel image to test the patch.

cheers,
jamal
