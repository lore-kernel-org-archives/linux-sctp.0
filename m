From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Thu, 09 Aug 2018 08:39:08 +0000
Subject: Re: [PATCH v2 1/2] net/sctp: Make wrappers for accessing in/out streams
Message-Id: <926150d0-646d-b2bd-03ba-995c2eb55b72@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
 <20180803162102.19540-2-khorenko@virtuozzo.com>
 <20180803.125000.55557304308180305.davem@davemloft.net>
In-Reply-To: <20180803.125000.55557304308180305.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, David Laight <David.Laight@ACULAB.COM>
Cc: marcelo.leitner@gmail.com, oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, lucien.xin@gmail.com, aryabinin@virtuozzo.com

On 08/03/2018 10:50 PM, David Miller wrote:
> From: Konstantin Khorenko <khorenko@virtuozzo.com>
> Date: Fri,  3 Aug 2018 19:21:01 +0300
>
>> +struct sctp_stream_out *sctp_stream_out(const struct sctp_stream *stream,
>> +					__u16 sid)
>> +{
>> +	return ((struct sctp_stream_out *)(stream->out)) + sid;
>> +}
>> +
>> +struct sctp_stream_in *sctp_stream_in(const struct sctp_stream *stream,
>> +				      __u16 sid)
>> +{
>> +	return ((struct sctp_stream_in *)(stream->in)) + sid;
>> +}
>
> I agree with David that these should be in a header file, and marked
> inline.

David and David,

sure, will move them, thank you!

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team

