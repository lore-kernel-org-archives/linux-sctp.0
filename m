From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 15 Dec 2013 19:08:25 +0000
Subject: Re: undetected closed apps
Message-Id: <52ADFE29.7010806@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/15/13 10:32, Michael Tuexen wrote:
> On Dec 15, 2013, at 4:21 PM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> I think you said that HEARTBEATs were still flowing in both directions.

Yes.

> So the association is alive. You might want to inspect on the client
> side the state of the association. That seems to be the side which
> has a problem. What is netstat reporting?

I tried to narrow it down by putting both client and server on
same host. The association is still alive as evidenced when
i dumped /proc/net/sctp/assocs  after the client closed.
It dies when i kill the server.

cheers,
jamal
