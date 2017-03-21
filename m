From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 21 Mar 2017 06:01:07 +0000
Subject: Re: SCTP MSG_MORE code
Message-Id: <CADvbK_ffK4Cw6FmwDUw-hDJBANqWpxrCMMzFQ5ikb7jD_tSdkQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DCFFB5839@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DCFFB5839@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Tue, Mar 21, 2017 at 1:49 AM, David Laight <David.Laight@aculab.com> wrote:
> Something needs to be done with SCTP MSG_MORE before the end of the rc cycle.
> The current code is definitely broken.
agreed.

>
> I objected to the last 'fix' patch because it clears the flag is a place where
> I don't think it is necessary to do so - so could generate extra ethernet frames.
>
Sorry, can you double check the last 'fix' patch ?
I could not get 'generate extra ethernet frames'.

if we keep sending data with "MSG_MORE", after one ethernet frame
is sent, "followed by a second ethernet frame with 1 chunk in it" will NOT
happen, as in this loop the asoc's msg_more flag is still set, and this flush
is called by sctp_sendmsg(the function msg_more should care more).


If your point about "generate extra ethernet frames"  is right, sure, I will
change the way to fix that. but before this, pls check it again, appreciate it.

>         David
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
