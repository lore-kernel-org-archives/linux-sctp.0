From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 17 May 2018 07:43:20 +0000
Subject: Re: SCTP nailed down connections trouble
Message-Id: <CADvbK_d11bnCV2vOVJGRHGasgj5JvRzosoMKt0JhEYW160JuMA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
In-Reply-To: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, May 17, 2018 at 1:17 AM, Andreas Fink <afink@list.fink.org> wrote:
>
>> ...
>>> A second area where I found issues is on how to configure a specific
>>> port to be used for multiple connections. For example my local port
>>> 2000 can be used for a connection to host 1 or to host 2 and the
>>> individual sessions which are created as above will however not
>>> allow me to use the same port in a second socket even though the
>>> bind is not follwed with a listen and the sctp_connectx goes to  a
>>> different port. Workaround to this is to use different ports for
>>> every connection (which is not really nice). Maybe there's another
>>> way?
>>
>> Needs to check on this.
>
> Could that be related to the missing SCTP_REUSE_PORT socket option?
>
That's right, but SO_REUSEADDR works as the equivalent of
SCTP_REUSE_PORT for SCTP in linux, and for now you can work around by:

        if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val)) = -1) {
                perror("reuse port failed");
                exit(-1);
        }

I'll add SCTP_REUSE_PORT sockopt in linux SCTP soon. Thanks.
