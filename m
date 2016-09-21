From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 21 Sep 2016 17:28:12 +0000
Subject: Re: Address already in use problem
Message-Id: <CADvbK_fk1vQ2hR5yF0Z2agTOZdjSHNwnq-Nk5LQ_m3=jDSqUHg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+39Ed=6MDu6E9twGfhRu1yw4b=E5C8QNMQ-trxXVx08Q@mail.gmail.com>
 <20160921140426.GE9323@localhost.localdomain> <CAFXGft+AYwN4zkLD3d2xa=zbdj9YtRsTei6-Q+zvHFSqFqXbng@mail.gmail.com>
 <20160921142122.GF9323@localhost.localdomain>
In-Reply-To: <20160921142122.GF9323@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Sun Paul <paulrbk@gmail.com>, linux-sctp@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Sep 21, 2016 at 10:21 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Wed, Sep 21, 2016 at 10:15:43PM +0800, Sun Paul wrote:
>> Hi
>>
>> we are using redhat 2.6.32-642.4.2.el6.x86_64
>>
>> On Wed, Sep 21, 2016 at 10:04 PM, Marcelo Ricardo Leitner
>> <marcelo.leitner@gmail.com> wrote:
>> > Hi,
>> >
>> > Which kernel are you using? Depending on it, that may be fixed by a
>> > recent patchset from Xin Long, 'sctp: fix the transmit err process'
>> > patchset more exactly.
>> >
>> >   Marcelo
>
> Ah no, then that's another thing. If you cannot test/use an upstream
> kernel, then I'd recommend you to open a support case/bug with them.
>
It may be still this issue, I checked the codes of 2.6.32-642.
It's not using sctp_datamsg_free, which means once sctp_primitive_SEND
fail to send msg because of the asoc->state is unavailable, chunks have no
chance to be freed, and they hold asoc each one. so Address already in use.
