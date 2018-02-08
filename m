From: Alexey Kodanev <alexey.kodanev@oracle.com>
Date: Thu, 08 Feb 2018 23:38:59 +0000
Subject: sctp: skb_over_panic on INIT/INIT_ACK packet sending
Message-Id: <6caa9366-1d75-f2c8-6c39-230524066119@oracle.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

Hi,

Got the following panic when the received INIT packet has a lot of
address parameters, so that the INIT_ACK chunksize exceeds
SCTP_MAX_CHUNK_LEN: 

[  597.804948] skbuff: skb_over_panic: text:00000000ffae06e4 len:120168 put:120156
               head:000000007aa47635 data:00000000d991c2de tail:0x1d640 end:0xfec0 dev:<NULL>
...
[  597.976970] ------------[ cut here ]------------
[  598.033408] kernel BUG at net/core/skbuff.c:104!
[  600.314841] Call Trace:
[  600.345829]  <IRQ>
[  600.371639]  ? sctp_packet_transmit+0x2095/0x26d0 [sctp]
[  600.436934]  skb_put+0x16c/0x200
[  600.477295]  sctp_packet_transmit+0x2095/0x26d0 [sctp]
[  600.540630]  ? sctp_packet_config+0x890/0x890 [sctp]
[  600.601781]  ? __sctp_packet_append_chunk+0x3b4/0xd00 [sctp]
[  600.671356]  ? sctp_cmp_addr_exact+0x3f/0x90 [sctp]
[  600.731482]  sctp_outq_flush+0x663/0x30d0 [sctp]
[  600.788565]  ? sctp_make_init+0xbf0/0xbf0 [sctp]
[  600.845555]  ? sctp_check_transmitted+0x18f0/0x18f0 [sctp]
[  600.912945]  ? sctp_outq_tail+0x631/0x9d0 [sctp]
[  600.969936]  sctp_cmd_interpreter.isra.22+0x3be1/0x5cb0 [sctp]
[  601.041593]  ? sctp_sf_do_5_1B_init+0x85f/0xc30 [sctp]
[  601.104837]  ? sctp_generate_t1_cookie_event+0x20/0x20 [sctp]
[  601.175436]  ? sctp_eat_data+0x1710/0x1710 [sctp]
[  601.233575]  sctp_do_sm+0x182/0x560 [sctp]
[  601.284328]  ? sctp_has_association+0x70/0x70 [sctp]
[  601.345586]  ? sctp_rcv+0xef4/0x32f0 [sctp]
[  601.397478]  ? sctp6_rcv+0xa/0x20 [sctp]
...

Here the chunk size for INIT_ACK packet may become too big, mostly
because of the cookielen. Tried on local machine so both addrlen
and cookielen was big: addrlen 39960 cookielen 80168.
 
Not sure how to fix it correctly, may be we need a check here
or add it to sctp_make_control()?

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 793b05e..c27564c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -475,6 +475,9 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
        if (num_ext)
                chunksize += SCTP_PAD4(sizeof(ext_param) + num_ext);
 
+       if (chunksize > SCTP_MAX_CHUNK_LEN)
+               goto nomem_chunk;
+
        /* Now allocate and fill out the chunk.  */
        retval = sctp_make_control(asoc, SCTP_CID_INIT_ACK, 0, chunksize, gfp);
        if (!retval)

And for INIT as well...

Otherwise this chunk goes to skb_packet_transmit() -> sctp_packet_pack()
where panic on

  skb_put_data(nskb, chunk->skb->data, chunk->skb->len);

nskb (head skb) was previously allocated with packet->size that looks
like getting the chunk size from u16 chunk_hdr->length.

Thanks,
Alexey
