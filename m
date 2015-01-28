From: Saran Maruti Ramanara <Saran.Neti@telus.com>
Date: Wed, 28 Jan 2015 16:45:42 +0000
Subject: SCTP ASCONF Set Primary Address Parameter Type bug
Message-Id: <4BC5337E23A5EE4A96D91D9DABA8FAE561E6B67FBD@WP40068.corp.ads>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

While investigating CVE-2014-7841 patched by e40607cbe270, I noticed that in sctp_process_param() in the switch-case where param.p->type = SCTP_PARAM_SET_PRIMARY (0xC004), the argument to param_type2af() is param.p->type, which is always 0xC004 in this case, and not addr_param's type. This causes af to always be NULL, i.e. even when IPv4 or IPv6 Address sub-parameters are received. 

The following patch--untested for functionality, compiles against c59c961ca511--gets the right Address Parameter type through to param_type2af(). 

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index e49e231..06320c8 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2608,7 +2608,7 @@ do_addr_param:
 
        addr_param = param.v + sizeof(sctp_addip_param_t);
 
-       af = sctp_get_af_specific(param_type2af(param.p->type));
+       af = sctp_get_af_specific(param_type2af(addr_param->p.type));
        if (af = NULL)
            break;

--
Regards,
Saran Neti, TELUS Security Labs
