From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 21 Sep 2016 15:43:04 +0000
Subject: Re: Address already in use problem
Message-Id: <20160921154304.GB13620@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+39Ed=6MDu6E9twGfhRu1yw4b=E5C8QNMQ-trxXVx08Q@mail.gmail.com>
In-Reply-To: <CAFXGft+39Ed=6MDu6E9twGfhRu1yw4b=E5C8QNMQ-trxXVx08Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sun Paul <paulrbk@gmail.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 21, 2016 at 09:44:30PM +0800, Sun Paul wrote:
> Hi
> 
> we have an SCTP application running in JAVA. and we found that there
> is a problem when we as a client trying to connect to a remote IP
> address.
> 
> If the remote IP address is not accessible, our application will keep
> retrying to connect using a self-defined local port address, says
> 51001,
> 
> We found that after sometimes, says 2 hrs, this port 51001 is never
> able to bind to us again. even we tried to restart the application.
> 
Sounds like you have another application that inadvertently bound to that port.
Its not a privlidged port, nor is it well known, so it seems plausible that
another application would eventually bind to it.  Thats not a bug, just the way
ip works.

run netstat -anp | grep 51001

And see what application is holding the port.

Neil

> Is there anyone know how we can resolve this?
> 
> -RBK
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
