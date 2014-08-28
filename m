From: =?UTF-8?B?6IuP5bqG?= <sooqing@gmail.com>
Date: Thu, 28 Aug 2014 06:33:33 +0000
Subject: uapi header mismatch with kernel ?
Message-Id: <CA+sbV4gaHaEskjKiAZOGUXAr5zjbCF7F70KC01y9xgOb8KcPng@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi all,

I found that In 3.x kernel, the sctp states are defined differently
between kernel and uapi header. This makes our application fails to
work.

Is that a mismatch or am I missing something?

----------------------------------------------------------------
in include/uapi/linux/sctp.h

/* Association states.  */
enum sctp_sstat_state {
    SCTP_EMPTY                = 0,
    SCTP_CLOSED               = 1,
    SCTP_COOKIE_WAIT          = 2,
    SCTP_COOKIE_ECHOED        = 3,
    SCTP_ESTABLISHED          = 4,
    SCTP_SHUTDOWN_PENDING     = 5,
    SCTP_SHUTDOWN_SENT        = 6,
    SCTP_SHUTDOWN_RECEIVED    = 7,
    SCTP_SHUTDOWN_ACK_SENT    = 8,
};

in include/net/sctp/constants.h

/* SCTP state defines for internal state machine */
typedef enum {

        SCTP_STATE_CLOSED               = 0,
        SCTP_STATE_COOKIE_WAIT          = 1,
        SCTP_STATE_COOKIE_ECHOED        = 2,
        SCTP_STATE_ESTABLISHED          = 3,
        SCTP_STATE_SHUTDOWN_PENDING     = 4,
        SCTP_STATE_SHUTDOWN_SENT        = 5,
        SCTP_STATE_SHUTDOWN_RECEIVED    = 6,
        SCTP_STATE_SHUTDOWN_ACK_SENT    = 7,

} sctp_state_t;



and it looks like the SCTP_STATE_EMPTY was removed by this
patch:http://lists.openwall.net/netdev/2011/04/20/31

Any help will be appreciated.

Thanks,
Tristan
