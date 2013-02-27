From: Dilip Daya <dilip.daya@hp.com>
Date: Wed, 27 Feb 2013 12:15:41 +0000
Subject: SCTP Auto Buffer Tuning
Message-Id: <1361967341.2923.9.camel@pro6455b.example.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Is SCTP Auto Buffer (Rx/Tx) Tuning implemented?
If 'yes' is there a way to disable auto-tuning, maybe via setting
SO_SNDBUF/SO_RCVBUF using setsockopt() ?

As per the following references, mentions lack of SCTP Auto-buffer
tuning:
http://heim.ifi.uio.no/michawe/research/projects/new-transport/implementing-sctp-auto-buffer-tuning.html
http://www.ietf.org/mail-archive/web/tsvwg/current/msg11212.html
http://www.nlnet.nl/project/sctp-linux/


Thanks.
-- 
-DilipD.



