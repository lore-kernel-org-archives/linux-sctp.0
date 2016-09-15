From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu, 15 Sep 2016 19:32:18 +0000
Subject: Re: [PATCH] sctp: Remove some redundant code
Message-Id: <28e1309f-a084-2090-ce2a-a43c013ddc8e@wanadoo.fr>
List-Id: <linux-sctp.vger.kernel.org>
References: <1472981893-8608-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <20160915173428.GA3200@localhost.localdomain>
In-Reply-To: <20160915173428.GA3200@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo <marcelo.leitner@gmail.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

Le 15/09/2016 =E0 19:34, Marcelo a =E9crit :
> On Sun, Sep 04, 2016 at 11:38:13AM +0200, Christophe JAILLET wrote:
>> In commit 311b21774f13 ("sctp: simplify sk_receive_queue locking"), a ca=
ll
>> to 'skb_queue_splice_tail_init()' has been made explicit. Previously it =
was
>> hidden in 'sctp_skb_list_tail()'
>>
>> Now, the code around it looks redundant. The '_init()' part of
>> 'skb_queue_splice_tail_init()' should alreday do the same.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> I just noticed you didn't include netdev@ in the destinations.
>
> Is your patch going to be tracked somewhere else? It's not showing up in
> http://patchwork.ozlabs.org/project/netdev/list/?submitterf309&state=3D*&=
q=3D&archive=3D&delegate>
My fault, get_maintainer lists netdev@ but I missed it.

Should I resubmit or is it ok?

CJ

