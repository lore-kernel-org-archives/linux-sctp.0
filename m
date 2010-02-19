From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 19 Feb 2010 13:25:38 +0000
Subject: Re: Possible problem in sctp_getsockopt_peer_addrs (and similar functions)
Message-Id: <4B7E9152.6010007@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B7E5DDF.4070500@nict.go.jp>
In-Reply-To: <4B7E5DDF.4070500@nict.go.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Sebastien

Sebastien Decugis wrote:
> Hello list,
> 
> I think there is a problem in sctp_getsockopt_peer_addrs function in
> net/sctp/socket.c.
> 
> I run into the problem when I call sctp_getpaddrs in userland, with a
> buffer containing IPv4 address followed by IPv6. The address buffer I
> receive cannot be parsed. After correctly reading the first address, I
> am not aligned correctly when I move my pointer forward by sizeof(struct
> sockaddr_in), to read the next address. I am not using mapped addresses.
> I believe the source of the problem being the following code:
> 
> list_for_each_entry(from, &asoc->peer.transport_addr_list,
>                               transports) {
>     memcpy(&temp, &from->ipaddr, sizeof(temp));
>     sctp_get_pf_specific(sk->sk_family)->addr_v4map(sp, &temp);
>     addrlen = sctp_get_af_specific(sk->sk_family)->sockaddr_len;
> 
> In this last line, shouldn't the address be dependent on the address
> family of &temp, rather than the socket ?
> 
> Sorry if the format of my mail is not good, it is my first post here...
> I am also not subscribed to this list, so please CC me in any answer.
> 
> Best regards,
> Sebastien.
> 

You are correct.  The address length used is totally wrong.  The length
should depend on the family of the address stored in the 'temp' variable
as that is the address that will be copied out to user.

I'll fix it up.

Thanks
-vlad
