From: Felix Rossmann <rossmann@informatik.uni-bonn.de>
Date: Mon, 20 Apr 2015 08:57:25 +0000
Subject: SCTP-Connection not used anymore after FWDTSN-Chunk
Message-Id: <5534BF75.4080004@informatik.uni-bonn.de>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------090404040207050908020605"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------090404040207050908020605
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi at all,

I am currently extending the SCTP kernel module of kernel 3.13 for my 
bachelor thesis. Therefore I am using the PR-SCTP extension to add a new 
partial reliability service using the existing mechanisms.
To reduce side-effects I did not add much to the existing code/files, 
but new structures and constants (to hold the data for my service) and 
three hooks (function pointers) on reception of a SACK, generation of a 
new packet and sending of a new packet. So far I am only using the first 
one, reception of a SACK. I am sure that the hooks are in the right 
place and they get called when they should be.

Now to my problem: The whole thing works fine at first. The sender can 
successfully send DATA and at some point generate and send FORWARD 
TSN-chunks, the receiver gets all this and answers with a SACK (checked 
this via debug-outputs and tcpdump). After the FWD TSN, the sender does 
not send DATA-chunks anymore, but it certainly gets enough data to send 
from the application (one "packet" every 0.02 seconds). It replies to HB 
REQ from the receiver properly, but does not do anything else.
After a period of time (something around 10 minutes), it reinitializes 
the connection (new handshake). After that the same thing happens again 
(works fine until FWD TSN, then nothing, after some time new 
connection). The old connection does not seem to be ended in any way (no 
ABORT or SHUTDOWN).

The syslog does not show anything and the upper layer is not noticed.

Could you please help me with this? You find a version of my code in the 
attachments, if the problem is with abandoning the messages.
The algorithm gets a loss-rate limit and a calculation window.  that may 
get lost in

With best regards,
Felix Rossmann

------- Code attached: Maximum loss rate service; prsctp.c ---------
(Note: The header file is not included)

--------------090404040207050908020605
Content-Type: text/x-csrc;
 name="prsctp.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="prsctp.c"

/* SCTP kernel implementation extension
 *
 * This file extends the SCTP kernel implementation.
 *
 * The following structures and functions are used to implement
 * partial reliability services. These are used with function-hooks
 * so that a new service only needs to be specified here and the
 * corresponding header file.
 *
 * Note that any constants to determine the pr-policy should be defined
 * in the user API header.
 *
 * This SCTP implementation is free software;
 * you can redistribute it and/or modify it under the terms of
 * the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This SCTP implementation is distributed in the hope that it
 * will be useful, but WITHOUT ANY WARRANTY; without even the implied
 *                 ************************
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GNU CC; see the file COPYING.  If not, write to
 * the Free Software Foundation, 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Written or modified by:
 *    Felix Rossmann        <rossmann@cs.uni-bonn.de>
 */

#include <net/sctp/structs.h>
#include <net/sctp/prsctp.h>

#include <uapi/linux/sctp.h>
#include <net/sctp/sm.h>    /* For TSN comparisons */

static void sctp_insert_list (struct list_head *head, struct list_head *new);
static void chunk_to_abandoned_list (struct sctp_chunk *chunk, struct list_head *lchunk, struct sctp_outq *out_queue);
static __u32 mlr_amount_acked_in (struct sctp_outq *out_queue, __u32 start_tsn, __u32 end_tsn);
static void mlr_abandon_chunks (struct list_head *list, struct sctp_outq *out_queue, __u32 tsn, __u16 loss_rate, __u16 calculation_window);

/***************************************************
 * Handling the structures                         *
 ***************************************************/

/*
 * Pack algo-data in the common interface-structure sctp_default_prinfo
 * as defined in RFC 6458, section 8.1.32.
 */
struct sctp_default_prinfo prsctp_algo2default_prinfo (struct sctp_prsctp_algo prsctp_algo) {
    struct sctp_default_prinfo prinfo;
    prinfo.assoc_id = 0;
    prinfo.pr_policy = prsctp_algo.pr_policy;

    switch (prsctp_algo.pr_policy) {
        case SCTP_PR_SCTP_NONE:
            prinfo.pr_value = 0;
            break;
        case SCTP_PR_SCTP_TTL:
            prinfo.pr_value = prsctp_algo.params.ttl;
            break;
        case SCTP_PR_SCTP_MLR:
            // Use loss rate as higher 16 bytes and calculation_window as the lower ones.
            prinfo.pr_value = (prsctp_algo.params.mlr.loss_rate << 16) | prsctp_algo.params.mlr.calculation_window;
            break;
        default:
            prinfo.pr_value = 0;
            break;
    }
    return prinfo;
}

/*
 * Initialize the algorithm data for storing it in a sock- or assoc-structure.
 * The values are taken from the common interface-structure sctp_default_prinfo
 * as defined in RFC 6458, section 8.1.32.
 */
struct sctp_prsctp_algo sctp_pr_algo_init (struct sctp_default_prinfo prinfo) {
    struct sctp_prsctp_algo prsctp_algo;
    memset(&prsctp_algo, 0, sizeof(struct sctp_prsctp_algo));
    prsctp_algo.pr_policy = prinfo.pr_policy;

    switch (prinfo.pr_policy) {
        case SCTP_PR_SCTP_NONE:
            prsctp_algo.params.none = 0;
            break;
        case SCTP_PR_SCTP_TTL:
            prsctp_algo.params.ttl = prinfo.pr_value;

            prsctp_algo.new_chunk_handler   = sctp_pr_ttl_new_chunk;
            prsctp_algo.sent_packet_handler = sctp_pr_ttl_sent_packet;
            prsctp_algo.ack_chunk_handler   = stcp_pr_ttl_ack_chunk;
            break;
        case SCTP_PR_SCTP_MLR:
            // Use loss rate as higher 16 bytes and calculation_window as the lower ones.
            prsctp_algo.params.mlr.loss_rate          = prinfo.pr_value >> 16;      // Snip right bits
            prsctp_algo.params.mlr.calculation_window = prinfo.pr_value & 0xFFFF;   // Snip left  bits

            prsctp_algo.new_chunk_handler   = sctp_pr_mlr_new_chunk;
            prsctp_algo.sent_packet_handler = sctp_pr_mlr_sent_packet;
            prsctp_algo.ack_chunk_handler   = stcp_pr_mlr_ack_chunk;
            break;
        default:
            prinfo.pr_policy = SCTP_PR_SCTP_NONE;
            break;
    }

    return prsctp_algo;
}

/*
 * Function to deinitialize algorithm data. Currently only a stub as we do not
 * manually allocate memory.
 */
void sctp_pr_algo_deinit (struct sctp_prsctp_algo *prsctp_algo) {
    // Nothing to free at the moment.
    return;
}

/***************************************************
 * Helpers                                         *
 ***************************************************/

/* Insert a chunk into the sorted list based on the TSNs.  The retransmit list
 * and the abandoned list are in ascending order.
 */
static void sctp_insert_list (struct list_head *head, struct list_head *new) {
	struct list_head *pos;
	struct sctp_chunk *nchunk, *lchunk;
	__u32 ntsn, ltsn;
	int done = 0;

	nchunk = list_entry (new, struct sctp_chunk, transmitted_list);
	ntsn = ntohl (nchunk->subh.data_hdr->tsn);

	list_for_each (pos, head) {
		lchunk = list_entry (pos, struct sctp_chunk, transmitted_list);
		ltsn = ntohl (lchunk->subh.data_hdr->tsn);
		if (TSN_lt (ntsn, ltsn)) {
			list_add (new, pos->prev);
			done = 1;
			break;
		}
	}
	if (!done)
		list_add_tail (new, head);
}

/*
 * Function to move a chunk from its current list lchunk to the out_queue's
 * abandoned list.
 */
static void chunk_to_abandoned_list (struct sctp_chunk *chunk, struct list_head *lchunk, struct sctp_outq *out_queue) {
    if (!chunk->tsn_gap_acked) {
        if (chunk->transport)
            chunk->transport->flight_size -= sctp_data_size (chunk);

        out_queue->outstanding_bytes -= sctp_data_size (chunk);
        out_queue->asoc->peer.rwnd   += sctp_data_size (chunk);
    }

    /* Move the chunk to abandoned list. */
    list_del_init(lchunk);
    sctp_insert_list(&out_queue->abandoned, lchunk);
}

/*
 * Function to count chunks which are acknowledged in the calculation_window before
 * the given tsn.
 */
static __u32 mlr_amount_acked_in (struct sctp_outq *out_queue, __u32 start_tsn, __u32 end_tsn) {
    __u32 cur_tsn, tsn_ack, counter = 0;
	struct sctp_chunk *chunk;
	struct list_head *lchunk, *temp;

    /*
     * tsn_ack is the largest TSN before which all packets are acknowledged.
     */
	tsn_ack = out_queue->asoc->ctsn_ack_point;

    /*
     * If the calculation window is invalid or all TSNs before the given
     * one are acknowledged we give back "all" packets in calculation_window
     * as acknowledged.
     * In case of the first the unsignedness of the return value will cause
     * an absurdely high count, which will prevent errors in further procession.
     */
	if (TSN_lte (end_tsn, start_tsn) || TSN_lte (end_tsn, tsn_ack))
        return end_tsn - start_tsn;

    /*
     * If some part of the calculation window has been fully acknowledged
     * memorize it and check from the chunk after tsn_ack.
     */
    if (TSN_lte (start_tsn, tsn_ack)) {
        counter   = tsn_ack - start_tsn + 1;
        start_tsn = tsn_ack + 1;
    }

    /*
     * Count all chunks that have been acknowledged after the start_tsn (and the current
     * ctsn, as only those are in this queue).
     */
    list_for_each_safe (lchunk, temp, &out_queue->sacked) {
		chunk = list_entry (lchunk, struct sctp_chunk, transmitted_list);
        cur_tsn = ntohl (chunk->subh.data_hdr->tsn);

        if (TSN_lte (start_tsn, cur_tsn)) {
            if (TSN_lte (cur_tsn, end_tsn)) {
                // Chunk is in calculation window. Count it.
                counter++;
            } else {
                /* We are above the current tsn and since the list is ordered we can fully stop */
                break;
            }
        }
    }

    return counter;
}

/*
 * This function checks the given list for chunks to abandon (append at the tail of abandon_list)
 * in the calculation_window from the given tsn. It will not abandon more chunks than the maximum
 * tolerable loss_rate limit allows but as many as possible.
 */
static void mlr_abandon_chunks (struct list_head *list, struct sctp_outq *out_queue, __u32 tsn, __u16 loss_rate, __u16 calculation_window) {
    __u32 acknowledged_packets, cur_tsn, end_tsn;
	struct sctp_chunk *chunk;
	struct list_head *lchunk, *temp;

    end_tsn = tsn + calculation_window;

    /*
     * The enqueued chunks in the calculation_window above the newly acknowledged
     * chunk have to be checked and perhaps discarded.
     * For that iterate over the (data-)sending queues, check for the chunks if they are
     * in this window and decide whether we can drop them.
     */
    list_for_each_safe (lchunk, temp, list) {
		chunk = list_entry (lchunk, struct sctp_chunk, transmitted_list);
        cur_tsn = ntohl (chunk->subh.data_hdr->tsn);

        /* Do we have to do something with this chunk? Then check if we can drop it. */
        if (TSN_lt (tsn, cur_tsn) && TSN_lt (cur_tsn, end_tsn)) {
            /* Get how many chunks were acknowledged before the current one. */
            acknowledged_packets = mlr_amount_acked_in (out_queue, (cur_tsn - calculation_window + 1), cur_tsn);

            /* Are we below the allowed limit of loss? Then abandon the chunk. */
            if (calculation_window - acknowledged_packets <= loss_rate) {
                /* Drop it like it's hot. Or rather: Abandon message. */
                chunk->msg->expires_at = jiffies;
                chunk->msg->can_abandon = 1;

                // Drop this chunk immediately. We get other message-fragments later.
                chunk_to_abandoned_list (chunk, lchunk, out_queue);
            }
        }
    }

    // Cleanup all abandoned chunks. Can't get the right lists above.
    list_for_each_safe (lchunk, temp, list) {
		chunk = list_entry (lchunk, struct sctp_chunk, transmitted_list);

        if (sctp_chunk_abandoned(chunk)) {
            chunk_to_abandoned_list (chunk, lchunk, out_queue);
        }
    }
}

/***************************************************
 * Handling functions for the different algorithms *
 ***************************************************/

/***************************************************
 * TTL-Service (not implemented)                   *
 ***************************************************/
/*
 * These are just here as a stub, the ttl-service itself is NOT implemented.
 */
void sctp_pr_ttl_new_chunk   (struct sctp_chunk *chunk, union pr_params params) {}
void sctp_pr_ttl_sent_packet (struct sctp_packet *packet, union pr_params params) {}
void stcp_pr_ttl_ack_chunk   (struct sctp_outq *out_queue, __u32 tsn, union pr_params params) {}

/***************************************************
 * MLR-Service                                     *
 ***************************************************/
/*
 * The following functions are the functional heart of the maximum loss rate-
 * partial reliability-algorithm and define when a packet in the sending queue
 * should be abandoned.
 * They are to be used as the handlers of above structure in case of MLR-PR.
 */
void sctp_pr_mlr_new_chunk   (struct sctp_chunk *chunk, union pr_params params) {
    // Do not need to do anything.
}

void sctp_pr_mlr_sent_packet (struct sctp_packet *packet, union pr_params params) {
    // Neither here
}

/*
 * The implementation of the maximum loss-rate algorithm.
 * For a newly acknowledged chunk this function checks if other
 * chunks in the given calculation window can be abandoned while
 * keeping the absolute loss rate below the given limit.
 */
void stcp_pr_mlr_ack_chunk   (struct sctp_outq *out_queue, __u32 tsn, union pr_params params) {
    /*
     * The given uint16 loss_rate is in percent times 100 (for two decimal places).
     * We have to build some absolute count of packages that may get lost, as kernel
     * does not necessarily provide floating point operations.
     * This floors the number of losable packets, so we can be sure to reach the lr but
     * may be above it further than we want.
     */
    __u16 absolute_loss_rate = (params.mlr.loss_rate * params.mlr.calculation_window) / 10000;

    /* Check the retransmit data-sending queue for chunks to abandon. */
    mlr_abandon_chunks (&out_queue->retransmit,     out_queue, tsn, absolute_loss_rate, params.mlr.calculation_window);
    //mlr_abandon_chunks (&out_queue->out_chunk_list, out_queue, tsn, d_loss_rate, params.mlr.calculation_window);
}

--------------090404040207050908020605--
