From: Holger Hans Peter Freyther <holger@freyther.de>
Date: Wed, 12 Jan 2011 14:35:26 +0000
Subject: Re: Question regarding struct sctp_association
Message-Id: <4D2DBC2E.5000107@freyther.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D2AF2C3.8010306@freyther.de>
In-Reply-To: <4D2AF2C3.8010306@freyther.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/12/2011 02:00 AM, Wei Yongjun wrote:

>>                 /* Restart the AUTOCLOSE timer when sending data. */
>> -               if (sctp_state(asoc, ESTABLISHED) && asoc->autoclose) {
>> +               if (asoc && sctp_state(asoc, ESTABLISHED) && asoc->autoclose) {
>>                         timer = &asoc->timers[SCTP_EVENT_TIMEOUT_AUTOCLOSE];
>>                         timeout = asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE];
>>
>>
>> Can an OOTB packet contain data chunks that would make us go through this path?
> 
> AUTOCLOSE timer is only start when we have association, so this will
> not happen.

I am not sure, that is why I am asking. It appears that if there is any DATA
Chunk in the packet to send the code attempts to access 'asoc'. Can this code
path be ever triggered with an OOTB packet?

sorry if that question is too stupid

z.
