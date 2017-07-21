From: fblistes@free.fr
Date: Fri, 21 Jul 2017 14:45:15 +0000
Subject: Re: help about a lockup in sctp module
Message-Id: <1c4dcd976b919337bdb4a849934cd30b@free.fr>
List-Id: <linux-sctp.vger.kernel.org>
References: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
In-Reply-To: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

     Hello Malc,

Le 2017-07-19 23:27, malc a écrit :

> Did Debian backport [1] to your kernel?
> 

Yes, I think so :

linux (3.16.7-ckt20-1+deb8u3) jessie-security; urgency=high

   [ Ben Hutchings ]
   * usb: serial: visor: fix crash on detecting device without write_urbs
     (CVE-2015-7566)
   * sctp: Prevent soft lockup when sctp_accept() is called during a 
timeout event       <- Here
     (CVE-2015-8767)
   * tty: Fix unsafe ldisc reference via ioctl(TIOCGETD) (CVE-2016-0723)

   [ Salvatore Bonaccorso ]
   * unix: properly account for FDs passed over unix sockets 
(CVE-2013-4312)
   * KEYS: Fix keyring ref leak in join_session_keyring() (CVE-2016-0728)

  -- Salvatore Bonaccorso <carnil@debian.org>  Sun, 17 Jan 2016 20:07:28 
+0100



> Can you reproduce it with anything more current?
We didn't reproduce yet the crash on a test platform (with same kernel), 
still trying… So we didn't try with a newer one.


As a side note, I didn't see your e-mail on ML ?!

      Fred.
