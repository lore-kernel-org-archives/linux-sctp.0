From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 06 Jan 2017 12:37:11 +0000
Subject: Re: Problem on SCTP
Message-Id: <20170106123711.GA15139@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
In-Reply-To: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sun Paul <paulrbk@gmail.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 06, 2017 at 05:34:47PM +0800, Sun Paul wrote:
> Hi
> 
> I am setting up a lab where the SCTP traffics from  client is passing
> through a linux router before reaching to the SCTP server running
> LKSCTP.
> 
> The linux router did not change the source address of the client, so
> when it arrived to the SCTP server, the source address is the oriingal
> one.
> 
> however, I found that there is no response from the SCTP server, any
> idea on this?
> 
> if I connect the client directly to the SCTP server, it do not have any issue.
> 
> help pls
> 
> rbk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Start with a tcpdump on the client and the server and attempt a connection,
check to see if the INIT and INIT-ACK chunks are arriving appropriately.

Neil

