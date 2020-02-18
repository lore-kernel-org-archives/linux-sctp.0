From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 18 Feb 2020 03:40:01 +0000
Subject: Re: v5.3.12 SCTP Stream Negotiation Problem
Message-Id: <20200218034001.GA2547@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <29c18e4a424343bab0fea1904cfae492@nokia-sbell.com>
In-Reply-To: <29c18e4a424343bab0fea1904cfae492@nokia-sbell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Tue, Feb 18, 2020 at 12:37:17AM +0000, Fan, Jessie (NSB - CN/Qingdao) wrote:
> Hi, 
> 
> I found the SCTP Stream negotiation doesn't work as expected, that is, the local outbound stream and the remote inbound stream comparison seems missing.
> For example, when the local outstream(16) is greater than the remote inbound stream(2), 16 is saved and used as the "OUTS", which is shown from /proc/pid/net/sctp/assocs below.
> Can anyone help comment?
> 
> From local end point, 16 is set as both the outbound and inbound stream.
> From the remote end point, 2 is set for both the outbound and inbound stream
> 
> However, after the association is up, the inbound and outbound stream is set as (2,16), which I think is unexpected.
> sh-4.2# cat 1/net/sctp/assocs
> ASSOC SOCK STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID INODE LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC wmema wmemq sndbuf rcvbuf
> 55dae5bb bb3dec72 0 7 3 0 2415 0 0 504 1223451 2905 3904 xx.xx.xx.xx yy.yy.yy.yy <-> *zz.zz.zz.zz ww.ww.ww.ww 30000 2 16 10 0 0 0 1 0 262144 262144
> 
> I further checked the kernel code and found in v5.0, there is still comparison logic: min(outcnt, stream->outcnt) and save the smaller one in the function sctp_stream_alloc_out().
> But the logic disappeared in v5.1, and if the "outcnt" is smaller, it's not saved locally.
> static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
>                                 gfp_t gfp)
> {
>         int ret;
> 
>         if (outcnt <= stream->outcnt) //Here is problematic, and the outcnt is not saved locally.

Makes sense.
Before 2075e50caf5e ("sctp: convert to genradix") it was updating
stream->outcnt with smaller values when applicable:

-       if (outcnt > stream->outcnt)
-               fa_zero(out, stream->outcnt, (outcnt - stream->outcnt));
+       if (outcnt <= stream->outcnt)
+               return 0;

-       stream->out = out;

It also affects the input stream AFAICT.
Can you please try the following patch?

Thanks,
Marcelo

---8<---

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 67f7e71f9129..34f0b7312fe8 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -81,12 +81,13 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 	int ret;
 
 	if (outcnt <= stream->outcnt)
-		return 0;
+		goto out;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
 	if (ret)
 		return ret;
 
+out:
 	stream->outcnt = outcnt;
 	return 0;
 }
@@ -96,13 +97,14 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 {
 	int ret;
 
-	if (incnt <= stream->incnt)
-		return 0;
+	if (incnt > stream->incnt)
+		goto out;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
 	if (ret)
 		return ret;
 
+out:
 	stream->incnt = incnt;
 	return 0;
 }
