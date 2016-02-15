From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 15 Feb 2016 15:11:22 +0000
Subject: sctp: bad hash index calculation
Message-Id: <CACT4Y+bKiens=uiZ99t+9ThtXi33W_bQLqh_AgWkQeQDmyUE5w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, Vladislav Yasevich <vyasevich@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, netdev <netdev@vger.kernel.org>

Hello,

While looking into some memory leaks of sctp ports I've noticed that
sctp_init initializes port hash table as follows:

    /* Allocate and initialize the SCTP port hash table.  */
    do {
        sctp_port_hashsize = (1UL << order) * PAGE_SIZE /
                    sizeof(struct sctp_bind_hashbucket);
        if ((sctp_port_hashsize > (64 * 1024)) && order > 0)
            continue;
        sctp_port_hashtable = (struct sctp_bind_hashbucket *)
            __get_free_pages(GFP_KERNEL | __GFP_NOWARN, order);
    } while (!sctp_port_hashtable && --order > 0);

and then hash index is computed as follows:

/* Warning: The following hash functions assume a power of two 'size'. */
/* This is the hash function for the SCTP port hash table. */
static inline int sctp_phashfn(struct net *net, __u16 lport)
{
    return (net_hash_mix(net) + lport) & (sctp_port_hashsize - 1);
}

I don't see what ensures that sctp_port_hashsize is in fact a power-of-2.

spinlock_t in sctp_bind_hashbucket can be 2 words in some configs,
then sizeof(sctp_bind_hashbucket) = 24, which can render half of hash
table unused.

struct sctp_bind_hashbucket {
        spinlock_t      lock;
        struct hlist_head       chain;
};

Am I missing something?
