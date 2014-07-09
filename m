From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 09 Jul 2014 13:59:44 +0000
Subject: Re: [PATCH net-next 2/5] net: sctp: implement rfc6458, 5.3.4. SCTP_SNDINFO cmsg support
Message-Id: <53BD4AD0.9020201@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
In-Reply-To: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 07/08/2014 09:30 AM, David Laight wrote:
> From: David Laight
>> Some actions do need deferring - for instance sending SACK should be deferred
>> until all the data chunks have been processed.
> 
> That does seem to happen with a 3.14 kernel.
> My 'other' test system in running 2.6.26 and probably sends multiple sacks
> for packets containing a lot of data chunks.
> 
> 	David

That shouldn't happen even in 2.6.26.  SACKs were always per packet, not per chunk

-vlad

