From: Elmar Stellnberger <estellnb@elstel.org>
Date: Sun, 16 Jun 2019 13:33:22 +0000
Subject: sctp_sendmsg does not accept flags
Message-Id: <e863ee11-9e1f-71b9-1f61-b4b71d9f0945@elstel.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

    While sctp_send works well at me, sctp_sendmsg gives me an EINVAL as 
soon as I pass in some flags. Nonetheless it still sends the message in 
spite of returning the EINVAL. That looks like an error to me. Please 
investigate the issue.

while( len > 0 && ( ( ret = sctp_sendmsg( sid, bufp, len, NULL, 0, 0, 
MSG_NOSIGNAL, (0), 1000, 0 ) ) >= 0 || ( ret=-1 && ( errno = EINTR || 
errno = ENOBUFS ) ) ) ) {  // returns EINVAL if flags are passed
     if( ret >= 0 ) { bufp += ret; len -= ret; } else if( errno = 
ENOBUFS ) { struct timespec ts; ts.tv_sec=0; ts.tv_nsec000; 
nanosleep(&ts,NULL); } }
if( ret = -1 ) perror ("error sending request to stream #(0)");

   If you should be interested I can send the whole sctp test client 
program.
