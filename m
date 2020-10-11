From: Andreas Fink <afink@list.fink.org>
Date: Sun, 11 Oct 2020 08:33:22 +0000
Subject: Re: sctp discarding received data chunks
Message-Id: <DBE38DD7-A378-4269-A839-4CB0A41D948B@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <e377e7e2a87e4f078e7a6d82992cfda0@AcuMS.aculab.com>
In-Reply-To: <e377e7e2a87e4f078e7a6d82992cfda0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> 
> Extremely unlikely.
> 
> Looking at the latest version of my driver code
> (which I wasn't using) I wrote the following:
> 
> * Since the code that negotiates the number of streams got broken
> * in version 5.1 we need to extract the correct value from the
> * internal structures to avoid SCTP sending messages the remote
> * system will discard.
> 
>    /* stream.outcnt is the value we should be using.
>     * But kernels 5.1 to 5.8 fail to reduce it based on the number
>     * received from the remote system.
>     * So bound here so that transmitted messages don't get discarded. */
>    outcnt = asoc->stream.outcnt;
>    num_ostreams = asoc->c.sinit_num_ostreams;
> 
> I think there was a patch done for 5.9.
> It needs back-porting.
> 
> Although Andreas said 5.4 worked for him.
> So maybe he has a different problem.
> 

In my application code, I never use anything else than stream 0 and 1
So I see some other issue in kernel 5.8 which makes it go haywire.
