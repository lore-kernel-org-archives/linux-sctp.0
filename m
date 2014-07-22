From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 22 Jul 2014 16:24:11 +0000
Subject: Re: SCTP Quick failover status
Message-Id: <53CE902B.5030208@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 07/22/2014 10:55 AM, Karen E. Egede Nielsen wrote:
> Hi Vlad,
> 
> Would it possibly be feasible for you to  provide feedback on as  to
> whether:
> 
> * Linux SCTP supports the most recent version of the SCTP PF draft,
> http://datatracker.ietf.org/doc/draft-ietf-tsvwg-sctp-failover/, ?

It appears that Linux partially supports the latest draft.  Some of
the newer language in section 4.1 is not supported.  The API doesn't
appear to be supported either.

We'll work on adding this functionality.

> 
> * The Linux SCTP implementers group have any comments to the draft in
> question ?
> 

I do not.  I've cc'd the implementers mailing list to see if anyone else
has any comments.

Thanks
-vlad

> The draft is proposed for publication as Proposed Standard[*] by tsvwg.
> The check up towards potential comments from Linux SCTP
> was a request made by the chairs at the tsvwg  at IETF90.
> 
> Many thanks in advance !
> 
> BR, Karen
> 
> [* Even if present version says Experimental]
> 
> PS. As you can see Michael kindly provided you as a good reference.. :-)
> 
>> -----Original Message-----
>> From: Michael Tuexen [mailto:tuexen@fh-muenster.de]
>> Sent: 22. juli 2014 15:52
>> To: Karen E. Egede Nielsen
>> Cc: Vlad Yasevich
>> Subject: SCTP Quick failover status
>>
>> Hi Karen,
>>
>> Vlad, who is the Linux SCTP kernel maintainer, might be able to comment
> on
>> the status of the Linux implementation if quick failover and if there
> were any
>> comments related to the ID.
>>
>> Best regards
>> Michael

