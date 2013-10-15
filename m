From: Chang <changxiangzhong@gmail.com>
Date: Tue, 15 Oct 2013 14:27:09 +0000
Subject: Re: [PATCH] net: sctp: fix a cacc_saw_newack missetting issue
Message-Id: <525D50BD.5030301@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1381757623-12803-1-git-send-email-changxiangzhong@gmail.com> <525D4D2D.8000506@gmail.com>
In-Reply-To: <525D4D2D.8000506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, nhorman@tuxdriver.com
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org


On 10/15/2013 04:11 PM, Vlad Yasevich wrote:
> On 10/14/2013 09:33 AM, Chang Xiangzhong wrote:
>> For for each TSN t being newly acked (Not only cumulatively,
>> but also SELECTIVELY) cacc_saw_newack should be set to 1.
>>
>> Signed-off-by: Xiangzhong Chang <changxiangzhong@gmail.com>
>> ---
>>   net/sctp/outqueue.c |   42 +++++++++++++++++++++---------------------
>>   1 file changed, 21 insertions(+), 21 deletions(-)
>>
>> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
>> index 94df758..d86032b 100644
>> --- a/net/sctp/outqueue.c
>> +++ b/net/sctp/outqueue.c
>> @@ -1398,6 +1398,27 @@ static void sctp_check_transmitted(struct 
>> sctp_outq *q,
>>                   forward_progress = true;
>>               }
>>
>> +            if (!tchunk->tsn_gap_acked) {
>
> You can remove this test since the block just above already performs
> it.  Just fold this code into the block above.
>
> -vlad
>
Sorry, I'm not sure if I fully understand you. There are code blocks 
which checking the tchunk->tsn_gap_acked. In addition, they check other 
states as well.
>> +                /*
>> +                 * SFR-CACC algorithm:
>> +                 * 2) If the SACK contains gap acks
>> +                 * and the flag CHANGEOVER_ACTIVE is
>> +                 * set the receiver of the SACK MUST
>> +                 * take the following action:
>> +                 *
>> +                 * B) For each TSN t being acked that
>> +                 * has not been acked in any SACK so
>> +                 * far, set cacc_saw_newack to 1 for
>> +                 * the destination that the TSN was
>> +                 * sent to.
>> +                 */
>> +                if (transport &&
>> +                    sack->num_gap_ack_blocks &&
>> +                    q->asoc->peer.primary_path->cacc.
>> +                    changeover_active)
>> +                    transport->cacc.cacc_saw_newack    = 1;
>> +            }
>> +
>>               if (TSN_lte(tsn, sack_ctsn)) {
>>                   /* RFC 2960  6.3.2 Retransmission Timer Rules
>>                    *
>> @@ -1411,27 +1432,6 @@ static void sctp_check_transmitted(struct 
>> sctp_outq *q,
>>                   restart_timer = 1;
>>                   forward_progress = true;
>>
>> -                if (!tchunk->tsn_gap_acked) {
>> -                    /*
>> -                     * SFR-CACC algorithm:
>> -                     * 2) If the SACK contains gap acks
>> -                     * and the flag CHANGEOVER_ACTIVE is
>> -                     * set the receiver of the SACK MUST
>> -                     * take the following action:
>> -                     *
>> -                     * B) For each TSN t being acked that
>> -                     * has not been acked in any SACK so
>> -                     * far, set cacc_saw_newack to 1 for
>> -                     * the destination that the TSN was
>> -                     * sent to.
>> -                     */
>> -                    if (transport &&
>> -                        sack->num_gap_ack_blocks &&
>> - q->asoc->peer.primary_path->cacc.
>> -                        changeover_active)
>> -                        transport->cacc.cacc_saw_newack
>> -                            = 1;
>> -                }
>>
>> list_add_tail(&tchunk->transmitted_list,
>>                             &q->sacked);
>>
>

