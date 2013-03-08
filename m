From: Karl Heiss <kheiss@gmail.com>
Date: Fri, 08 Mar 2013 13:52:28 +0000
Subject: Re: NULL primary_path
Message-Id: <CAGugRbXeuUXBdyBQkj0fS+6Z7j+FhohhZKC0mne33w2DkRfLKA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
In-Reply-To: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Thu, Mar 7, 2013 at 6:09 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
> On 03/07/2013 04:51 PM, Karl Heiss wrote:
>>
>> On Thu, Mar 7, 2013 at 12:17 PM, Vlad Yasevich <vyasevich@gmail.com>
>> wrote:
>>>
>>> On 03/07/2013 12:06 PM, Karl Heiss wrote:
>>>>
>>>>
>>>> The issue appears to manifest itself when the connection is closed
>>>> from the remote end and getsockopt(SCTP_STATUS) is called within a
>>>> small window in which the association is still valid but
>>>> asoc->peer.primary_path is NULL.
>>>
>>>
>>>
>>> Aha!  Thanks.  There was a bug in the rcu clean-up that allowed the
>>> association to remain while all transports have been removed.
>>>
>>> Here is a patch that should have addressed this condition:
>>>
>>> commit 8c98653f05534acd1cb07ea4929702a3659177d1
>>> Author: Daniel Borkmann <dborkman@redhat.com>
>>> Date:   Fri Feb 1 04:37:43 2013 +0000
>>>
>>>      sctp: sctp_close: fix release of bindings for deferred call_rcu's
>>>
>>> Full patch is here:
>>>
>>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=8C98653f05534acd1cb07ea4929702a3659177d1
>>>
>>> Make sure that you have this patch in the kernel you are running
>>>
>>> -vlad
>>>
>>>
>>>>
>>
>> Unfortunately this patch wont apply to the version of the SCTP stack
>> that we are using (2.6.36.2) since it does not have a
>> sctp_transport_destroy_rcu() function.  Is there any chance that
>> simply swapping the order of the instructions without moving them
>> would have any effect?  I ask this hypothetically because the race
>> condition window seems to be difficult to recreate, thus nothing to
>> test against (aside from in the field!).
>>
>> Karl
>>
>
> Hi Karl
>
> I think I see the problem now.  The problem happens when the association =
is
> destroyed.  We delay removing the association from
> the association id pool until all references on the association
> have dropped.  As a result, it is possible (for a very short
> period of time) for an association structure to still exist in
> the kernel and still be found via the association id, but that association
> has no transports and is about to be completely destroyed.
>
> This is a really interesting race and I need to figure out if it is
> there on purpose or not?
>
> In the mean time, here is a patch that should solve it for you.
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index b907073..2d92c89 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -223,7 +223,7 @@ struct sctp_association *sctp_id2assoc(struct sock *s=
k,
> sctp_assoc_t id)
>                 if (!list_empty(&sctp_sk(sk)->ep->asocs))
>                         asoc =3D list_entry(sctp_sk(sk)->ep->asocs.next,
>                                           struct sctp_association, asocs);
> -               return asoc;
> +               goto done;
>         }
>
>         /* Otherwise this is a UDP-style socket. */
> @@ -234,6 +234,7 @@ struct sctp_association *sctp_id2assoc(struct sock *s=
k,
> sctp_assoc_t id)
>         asoc =3D (struct sctp_association *)idr_find(&sctp_assocs_id,
> (int)id);
>         spin_unlock_bh(&sctp_assocs_id_lock);
>
> +done:
>         if (!asoc || (asoc->base.sk !=3D sk) || asoc->base.dead)
>                 return NULL;
>

Vlad,

Looking at the kdump from the panic, I am seeing that your patch above
may not work in this case since the asoc is valid, the base.sk is
valid, and base.dead is 0.  Unless base.sk is valid but doesn't match
sk, this wouldn't appear to fix this issue.

Karl
