From: Diego Elio =?UTF-8?Q?=E2=80=9CFlameeyes=E2=80=9D_?=
Date: Thu, 24 Jun 2010 14:03:32 +0000
Subject: accept(2) man page and SCTP (was Re: [PATCH] sctp: implement
Message-Id: <1277388212.13544.77.camel@yamato.local>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Il giorno gio, 24/06/2010 alle 09.58 -0400, Vlad Yasevich ha scritto:
> 
> I don't think the man page needs an update.  This is just an SCTP-ism.
> There are other protocols using SOCK_SEQPACKET that implement and
> support
> accept() call. 

Maybe a note in the page then? I actually ended up spending a whole
night trying to debug the issue before being certain that accept()
failed to work with SEQPACKET...

-- 
Diego Elio Pettenò — “Flameeyes”
http://blog.flameeyes.eu/

If you found a .asc file in this mail and know not what it is,
it's a GnuPG digital signature: http://www.gnupg.org/


