From: Al Gambardella <agam.email@gmail.com>
Date: Wed, 05 Oct 2016 16:34:03 +0000
Subject: Re: 64000 simultaneous connections
Message-Id: <CADz2ZUDB4niYx+cec=jLfi62Bhz9XkNrRA7TWB6Y2cOqXR2TzQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADz2ZUCDHyskrezX4mqFgnzHXZD3i=tC3MFXapDaEZniacyJBg@mail.gmail.com>
In-Reply-To: <CADz2ZUCDHyskrezX4mqFgnzHXZD3i=tC3MFXapDaEZniacyJBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Thanks for the reply.
In addition to the net.ipv4.ip_local_port_range there are parameters
to check such as: sctp.rto_initial and somaxconn. Also the number max
number of threads and file handles will have to been configured
appropriately. Does the SCTP source code itself have built in resource
limits or assumptions about max connections? I am trying to limit the
surprises that I know are going to come up as I do this. So any and
all suggestions are welcome.

Thanks


On Wed, Oct 5, 2016 at 11:38 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Wed, Oct 05, 2016 at 11:33:24AM -0400, Al Gambardella wrote:
>> Is there a how-to on what linux parameters and resources to check and
>> or modify to support 64000 simultaneous SCTP connections.
>>
>> Its for a load test scenario. Each connection would only have to
>> exchange one message with the remote side then just do keep alives.
>
> Seems at least sysctl net.ipv4.ip_local_port_range on client would have
> to be changed, or you would have to have tons of client IP addresses.
> Nothing else comes to mind, tough.
>
>   Marcelo
>
