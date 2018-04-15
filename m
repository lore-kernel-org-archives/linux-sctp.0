From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 15 Apr 2018 21:01:47 +0000
Subject: Re: Doubt about data chunks
Message-Id: <F65D0A60-4D56-4B33-B369-9A2CFB51808E@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAMMnvdWFCUudguj+TJ9fjmhJ8M5MYROOfoZu5F5XRKvN-DC36A@mail.gmail.com>
In-Reply-To: <CAMMnvdWFCUudguj+TJ9fjmhJ8M5MYROOfoZu5F5XRKvN-DC36A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 15. Apr 2018, at 22:41, Pedro Henrique <phamorimrezende@gmail.com> wrote:
> 
> Dear members,
> 
> I'm very new to SCTP and don't know if what I'm trying to do is really
> possible without extending the lksctp. Basically, I created a
> connection between two hosts (Client and Server) via the SCTP socket.
> I'm able to successfully send sctp data from the server to the client.
> Moreover, I also created multiple streams on the same connection. Now,
> here is the issue. According to the SCTP documentation, many data
> chunks can be sent inside the same packet. However, for my
> experiments, I would like that only the data chunks belonging to the
> same stream ID are encapsulated in the same packet. Or, in the worst
> case, only one data chunk is encapsulated in each packet. Is any of
> these two approaches possible without changing the lksctp code? If
> not, could someone please help me on how to implement one of these
> approaches in lksctp?
Sounds like you are looking for support of
https://tools.ietf.org/html/rfc8260#section-3.3

Not sure it is implemented yet.

Best regards
Michael
> 
> Thank you,
> Regards,
> 
> -- 
> Pedro Henrique Amorim Rezende
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

