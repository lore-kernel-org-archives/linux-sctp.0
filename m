From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 15 Jan 2013 12:42:19 +0000
Subject: Re: [PATCH] sctp_xconnect: memory leak when malloc big buffer
Message-Id: <20130115124219.GB17980@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
In-Reply-To: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On Tue, Jan 15, 2013 at 09:28:42AM +0800, Fan Du wrote:
> 
> 
> On 2013年01月14日 22:16, Neil Horman wrote:
> >On Mon, Jan 14, 2013 at 05:45:43PM +0800, Fan Du wrote:
> >>
> >>
> >>On 2013年01月14日 16:40, Daniel Borkmann wrote:
> >>>On 01/14/2013 03:37 AM, Fan Du wrote:
> >>>>CLIENT repeatly call process_ready_sockets, which malloc without free,
> >>>>so sctp_xconnect exit unexpectly. Since SERVER and CLIENT could share
> >>>>one buffer, so we malloc an global buffer at start.
> >>>>
> >>>>Signed-off-by: Fan Du<fan.du@windriver.com>
> >>>>---
> >>>>apps/sctp_xconnect.c | 19 ++++++++-----------
> >>>>1 files changed, 8 insertions(+), 11 deletions(-)
> >>>>
> >>>>diff --git a/apps/sctp_xconnect.c b/apps/sctp_xconnect.c
> >>>>index 5874c33..5be5a34 100644
> >>>>--- a/apps/sctp_xconnect.c
> >>>>+++ b/apps/sctp_xconnect.c
> >>>>@@ -73,6 +73,7 @@ char *remote_host = NULL;
> >>>>sockaddr_storage_t client_loop,
> >>>>server_loop;
> >>>>struct hostent *hst;
> >>>>+char *big_buffer;
> >>>>
> >>>>void usage(char *argv0);
> >>>>void parse_arguments(int argc, char*argv[]);
> >>>>@@ -380,13 +381,8 @@ void server_mode() {
> >>>>int assoc_num =0;
> >>>>struct msghdr inmessage;
> >>>>struct iovec iov;
> >>>>- char *big_buffer;
> >>>>char incmsg[CMSG_SPACE(sizeof(sctp_cmsg_data_t))];
> >>>>
> >>>>- if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
> >>>>- printf("malloc failure: %s\n", strerror(errno));
> >>>>- DUMP_CORE;
> >>>>- }
> >>>>
> >>>>printf("Running in Server Mode...\n");
> >>>>
> >>>>@@ -530,15 +526,9 @@ void process_ready_sockets(int client_socket[], int assoc_num, fd_set *rfds) {
> >>>>int i, stream, error;
> >>>>struct msghdr inmessage;
> >>>>struct iovec iov;
> >>>>- char *big_buffer;
> >>>>char incmsg[CMSG_SPACE(sizeof (sctp_cmsg_data_t))];
> >>>>sockaddr_storage_t msgname;
> >>>>
> >>>>- if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
> >>>>- printf("malloc failure: %s\n", strerror(errno));
> >>>>- DUMP_CORE;
> >>>>- }
> >>>>-
> >>>>/* Setup inmessage to be able to receive in incomming message */
> >>>>memset(&inmessage, 0, sizeof (inmessage));
> >>>>iov.iov_base = big_buffer;
> >>>>@@ -579,11 +569,18 @@ int main(int argc, char *argv[]) {
> >>>>
> >>>>parse_arguments(argc, argv);
> >>>>
> >>>>+ if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
> >>>>+ printf("malloc failure: %s\n", strerror(errno));
> >>>>+ DUMP_CORE;
> >>>>+ }
> >>>>+
> >>>
> >>>This is still not what Neil meant in his feedback. Please fix it and resend
> >>>your patch.
> >>>
> >>
> >>Oh, This malloced size is about 64K bytes, I don't think static declare 64k bytes buffer is good for a quite few codes.
> >>And also, as I have stated, SERVER and CLIENT could share the same buffer, so malloc this space at startup for one time
> >>is easy for the rest to use.
> >>
> >Daniel is right.  While this is again a fine solution, but suggestion was to
> >statically declare the buffer in a global location.  It provides the same shared
> >usage between client and server modes, and doesn't require the NULL checking.
> 
> Yes, no NULL pointer checking, that's true.
> 
> >understand its a large buffer, but I'm not sure in what situation a statically
> >declared 64k buffer would be inadvisable whereas a heap allocated 64k buffer
> >would be acceptable, at least not in a bit of code so small as this.
> 
> Hmmm, Ok, I will send another patch to follow your suggestion by declaring it statically :)
> 
> But sorry, I have to argue this a bit more privately, because I'm not convinced why it should do that way.
> This statically declared buffer contains nothing before its running, not like a CRC32
> table which is a MUST to declare statically, so why bother to declare it statically to
> make the executable file size explode considering its few code size.
> 
Well, 64k isn't that big, and it won't increase the size of the exutable by that
anyway.  If you don't initalize the global variable, then it will be placed in
the bss section of the elf file, where it is stored as just an offset and a
distance.  Give it a try and check the resultant binary size.

This doesn't make sense for all situations, but given the small size of this
program, I think you will find you will actually reduce your program size, as
the disk storage for a global uninitalized variable will be smaller than the
amount of storage for the code you remove in the NULL checking.

Neil

> 
> 
> >Neil
> >
> >>
> >>>>if (mode = SERVER) {
> >>>>server_mode();
> >>>>} else if (mode = CLIENT){
> >>>>client_mode();
> >>>>}
> >>>>+
> >>>>+ free (big_buffer);
> >>>>exit(1);
> >>>>}
> >>>>
> >>>>
> >>
> >>--
> >>浮沉随浪只记今朝笑
> >>
> >>--fan
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> 
> -- 
> 浮沉随浪只记今朝笑
> 
> --fan
> 
