From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 14 Dec 2013 17:21:17 +0000
Subject: Re: undetected closed apps
Message-Id: <52AC938D.9080702@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/14/13 12:06, Michael Tuexen wrote:

> What does this mean? Do you call close() or shutdown()? Do you
> kill the client?
>

Clean shutdown.
shutdown(fd, SHUT_RDWR);

cheers,
jamal
