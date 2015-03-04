From: =?UTF-8?Q?D=C3=A1vid_Fekete?= <dfekete88@gmail.com>
Date: Wed, 04 Mar 2015 14:18:24 +0000
Subject: unexpected notification
Message-Id: <CADV_2PSg0XQ9BT6fci=k9zXvzHC2gOp7Q7UEhu80oxG+mXa=yg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I have written an application which is based an one-to-many sctp application.
In the first phase I tested my socket which one represents multiple
associations .
So I connected to different servers from the same socket with multiple
calling of connect function. (addresses were different)
Then I got messages from all servers and it worked fine.
When I started to answer a to the servers, I mean I extended my code
with sending, I got SCTP_PARTIAL_DELIVERY_EVENT from servers. It comes
continuously.
What can be the reason behind of this?
I have checked this with messages which can be checked visually and it
seems to work perfectly.

It is like the reverse of the first situation, not from different
servers to one socket, but from one socket to all servers. The later
one works, I mean the message go well, but there are those
notifications

I am using sctp_sendmsg/recmsg functions.

David
