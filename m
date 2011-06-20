From: Max Matveev <makc@redhat.com>
Date: Mon, 20 Jun 2011 08:14:57 +0000
Subject: [PATCH] Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem tunables
Message-Id: <19967.385.752160.374716@regina.usersys.redhat.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="/xXB1/ZINa"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--/xXB1/ZINa
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

        
    sctp does not use second and third ("default" and "max") values
    of sctp_(r|w)mem tunables. The format is the same and tcp_(r|w)mem
    but the meaning is different so make the documentation explicit to
    avoid confusion.
    
    Signed-off-by: Max Matveev <makc@redhat.com>


--/xXB1/ZINa
Content-Type: text/patch; name="sctp-sysctl-documentation.patch"
Content-Disposition: inline;
	filename="sctp-sysctl-documentation.patch"
Content-Transfer-Encoding: 7bit


--/xXB1/ZINa--
