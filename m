From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 09 Sep 2015 21:14:18 +0000
Subject: Re: lksctp-tools:sctp_test fails when not using sock_stream
Message-Id: <20150909211418.GA4496@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
In-Reply-To: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Sep 09, 2015 at 01:43:01PM +0530, kunapaneni prashanth wrote:
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

It's not really necessary, specially when not using -T option. sendmsg()
can specify the destination too.

I cannot reproduce your issue here.  You can check with strace if
sendmsg() parameters are really there and so.

  Marcelo

