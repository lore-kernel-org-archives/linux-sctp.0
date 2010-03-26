From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 26 Mar 2010 14:36:05 +0000
Subject: Re: connect() hangs after binding to three IP addresses and auth_enable
Message-Id: <4BACC655.1050607@hp.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------060508010501070209030107"
List-Id: <linux-sctp.vger.kernel.org>
References: <001701cacc68$d6bb1390$84313ab0$@com>
In-Reply-To: <001701cacc68$d6bb1390$84313ab0$@com>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------060508010501070209030107
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit

Hi George

George Cheimonidis wrote:
> Hi Vlad!
> 
> I am sending this email, after the discussion that we had in the forum
> thread
> https://sourceforge.net/projects/lksctp/forums/forum/83479/topic/3615562.
> This was related to the problem that I faced when using connect() after
> binding to three IP addresses  (two IPv4 and one IPv6). The problem seemed
> to occur when auth_enable is set. 
> I am willing to rebuild the SCTP module with the patches that you mentioned.
> Please provide me with some instructions on how to apply these patches, if
> possible.
> 
> Best regards,
> George 
> 


Here is a debug patch that should apply against either 2.6.31 or 2.6.33.
To apply it, you'll need the Ubuntu sources or sources from kernel.org

To apply them, just use
	$ patch -p1 < patchfile

Then rebuild the kernel or just the sctp module if you don't want to wait too
long.  To build the module you do
	$ make net/sctp/sctp.ko

Thanks for doing this.
-vlad

--------------060508010501070209030107
Content-Type: text/plain;
 name="patchfile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patchfile"

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9e73291..22a30ac 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -228,6 +228,8 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 		chunksize += sizeof(aiparam);
 
 	chunksize += vparam_len;
+	
+	printk("DEBUG: INIT size prior to Auth %zd\n", chunksize);
 
 	/* Account for AUTH related parameters */
 	if (sctp_auth_enable) {
@@ -256,6 +258,9 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	if (num_ext)
 		chunksize += sizeof(sctp_supported_ext_param_t) + num_ext;
 
+	printk("DEBUG: INIT size after AUTH and extensions(%d) %zd",
+			num_ext, chunksize);
+
 	/* RFC 2960 3.3.2 Initiation (INIT) (1)
 	 *
 	 * Note 3: An INIT chunk MUST NOT contain more than one Host

--------------060508010501070209030107--
