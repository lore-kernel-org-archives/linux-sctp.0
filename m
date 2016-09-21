From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 21 Sep 2016 11:04:05 +0000
Subject: Re: [PATCH next 1/2] sctp: rename WORD_TRUNC/ROUND macros
Message-Id: <6b400c34-88a1-dd11-aa0c-0812a8736f24@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1474402102.git.marcelo.leitner@gmail.com>
 <29722e8df218640ef977cb125c77613a5225f6d3.1474402102.git.marcelo.leitner@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB0105BA5@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DB0105BA5@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, vyasevich@gmail.com, David Miller <davem@davemloft.net>

Em 21-09-2016 07:18, David Laight escreveu:
> From: Marcelo Ricardo Leitner
>> Sent: 20 September 2016 21:24
>> To something more meaningful these days, specially because this is
>> working on packet headers or lengths and which are not tied to any CPU
>> arch but to the protocol itself.
>>
>> So, WORD_TRUNC becomes SCTP_TRUNC4 and WORD_ROUND becomes SCTP_ALIGN4.
> ...
>>  /* Round an int up to the next multiple of 4.  */
>> -#define WORD_ROUND(s) (((s)+3)&~3)
>> +#define SCTP_ALIGN4(s) (((s)+3)&~3)
>
> SCTP_PAD4() might be a better name.

Right. Will post a v3 with it. Thanks

   Marcelo
