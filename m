From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 09 Jan 2009 14:08:46 +0000
Subject: Re: [PATCH] lksctp: replace sinfo_timetolive with sinfo_pr_value.
Message-Id: <49675A6E.7020102@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
In-Reply-To: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Horacio Sanson wrote:
> On Wed, Jan 7, 2009 at 3:20 AM, Vlad Yasevich <vladislav.yasevich@hp.com> wrote:
>> Hi Horacio
>>
>> Few small issues:
>>
>>> @@ -2539,7 +2540,7 @@ static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, int opt
>>>   *   in to this call the sctp_sndrcvinfo structure defined in Section
>>>   *   5.2.2) The input parameters accepted by this call include
>>>   *   sinfo_stream, sinfo_flags, sinfo_ppid, sinfo_context,
>>> - *   sinfo_timetolive.  The user must provide the sinfo_assoc_id field in
>>> + *   sinfo_pr_value.  The user must provide the sinfo_assoc_id field in
>>>   *   to this call if the caller is using the UDP model.
>>>   */
>>>  static int sctp_setsockopt_default_send_param(struct sock *sk,
>>> @@ -2563,13 +2564,15 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
>>>               asoc->default_flags = info.sinfo_flags;
>>>               asoc->default_ppid = info.sinfo_ppid;
>>>               asoc->default_context = info.sinfo_context;
>>> -             asoc->default_timetolive = info.sinfo_timetolive;
>>> +             asoc->default_pr_policy = info.sinfo_pr_policy;
>>> +             asoc->default_pr_value = info.sinfo_pr_value;
>>>       } else {
>>>               sp->default_stream = info.sinfo_stream;
>>>               sp->default_flags = info.sinfo_flags;
>>>               sp->default_ppid = info.sinfo_ppid;
>>>               sp->default_context = info.sinfo_context;
>>> -             sp->default_timetolive = info.sinfo_timetolive;
>>> +             sp->default_pr_policy = info.sinfo_pr_policy;
>>> +             sp->default_pr_value = info.sinfo_pr_value;
>>>       }
>> The policy value needs to be verified since we don't want to set to a garbage value.
>>
> 
> When you say "policy value" here you refer to sinfo_pr_policy value or
> to sinfo_pr_value? In the former case if the sinfo_pr_policy value is
> garbage then the behavior would be the same as when sinfo_timetolive
> was used, see the switch statement on line 150 of the same patch.

I meant the sinfo_pr_policy.  The idea of storing a garbage/non-valid
value for pr_policy in either the socket or the association doesn't appeal
to me.  If, for whatever reason, we need to examine that value, it should be
set correctly and not require additional determination elsewhere.

> The
> default statement checks for sinfo_pr_value and if not zero uses timed
> reliability and if zero uses reliable transmission independent of the
> value in sinfo_pr_policy.
> 
> If you refer to sinfo_pr_value then I have no idea how to validate
> this as it can be any 32bit unsigned integer depending on the PR
> policy used.
> 
> 
>>> @@ -6107,10 +6113,13 @@ SCTP_STATIC int sctp_msghdr_parse(const struct msghdr *msg,
>>>                               (struct sctp_sndrcvinfo *)CMSG_DATA(cmsg);
>>>
>>>                       /* Minimally, validate the sinfo_flags. */
>>> -                     if (cmsgs->info->sinfo_flags &
>>> +/*
>>> +if (cmsgs->info->sinfo_flags &
>>>                           ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
>>> -                           SCTP_ABORT | SCTP_EOF))
>>> +                           SCTP_ABORT | SCTP_EOF | SCTP_PR_SCTP_NONE |
>>> +                           SCTP_PR_SCTP_TTL))
>>>                               return -EINVAL;
>>> +*/
>>>                       break;
>>>
>>>               default:
>>
>> Commented out block above.  The sinfo_flags probably shouldn't contain _PR_
>> flags as it should be filled into the sinfo_pr_policy.  Remember that the flags
>> are really needed only for interaction with sctp_sendmsg() library call.
>>
> 
> When calling sctp_sendmsg I set sinfo_pr_policy based on the SCTP_PR_*
> flags (see corresponding sctp-tools patch at line 67) but I do not
> remove these flags from the sinfo_flags field. For this cause if I do
> not add the SCTP_PR_* flags in the check all calls to sctp_sendmsg()
> fail with EINVAL.
> 
> Shall I remove the SCTP_PR_* flags from sinfo_flags after I set
> sinfo_pr_value?? This would require to add a "binary AND" operation
> per SCTP_PR_* flag that I consider unnecessary. Note the block is
> commented out due to my lack of git skillz, this block is not
> commented in my current tree.
> 

The main problem is that the hunk is commented out.  If I were to take and
apply this patch, it would introduce a regression.  If it looks right on your
system check to see if you've committed this change.  'git status' will tell
you if you have files still not committed.  If you want to update the last
commit you did you can do:
	# git reset --soft HEAD^
	# git update-index <file> <file> ...   <- not committed files
	# git commit -C ORIG_HEAD

As for not removing PR flags from the flags, I currently have an outstanding
issue with the ID, but have not heard anything back yet.  I will probably
recommend that sctp_sendmsg() support only TTL based policy and any other policy
needs to be specified with sctp_send() that takes the whole sinfo structure as
a parameter.  If others agree, we can remove the flags hack.  So, I think it
would be better to not introduce this particular part of the API and have the
library mask off the PR bits from the flags.  If the flags interface is
adopted, we can remove the mask-off and re-establish this interface.

Can you agree with that reasoning?

Thanks
-vlad

> regards,
> Horacio
> 
>> -vlad
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

