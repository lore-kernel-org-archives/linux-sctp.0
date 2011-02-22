From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 22 Feb 2011 13:36:09 +0000
Subject: Re: [PATCH][RFC] sctp: fix reporting of unknown parameters
Message-Id: <4D63BBC9.3020209@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110217231208.GA28281@midget.suse.cz>
In-Reply-To: <20110217231208.GA28281@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 02/19/2011 10:07 PM, Shan Wei wrote:
> 
> Hi vald:
> 
> Vladislav Yasevich wrote, at 02/18/2011 10:43 PM:
>> Hi Jiri
>>
>> I agree.  Good catch.  If we can not add the error header to that packet, then we definitely
>> should not be adding the error payload either.
> 
> I also agree this part.
>  
>> We also don't want to abort as Shan Wei suggested.  It is allowed, when exceeding the MTU to
>> drop errors that would not otherwise fit into the packet.  It just may so happen that we
>> can report subsequent unknown parameters, but not this one in particular.
> 
> RFC said that about Parameter Types' encode:
> 3.2.1.  Optional/Variable-Length Parameter Format
>       11 -  Skip this parameter and continue processing but report the
>             unrecognized parameter in an 'Unrecognized Parameter', as
>             described in Section 3.2.2.
> 
> and
> 
> 3.2.2.  Reporting of Unrecognized Parameters
> 
>    If the receiver of an INIT chunk detects unrecognized parameters and
>    *has to* report them according to Section 3.2.1, it MUST put the
>    'Unrecognized Parameter' parameter(s) in the INIT ACK chunk sent in
>    response to the INIT chunk.
> 
> So, For unrecognized parameter can't fit into the packet, so droping the parameter.
> This may not be consistent with the RFC.
> 
> If i have missed something, please tell me. Thanks.
> 

See Secton 11.4.  Specifically:

   An SCTP implementation that receives an INIT that would require a
   large packet in response, due to the inclusion of multiple ERROR
   parameters, MAY (at its discretion) elect to omit some or all of the
   ERROR parameters to reduce the size of the INIT ACK.  Due to a
   combination of the size of the COOKIE parameter and the number of
   addresses a receiver of an INIT may be indicating to a peer, it is
   always possible that the INIT ACK will be larger than the original
   INIT.  An SCTP implementation SHOULD attempt to make the INIT ACK as
   small as possible to reduce the possibility of byte amplification
   attacks.


-vlad
>>
>> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
>>
>> -vlad
>>
>>
>>
>>
> 
> 

