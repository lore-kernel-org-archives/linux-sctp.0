From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 06 Jan 2016 16:18:59 +0000
Subject: Re: [PATCH net-next 2/5] sctp: apply rhashtable api to send/recv path
Message-Id: <CADvbK_e5BL47T1EPDDog72yrPNijeH45W6odba8R07HeUd1Diw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
	<2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
	<8d89800920719b527dbd6e36dbbcf3c0804fbd7c.1451490447.git.lucien.xin@gmail.com>
	<568C145F.5040009@gmail.com>
In-Reply-To: <568C145F.5040009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <mleitner@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>, daniel@iogearbox.net, davem <davem@davemloft.net>

On Wed, Jan 6, 2016 at 3:07 AM, Vlad Yasevich <vyasevich@gmail.com> wrote:
> On 12/30/2015 10:50 AM, Xin Long wrote:
>> apply lookup apis to two functions, for __sctp_endpoint_lookup_assoc
>> and __sctp_lookup_association, it's invoked in the protection of sock
>> lock, it will be safe, but sctp_lookup_association need to call
>> rcu_read_lock() and to detect the t->dead to protect it.
>>
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>> ---
>>  net/sctp/associola.c   |  5 +++++
>>  net/sctp/endpointola.c | 35 ++++++++---------------------------
>>  net/sctp/input.c       | 39 ++++++++++-----------------------------
>>  net/sctp/protocol.c    |  6 ++++++
>>  4 files changed, 29 insertions(+), 56 deletions(-)
>>
>> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
>> index 559afd0..2bf8ec9 100644
>> --- a/net/sctp/associola.c
>> +++ b/net/sctp/associola.c
>> @@ -383,6 +383,7 @@ void sctp_association_free(struct sctp_association *asoc)
>>       list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
>>               transport = list_entry(pos, struct sctp_transport, transports);
>>               list_del_rcu(pos);
>> +             sctp_unhash_transport(transport);
>>               sctp_transport_free(transport);
>>       }
>>
>> @@ -500,6 +501,8 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
>>
>>       /* Remove this peer from the list. */
>>       list_del_rcu(&peer->transports);
>> +     /* Remove this peer from the transport hashtable */
>> +     sctp_unhash_transport(peer);
>>
>>       /* Get the first transport of asoc. */
>>       pos = asoc->peer.transport_addr_list.next;
>> @@ -699,6 +702,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
>>       /* Attach the remote transport to our asoc.  */
>>       list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
>>       asoc->peer.transport_count++;
>> +     /* Add this peer into the transport hashtable */
>> +     sctp_hash_transport(peer);
>
> This is actually problematic.  The issue is that transports are unhashed when removed.
> however, transport removal happens after the association has been declared dead and
> should have been removed from the hash and marked unreachable.
>
> As a result, with the code above, you can now find and return a dead association.
> Checking for 'dead' state is racy.
>
> The best solution I've come up with is to hash the transports in sctp_hash_established()
> and clean-up in __sctp_unhash_established(), and then handle ADD-IP case separately.
>
> The above would also remove the necessity to check for temporary associations, since they
> should never be hashed.
>
> -vlad
>
yes, you're right, im thinking if we can unhash transport before the association
declares dead in sctp_association_free, like:

       list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
               transport = list_entry(pos, struct sctp_transport, transports);
               sctp_unhash_transport(transport);
       }
       asoc->base.dead = true;
