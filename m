From: Karl Heiss <kheiss@gmail.com>
Date: Fri, 08 Mar 2013 17:06:03 +0000
Subject: Re: NULL primary_path
Message-Id: <CAGugRbU0byoHGf7X_EgNy3M6cr=EXb4++XY9EjDSm7QGRJKZUg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
In-Reply-To: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Fri, Mar 8, 2013 at 11:42 AM, Vlad Yasevich <vyasevich@gmail.com> wrote:
> On 03/08/2013 10:37 AM, Karl Heiss wrote:
>>
>> On Fri, Mar 8, 2013 at 10:31 AM, Vlad Yasevich <vyasevich@gmail.com>
>> wrote:
>>>
>>> On 03/08/2013 09:31 AM, Karl Heiss wrote:
>>>>
>>>>
>>>> On Fri, Mar 8, 2013 at 8:52 AM, Karl Heiss <kheiss@gmail.com> wrote:
>>>>>
>>>>>
>>>>> On Thu, Mar 7, 2013 at 6:09 PM, Vlad Yasevich <vyasevich@gmail.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> On 03/07/2013 04:51 PM, Karl Heiss wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On Thu, Mar 7, 2013 at 12:17 PM, Vlad Yasevich <vyasevich@gmail.com>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 03/07/2013 12:06 PM, Karl Heiss wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> The issue appears to manifest itself when the connection is closed
>>>>>>>>> from the remote end and getsockopt(SCTP_STATUS) is called within a
>>>>>>>>> small window in which the association is still valid but
>>>>>>>>> asoc->peer.primary_path is NULL.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Aha!  Thanks.  There was a bug in the rcu clean-up that allowed the
>>>>>>>> association to remain while all transports have been removed.
>>>>>>>>
>>>>>>>> Here is a patch that should have addressed this condition:
>>>>>>>>
>>>>>>>> commit 8c98653f05534acd1cb07ea4929702a3659177d1
>>>>>>>> Author: Daniel Borkmann <dborkman@redhat.com>
>>>>>>>> Date:   Fri Feb 1 04:37:43 2013 +0000
>>>>>>>>
>>>>>>>>        sctp: sctp_close: fix release of bindings for deferred
>>>>>>>> call_rcu's
>>>>>>>>
>>>>>>>> Full patch is here:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/com=
mit/?id=8C98653f05534acd1cb07ea4929702a3659177d1
>>>>>>>>
>>>>>>>> Make sure that you have this patch in the kernel you are running
>>>>>>>>
>>>>>>>> -vlad
>>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>
>>>>>>> Unfortunately this patch wont apply to the version of the SCTP stack
>>>>>>> that we are using (2.6.36.2) since it does not have a
>>>>>>> sctp_transport_destroy_rcu() function.  Is there any chance that
>>>>>>> simply swapping the order of the instructions without moving them
>>>>>>> would have any effect?  I ask this hypothetically because the race
>>>>>>> condition window seems to be difficult to recreate, thus nothing to
>>>>>>> test against (aside from in the field!).
>>>>>>>
>>>>>>> Karl
>>>>>>>
>>>>>>
>>>>>> Hi Karl
>>>>>>
>>>>>> I think I see the problem now.  The problem happens when the
>>>>>> association
>>>>>> is
>>>>>> destroyed.  We delay removing the association from
>>>>>> the association id pool until all references on the association
>>>>>> have dropped.  As a result, it is possible (for a very short
>>>>>> period of time) for an association structure to still exist in
>>>>>> the kernel and still be found via the association id, but that
>>>>>> association
>>>>>> has no transports and is about to be completely destroyed.
>>>>>>
>>>>>> This is a really interesting race and I need to figure out if it is
>>>>>> there on purpose or not?
>>>>>>
>>>>>> In the mean time, here is a patch that should solve it for you.
>>>>>>
>>>>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>>>>>> index b907073..2d92c89 100644
>>>>>> --- a/net/sctp/socket.c
>>>>>> +++ b/net/sctp/socket.c
>>>>>> @@ -223,7 +223,7 @@ struct sctp_association *sctp_id2assoc(struct so=
ck
>>>>>> *sk,
>>>>>> sctp_assoc_t id)
>>>>>>                   if (!list_empty(&sctp_sk(sk)->ep->asocs))
>>>>>>                           asoc >>>>>> list_entry(sctp_sk(sk)->ep->as=
ocs.next,
>>>>>>                                             struct sctp_association,
>>>>>> asocs);
>>>>>> -               return asoc;
>>>>>> +               goto done;
>>>>>>           }
>>>>>>
>>>>>>           /* Otherwise this is a UDP-style socket. */
>>>>>> @@ -234,6 +234,7 @@ struct sctp_association *sctp_id2assoc(struct so=
ck
>>>>>> *sk,
>>>>>> sctp_assoc_t id)
>>>>>>           asoc =3D (struct sctp_association *)idr_find(&sctp_assocs_=
id,
>>>>>> (int)id);
>>>>>>           spin_unlock_bh(&sctp_assocs_id_lock);
>>>>>>
>>>>>> +done:
>>>>>>           if (!asoc || (asoc->base.sk !=3D sk) || asoc->base.dead)
>>>>>>                   return NULL;
>>>>>>
>>>>>
>>>>> Vlad,
>>>>>
>>>>> Looking at the kdump from the panic, I am seeing that your patch above
>>>>> may not work in this case since the asoc is valid, the base.sk is
>>>>> valid, and base.dead is 0.  Unless base.sk is valid but doesn't match
>>>>> sk, this wouldn't appear to fix this issue.
>>>
>>>
>>>
>>> Hm..  If the association is not marked "dead", it should still have all
>>> its
>>> transports present.  If you look at the peer.transport_addr_list in
>>> you kdump, is that list empty or not?
>>>
>>> Are any other peer transport pointers set (active_path, retran_path)?
>>>
>>
>> crash> p ((struct sctp_association *) 0xffff8107670e3000).peer
>> $14 =3D {
>>    rwnd =3D 65535,
>>    transport_addr_list =3D {
>>      next =3D 0xffff8107670e3180,
>>      prev =3D 0xffff8107670e3180
>>    },
>>    transport_count =3D 0,
>>    port =3D 3868,
>>    primary_path =3D 0x0,
>>    primary_addr =3D {
>>      v4 =3D {
>>        sin_family =3D 0,
>>        sin_port =3D 0,
>>        sin_addr =3D {
>>          s_addr =3D 0
>>        },
>>        __pad =3D "\000\000\000\000\000\000\000"
>>      },
>>      v6 =3D {
>>        sin6_family =3D 0,
>>        sin6_port =3D 0,
>>        sin6_flowinfo =3D 0,
>>        sin6_addr =3D {
>>          in6_u =3D {
>>            u6_addr8 >> "\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000",
>>            u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
>>            u6_addr32 =3D {0, 0, 0, 0}
>>          }
>>        },
>>        sin6_scope_id =3D 0
>>      },
>>      sa =3D {
>>        sa_family =3D 0,
>>        sa_data =3D "\000\000\000\000\000\000\000\000\000\000\000\000\000"
>>      }
>>    },
>>    active_path =3D 0x0,
>>    retran_path =3D 0x0,
>>    last_sent_to =3D 0x0,
>>    last_data_from =3D 0x0,
>>    tsn_map =3D {
>>      tsn_map =3D 0x0,
>>      base_tsn =3D 0,
>>      cumulative_tsn_ack_point =3D 0,
>>      max_tsn_seen =3D 0,
>>      len =3D 0,
>>      pending_data =3D 0,
>>      num_dup_tsns =3D 0,
>>      dup_tsns =3D {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
>>    },
>>    sack_needed =3D 1 '\001',
>>    sack_cnt =3D 0,
>>    ecn_capable =3D 0 '\0',
>>    ipv4_address =3D 1 '\001',
>>    ipv6_address =3D 0 '\0',
>>    hostname_address =3D 0 '\0',
>>    asconf_capable =3D 0 '\0',
>>    prsctp_capable =3D 0 '\0',
>>    auth_capable =3D 0 '\0',
>>    adaptation_ind =3D 0,
>>    addip_disabled_mask =3D 0,
>>    i =3D {
>>      init_tag =3D 0,
>>      a_rwnd =3D 0,
>>      num_outbound_streams =3D 0,
>>      num_inbound_streams =3D 0,
>>      initial_tsn =3D 0
>>    },
>>    cookie_len =3D 0,
>>    cookie =3D 0x0,
>>    addip_serial =3D 0,
>>    peer_random =3D 0x0,
>>    peer_chunks =3D 0x0,
>>    peer_hmacs =3D 0x0
>> }
>>
>>>
>>>>>
>>>>> Karl
>>>>
>>>>
>>>>
>>>> Vlad,
>>>>
>>>> One other thing, with the difficulty we are having recreating this
>>>> issue, is there any generic way to increase the likelihood for the
>>>> transport to be cleared out while delaying the association cleanup?
>>>> Is there any way that the association is initialized without any
>>>> transport information?
>>>
>>>
>>>
>>> When the association is initialized, the lists are empty, but the next
>>> thing that happens is that we add transport of the destination we are
>>> sending to or receiving from to the association and mark it as primary
>>> and
>>> active.  All this happens under a socket lock, so getsockopt can't
>>> access the association until all actions on that association complete.
>>>
>>>
>>>> The reason I ask; we believe the issue is
>>>> happening very shortly after the association is brought up (we bring
>>>> it up and then do the getsockopt()).
>>>
>>>
>>>
>>> Can you check what the association state is?  Alternately, can you
>>> provide
>>> the kdump and the kernel so I can dig around.
>>
>>
>> crash> p ((struct sctp_association *) 0xffff8107670e3000).state
>> $15 =3D SCTP_STATE_CLOSED
>
>
>
> Hi Karl
>
> Was this the client or the server side?  Also what was the socket type
> (STREAM or SEQPACKET)?
>
> -vlad
>>
>>
>>>
>>> Thanks
>>> -vlad
>>>>
>>>>
>>>>
>>>> Thanks,
>>>> Karl
>>>>
>>>
>

We believe this is occurring on the client side (still working on
confirming, this system is a Diameter router so we get connections
going in both directions).  The connections are all STREAM.  We are
also seeing ABORTs fairly regularly on the connections in suspect.

Karl
