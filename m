From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
Date: Sat, 19 Oct 2013 11:38:43 +0000
Subject: net: sctp: possible dereference after freeing
Message-Id: <CAGG-pUTXC+6O-wyYp0FZxKH-XWqP++jLEn-Km5kixQFcKsWRZA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Hi maintainers,

I would like to know if these are catches:

/net/sctp/endpointola.c (281)
static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
{
    struct sock *sk;
...
    kfree(ep);
    SCTP_DBG_OBJCNT_DEC(ep);
}

The 'ep' object counter is being decremented?! Is the kfree to be there ind=
eed?
Let me know what was intended here.

Same here:
/net/sctp/endpointola.c (165)
static void sctp_transport_destroy_rcu(struct rcu_head *head)
{
    struct sctp_transport *transport;
...
    kfree(transport);
    SCTP_DBG_OBJCNT_DEC(transport);
}

Regards,

Geyslan Greg=C3=B3rio Bem
hackingbits.com
