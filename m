From: "Gregory Waines" <waines@nortel.com>
Date: Wed, 14 Oct 2009 11:53:24 +0000
Subject: SCTP Association Restart
Message-Id: <90243C8A881F8D419D855264D9636F3A01EA5740@zcarhxm2.corp.nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



- ok, so I am using Linux 2.6.14 .
  can someone confirm that association restart should work
  for the SCTP implementation in Linux 2.6.14 .
  i.e. specifically for the side of the association that stays
       up and receives the unexpected INIT and COOKIE_ECHO while
       in the ESTABLISHED state.
       This end should accept the new INIT request as a restart
       (provided ip address and port match), report RESTART to the
       ULP, and reset sequence numbers to zero.
  This all works in 2.6.14 ?


- If I have a Linux process with an established SCTP connection/
  association,
  is there a socket option that prevents the kernel from 
  ABORTing the association if this Linux process fails unexpectedly ?


- I have the following question related to using the one-to-one style
socket 
  interface when trying to do an Association Restart:
     * if my node is typically the server side of the SCTP connections
     * then on a restart of this node,
     * I assume that I could NOT setup my server's listening socket
first,
                    (i.e. socket(), bind(), listen(), accept()...)
       and,
       then try to re-establish old associations by
socket(),bind(),connect() ...
            because the bind() would probably fail due to the listening
socket
            already being bound to the same SCTP IP Address and Port.
     *
     * is this correct ?
     * i.e. if using the one-to-one style interface, and 
               you are the server, and
               you restart, and
               you are trying to recover SCTP Associations,
            then
               the only way you can get around the bind() conflict is to

               recover the SCTP associations first, and then 
               re-setup your listening socket.


thanks in advance for any help,
Greg Waines
Nortel
waines@nortel.com
