From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 15 Aug 2013 11:42:08 +0000
Subject: Re: one-to-many question
Message-Id: <520CBE90.9020509@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <520CAC87.5020402@skyge.com>
In-Reply-To: <520CAC87.5020402@skyge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 08/15/2013 12:25 PM, xiong wei wrote:
> Hi, experts
>
> For one-to-many mode. Suppose I have a socket which contain several
> associations in it. that means there are several clients connect with
> server.
>
> If I use sendmsg(...) function to send msg from server, How does sctp
> identify which association will receive the data? Does all clients will
> receive the msg?
>
> And, Does sctp provide a way for server to send msg to all associations
> in one syscall ?

Neil Horman wrote:

The receiving association is specified in either the msg_name field of the
message header or the association id field of the sndrcv_info cmsg header in the
datagram.  IIRC there is no was to send to all associations at once in a single
syscall, unless you want to marshall up all the data and pass it down via the
sendmmsg syscall, which I don't think lksctp-tools supports yet (though that
would be a nice feature).
Neil
