From: Sun Paul <paulrbk@gmail.com>
Date: Wed, 21 Sep 2016 13:44:30 +0000
Subject: Address already in use problem
Message-Id: <CAFXGft+39Ed=6MDu6E9twGfhRu1yw4b=E5C8QNMQ-trxXVx08Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Hi

we have an SCTP application running in JAVA. and we found that there
is a problem when we as a client trying to connect to a remote IP
address.

If the remote IP address is not accessible, our application will keep
retrying to connect using a self-defined local port address, says
51001,

We found that after sometimes, says 2 hrs, this port 51001 is never
able to bind to us again. even we tried to restart the application.

Is there anyone know how we can resolve this?

-RBK
