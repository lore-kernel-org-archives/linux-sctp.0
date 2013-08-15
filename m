From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Thu, 15 Aug 2013 11:42:39 +0000
Subject: Re: one-to-many question
Message-Id: <64A7EEF5-F4DA-4A6B-96A1-420E05DC0D7A@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <520CAC87.5020402@skyge.com>
In-Reply-To: <520CAC87.5020402@skyge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Aug 15, 2013, at 12:25 PM, xiong wei <xiongwei@skyge.com> wrote:

> Hi, experts
> 
> For one-to-many mode. Suppose I have a socket which contain several
> associations in it. that means there are several clients connect with
> server.
> 
> If I use sendmsg(...) function to send msg from server, How does sctp
> identify which association will receive the data? Does all clients will
> receive the msg?
You can use the deprecated cmsg SCTP_SNDRCV and specify the association id.
See http://tools.ietf.org/html/rfc6458#section-5.3.2
I'm not sure if Linux supports the newer cmsg SCTP_SNDINFO yet.
See http://tools.ietf.org/html/rfc6458#section-5.3.4
> 
> And, Does sctp provide a way for server to send msg to all associations
> in one syscall ?
To send the message on all associations, you can set the SCTP_SENDALL
flags. See the above references. I'm not sure if this flag is supported
by Linux or not.

Best regards
Michael
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

