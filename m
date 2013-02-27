From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 27 Feb 2013 13:19:18 +0000
Subject: Re: SCTP Auto Buffer Tuning
Message-Id: <512E07D6.6080904@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361967341.2923.9.camel@pro6455b.example.com>
In-Reply-To: <1361967341.2923.9.camel@pro6455b.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 02/27/2013 07:15 AM, Dilip Daya wrote:
> Is SCTP Auto Buffer (Rx/Tx) Tuning implemented?

No, it is currently not implemented.

> If 'yes' is there a way to disable auto-tuning, maybe via setting
> SO_SNDBUF/SO_RCVBUF using setsockopt() ?

Typically it is/would be disabled via SO_RCVBUF call.

-vlad

>
> As per the following references, mentions lack of SCTP Auto-buffer
> tuning:
> http://heim.ifi.uio.no/michawe/research/projects/new-transport/implementing-sctp-auto-buffer-tuning.html
> http://www.ietf.org/mail-archive/web/tsvwg/current/msg11212.html
> http://www.nlnet.nl/project/sctp-linux/
>
>
> Thanks.
>

