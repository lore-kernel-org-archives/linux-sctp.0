From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 07 Mar 2013 22:08:21 +0000
Subject: Re: NULL primary_path
Message-Id: <51390FD5.8020703@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
In-Reply-To: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 03/07/2013 04:51 PM, Karl Heiss wrote:
> On Thu, Mar 7, 2013 at 12:17 PM, Vlad Yasevich <vyasevich@gmail.com> wrot=
e:
>> On 03/07/2013 12:06 PM, Karl Heiss wrote:
>>>
>>> The issue appears to manifest itself when the connection is closed
>>> from the remote end and getsockopt(SCTP_STATUS) is called within a
>>> small window in which the association is still valid but
>>> asoc->peer.primary_path is NULL.
>>
>>
>> Aha!  Thanks.  There was a bug in the rcu clean-up that allowed the
>> association to remain while all transports have been removed.
>>
>> Here is a patch that should have addressed this condition:
>>
>> commit 8c98653f05534acd1cb07ea4929702a3659177d1
>> Author: Daniel Borkmann <dborkman@redhat.com>
>> Date:   Fri Feb 1 04:37:43 2013 +0000
>>
>>      sctp: sctp_close: fix release of bindings for deferred call_rcu's
>>
>> Full patch is here:
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?i=
d=8C98653f05534acd1cb07ea4929702a3659177d1
>>
>> Make sure that you have this patch in the kernel you are running
>>
>> -vlad
>>
>>
>>>
>
> Unfortunately this patch wont apply to the version of the SCTP stack
> that we are using (2.6.36.2) since it does not have a
> sctp_transport_destroy_rcu() function.  Is there any chance that
> simply swapping the order of the instructions without moving them
> would have any effect?  I ask this hypothetically because the race
> condition window seems to be difficult to recreate, thus nothing to
> test against (aside from in the field!).
>
> Karl
>

I see.  Let me take another look.  If this race was happening before the
rcu, then it'll probably be there after.
If you don't hear anything for a few days, pester me.

Thanks
-vlad
