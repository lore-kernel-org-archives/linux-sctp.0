From: Sun Paul <paulrbk@gmail.com>
Date: Wed, 21 Sep 2016 14:15:43 +0000
Subject: Re: Address already in use problem
Message-Id: <CAFXGft+AYwN4zkLD3d2xa=zbdj9YtRsTei6-Q+zvHFSqFqXbng@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+39Ed=6MDu6E9twGfhRu1yw4b=E5C8QNMQ-trxXVx08Q@mail.gmail.com>
 <20160921140426.GE9323@localhost.localdomain>
In-Reply-To: <20160921140426.GE9323@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Hi

we are using redhat 2.6.32-642.4.2.el6.x86_64

On Wed, Sep 21, 2016 at 10:04 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> Hi,
>
> On Wed, Sep 21, 2016 at 09:44:30PM +0800, Sun Paul wrote:
>> Hi
>>
>> we have an SCTP application running in JAVA. and we found that there
>> is a problem when we as a client trying to connect to a remote IP
>> address.
>>
>> If the remote IP address is not accessible, our application will keep
>> retrying to connect using a self-defined local port address, says
>> 51001,
>>
>> We found that after sometimes, says 2 hrs, this port 51001 is never
>> able to bind to us again. even we tried to restart the application.
>>
>> Is there anyone know how we can resolve this?
>
> Which kernel are you using? Depending on it, that may be fixed by a
> recent patchset from Xin Long, 'sctp: fix the transmit err process'
> patchset more exactly.
>
>   Marcelo
>
