From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 09 Sep 2015 21:19:03 +0000
Subject: Re: lksctp-tools:sctp_test fails when not using sock_stream
Message-Id: <55F0A247.1020605@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
In-Reply-To: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 09/09/2015 04:13 AM, kunapaneni prashanth wrote:
> Hi,
>  in our setup, i am trying out sctp tests using lksctp tools between
> two hosts connected back to back.
> 
> H1(5.5.5.8)  --------------   H2 (5.5.5.5)
> 
> 
> following are the commands i used.
> 
> Case 1:
> ====> client:
> sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s
> 
> server:
> sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l
> 
> 
> This test case fails, with client sending a abort after INIT/INIT-ACK.
> 
> If i run same test case with "-T" option, it is successful.

The test runs fine in my environment.  Which kernel are you using?

> 
> i,e
> Case 2:
> ====
> client:
> sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s -T
> 
> server:
> sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l
> 
> 
> 
> 
> i observed that in case 1, sctp_test never calls "connect", why is it
> so? shouldnt a connect be called.
> 

No, the connect is not required when using SOCK_SEQPACKET sockets and
that is what the test tries to do.  Forcing it to always connect isn't
the right thing.  You need to figure our why you are getting an ABORT.

-vlad

>
> 
> I modified the code as follows to make sure a connect is issued. After
> this everything works fine.
> 
> Please confirm.
> 
> 1386c1386
> <         if (socket_type = SOCK_STREAM || connectx_count = 0)
> ---
>>         if (socket_type = SOCK_STREAM && connectx_count = 0)
> 
> 


> Thank you,
> Prashanth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

