From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 02 Aug 2017 13:28:04 +0000
Subject: Re: address already in use on previously used (but currently unused) IP:PORT combinations in sctp_bi
Message-Id: <CADvbK_cqGjWLKPyvMj=qDAmM1+Wf8Bfu72Gj9haZzx=JUt5YYQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
In-Reply-To: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Aug 2, 2017 at 7:43 AM, Franklin Marmon <marmon@hydeco.com> wrote:
> Hello,
>
> I'm having trouble with sctp_bindx() reporting address already in use when
> attempting to bind sockets. The IP:PORT combinations are not open, do not
> show up in /proc/net/sctp/assocs, netstat, ss, or lsof. The IP:PORTs were
> bound in a previous instance of the client application however that
> application itself has been killed and restarted. It is as if the kernel
> believes the IP:PORT pair is in use when, as far as I can tell, it isn't. If
> I change the ports used in my addresses to ports I have not used previously
> the bind succeeds without issue. Any suggestions on how I can tell what is
> holding the ports open, or how to reset the sctp port table in the kernel?
>
> Lksctp-tools verison: 1.0.16
> Kernel version: 4.4.6
Did you have sctp connection and sctp traffic before this binding ?
It maybe an asoc leak in 4.4.y kernel.
If it's reproducable, can you try against this commit(or with 4.8.y kernel)

commit b61c654f9b3f1a271217e46c893f80565b1f754d
Author: Xin Long <lucien.xin@gmail.com>
Date:   Wed Sep 14 02:04:20 2016 +0800

    sctp: free msg->chunks when sctp_primitive_SEND return err




> IP-Family: IPv4
> Number of addresses passed to sctp_bindx(): normally 2, have tested with
> each address individually
>
> frm
>
>
> Franklin Marmon
> The Hyde Company
> 331 East Broadway
> Missoula, MT 59801
>
> Office: 406.541.4777
> Cell: 406.493.2460
> http://www.hydeco.com
> marmon@hydeco.com
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
