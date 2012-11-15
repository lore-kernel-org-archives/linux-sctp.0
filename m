From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 15 Nov 2012 21:48:43 +0000
Subject: Re: [PATCHv2] sctp: fix /proc/net/sctp/ memory leak
Message-Id: <87k3tmedvo.fsf@xmission.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1352987345-11263-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1352987345-11263-1-git-send-email-tt.rantala@gmail.com> (Tommi
	Rantala's message of "Thu, 15 Nov 2012 15:49:05 +0200")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, Dave Jones <davej@redhat.com>

Tommi Rantala <tt.rantala@gmail.com> writes:

> Commit 13d782f ("sctp: Make the proc files per network namespace.")
> changed the /proc/net/sctp/ struct file_operations opener functions to
> use single_open_net() and seq_open_net().
>
> Avoid leaking memory by using single_release_net() and seq_release_net()
> as the release functions.
>
> Discovered with Trinity (the syscall fuzzer).

Doh!  Thanks for catching this.

Eric

> -	.release = single_release,
> +	.release = single_release_net,
>  };

> -	.release = seq_release,
> +	.release = seq_release_net,
>  };
>  
