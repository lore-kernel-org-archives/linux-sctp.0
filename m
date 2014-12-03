From: Ivan Skytte =?ISO-8859-1?Q?J=F8rgensen?= <isj-sctp@i1.dk>
Date: Wed, 03 Dec 2014 11:03:19 +0000
Subject: Re: wrong family for IP addresses given by sctp library
Message-Id: <8607877.vlUqEHCzXe@isjsys>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wednesday 03 December 2014 11:50:31 Boiteux Frederic wrote:
> 
> I'm trying to use SCTP on Linux machines with 'old' kernels (Debian 5, 2.6.26 kernel and Debian 7, 3.2 kernel). I've setup a program which can handles IPv4 and IPv6 addresses, and for that, I use a socket with AF_INET6 family, then I bind it to IPv4 or v6 addresses with sctp_bindx() (its manual page says this call can handle both v4 and v6 adresses if the socket is an IPv6 one).
> It seems to work well, but I have a strange behavior : on a test platform with only IPv4 addresses, when I get messages or notifications (using sctp_recvmsg()), the addresses given in it (IP address of the sender, or confirmation/fail of some peer addresses) are always from the IPv6 family !

Isn't the returned address simply a IPv6-mapped IPv4 address (::ffff:1.2.3.4) ? You can test it with IN6_IS_ADDR_V4MAPPED.


/isj

