From: Sun Paul <paulrbk@gmail.com>
Date: Fri, 06 Jan 2017 09:34:47 +0000
Subject: Problem on SCTP
Message-Id: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Hi

I am setting up a lab where the SCTP traffics from  client is passing
through a linux router before reaching to the SCTP server running
LKSCTP.

The linux router did not change the source address of the client, so
when it arrived to the SCTP server, the source address is the oriingal
one.

however, I found that there is no response from the SCTP server, any
idea on this?

if I connect the client directly to the SCTP server, it do not have any issue.

help pls

rbk
