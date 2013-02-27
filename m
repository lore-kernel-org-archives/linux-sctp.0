From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 27 Feb 2013 20:37:05 +0000
Subject: Re: [PATCH] net/sctp: Validate parameter size for SCTP_GET_ASSOC_STATS control message
Message-Id: <512E6E71.2080007@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361994231-5355-1-git-send-email-linux@roeck-us.net> <20130227200931.GB7993@hmsreliant.think-freely.org> <20130227202255.GA31830@roeck-us.net>
In-Reply-To: <20130227202255.GA31830@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Guenter Roeck <linux@roeck-us.net>
Cc: Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>

On 02/27/2013 03:22 PM, Guenter Roeck wrote:
> On Wed, Feb 27, 2013 at 03:09:31PM -0500, Neil Horman wrote:
>> On Wed, Feb 27, 2013 at 11:43:51AM -0800, Guenter Roeck wrote:
>>> Building sctp may fail with:
>>>
>>> In function ‘copy_from_user’,
>>>      inlined from ‘sctp_getsockopt_assoc_stats’ at
>>>      net/sctp/socket.c:5656:20:
>>> arch/x86/include/asm/uaccess_32.h:211:26: error: call to
>>>      ‘copy_from_user_overflow’ declared with attribute error: copy_from_user()
>>>      buffer size is not provably correct
>>>
>>> if built with W=1 due to a missing parameter size validation.
>>>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>>   net/sctp/socket.c |    2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>>> index cedd9bf..0a5f2bf 100644
>>> --- a/net/sctp/socket.c
>>> +++ b/net/sctp/socket.c
>>> @@ -5652,6 +5652,8 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
>>>   	/* User must provide at least the assoc id */
>>>   	if (len < sizeof(sctp_assoc_t))
>>>   		return -EINVAL;
>>> +	if (len > sizeof(struct sctp_assoc_stats))
>>> +		len = sizeof(struct sctp_assoc_stats);
>>>
>>>   	if (copy_from_user(&sas, optval, len))
>>>   		return -EFAULT;
>>> --
>>> 1.7.9.7
>>>
>>>
>>
>> Theres more than that going on here.  This will fix the warning, but the
>> function is written such that, if you pass in a size that is greater than the
>> size of a struct sctp_association, but less than a struct sctp_assoc_stats.  I'm
>> not sure that a partial stat struct is really that useful to people.  What if
>> you were to check for max(struct sctp_association, struct sctp_assoc_stats) as
>> your minimum length check, then just did a copy_from_user of that length.  It
>> would save you having to compute two lengths separately, since you could then
>> just do a copy_to_user(...,sizeof(struct sctp_assoc_stats), at the bottom of
>> that function.
>>
> Yes, but that would require input from someone who knows the code. All I am trying
> to accomplish is to ensure that copy_from_user does not overwrite the stack.
>

The function already has the following in it:

	/* Allow the struct to grow and fill in as much as possible */
         len = min_t(size_t, len, sizeof(sas));


It would be better to move that up to before the copy_from_user.
The alternative would be to do:
	if (copy_from_user(&sas, optval, sizeof(sctp_assoc_t))

since all we are after here is an association id and nothing else.

-vlad

> Thanks,
> Guenter
>

