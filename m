From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 15 Jan 2016 19:07:33 +0000
Subject: Re: net/sctp: sctp_datamsg memory leak
Message-Id: <20160115190733.GI6074@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+bhbOZAaV-KOFOS6ozqEqGa9dzjEFUkeH5b3_AbaWacJw@mail.gmail.com>
 <20160108152507.GB6074@mrl.redhat.com>
 <CACT4Y+abxekf8Cezxa+OdNsDDzLd_tVQVqWnxn2V5PyKGJv88Q@mail.gmail.com>
In-Reply-To: <CACT4Y+abxekf8Cezxa+OdNsDDzLd_tVQVqWnxn2V5PyKGJv88Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, Eric Dumazet <edumazet@google.com>

On Fri, Jan 15, 2016 at 07:55:56PM +0100, Dmitry Vyukov wrote:
> On Fri, Jan 8, 2016 at 4:25 PM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
...
> >>  \xe9\x32\
> >>  xde\x36",
> >> 251);
> >
> > Please clarify this line. It doesn't compile as-is and the len doesn't
> > match the data itself.
> 
> I am not sure why there a ! at the end of the line, it wasn't present
> in my original program.
> Here is a source that compiles for me with -Wall:
> https://gist.githubusercontent.com/dvyukov/662ee19898ed25f7db31/raw/3a6cbfa462f8eba67fda90f16198c62159b6b42f/gistfile1.txt
> 

Got it, thanks

