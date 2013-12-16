From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 16 Dec 2013 15:19:19 +0000
Subject: Re: undetected closed apps
Message-Id: <52AF19F7.5070405@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/14/2013 10:04 AM, Jamal Hadi Salim wrote:
> 
> Folks,
> 
> I have a problem which manifests in kernels > 3.8. I am no sure how
> best to debug it.

Hi Jamal

The only thing I can think off that may be causing this is the
rcu-fication of the transport list in the associations.

You might be able to test by reverting:
  771085d6bf3c52de29fc213e5bad07a82e57c23e
  8c98653f05534acd1cb07ea4929702a3659177d1
  45122ca26ced7fae41049326a3797a73f961db2e


-vlad


> I have looked at strace and dont see anything different between when it
> works (kernels <= 3.8) and when it doesnt (kernels > 3.8).
> When i dump /proc/net/sctp/assocs I can see in the non-working case
> the socket is still there - which means there is no way for the server
> to be notified.
> If kill the server, the socket disappears.
> 
> Is there something else that would help narrow this down?
> 
> cheers,
> jamal
> 
> PS:
> Essentially I have a client app that does some nasty stuff (on purpose
> to test robustness). Client and server are connected locally within same
> machine.
> Client sends as fast as it can packets with partial reliability (timeout
> of about 100ms). The only time client checks for any kernel obsoleted
> msgs is when the send socket queue write will block.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

