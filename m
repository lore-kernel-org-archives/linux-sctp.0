From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 22 Jul 2014 16:41:12 +0000
Subject: Re: [PATCH net] net: sctp: inherit auth_capable on INIT collisions
Message-Id: <53CE9428.9060809@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1405620319-2021-1-git-send-email-dborkman@redhat.com> <53C93157.1050002@gmail.com> <53C972BE.5090700@redhat.com> <53C998DE.2030805@gmail.com> <53CE6632.1060707@redhat.com>
In-Reply-To: <53CE6632.1060707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, jgunthorpe@obsidianresearch.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 07/22/2014 09:25 AM, Daniel Borkmann wrote:
> Hi Vlad,
> 
> On 07/18/2014 11:59 PM, Vlad Yasevich wrote:
> ...
>> So I think I know why case D ends up not authenticating the COOKIE-ACK.
>> Most likely the reason is the following statement:
>>   repl = sctp_make_cookie_ack(new_asoc, chunk);
>>
>> Note that we use new_asoc, instead of current asoc.
> 
> Are you sending out a patch for this?

I didn't plan on it since you said there are further issues.  I thought you
were still looking.

-vlad

> 
> Thanks,
> 
> Daniel

