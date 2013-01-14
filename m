From: Fan Du <fan.du@windriver.com>
Date: Mon, 14 Jan 2013 09:45:43 +0000
Subject: Re: [PATCH] sctp_xconnect: memory leak when malloc big buffer
Message-Id: <50F3D3C7.90301@windriver.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
In-Reply-To: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org



On 2013年01月14日 16:40, Daniel Borkmann wrote:
> On 01/14/2013 03:37 AM, Fan Du wrote:
>> CLIENT repeatly call process_ready_sockets, which malloc without free,
>> so sctp_xconnect exit unexpectly. Since SERVER and CLIENT could share
>> one buffer, so we malloc an global buffer at start.
>>
>> Signed-off-by: Fan Du <fan.du@windriver.com>
>> ---
>> apps/sctp_xconnect.c | 19 ++++++++-----------
>> 1 files changed, 8 insertions(+), 11 deletions(-)
>>
>> diff --git a/apps/sctp_xconnect.c b/apps/sctp_xconnect.c
>> index 5874c33..5be5a34 100644
>> --- a/apps/sctp_xconnect.c
>> +++ b/apps/sctp_xconnect.c
>> @@ -73,6 +73,7 @@ char *remote_host = NULL;
>> sockaddr_storage_t client_loop,
>> server_loop;
>> struct hostent *hst;
>> +char *big_buffer;
>>
>> void usage(char *argv0);
>> void parse_arguments(int argc, char*argv[]);
>> @@ -380,13 +381,8 @@ void server_mode() {
>> int assoc_num =0;
>> struct msghdr inmessage;
>> struct iovec iov;
>> - char *big_buffer;
>> char incmsg[CMSG_SPACE(sizeof(sctp_cmsg_data_t))];
>>
>> - if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
>> - printf("malloc failure: %s\n", strerror(errno));
>> - DUMP_CORE;
>> - }
>>
>> printf("Running in Server Mode...\n");
>>
>> @@ -530,15 +526,9 @@ void process_ready_sockets(int client_socket[], int assoc_num, fd_set *rfds) {
>> int i, stream, error;
>> struct msghdr inmessage;
>> struct iovec iov;
>> - char *big_buffer;
>> char incmsg[CMSG_SPACE(sizeof (sctp_cmsg_data_t))];
>> sockaddr_storage_t msgname;
>>
>> - if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
>> - printf("malloc failure: %s\n", strerror(errno));
>> - DUMP_CORE;
>> - }
>> -
>> /* Setup inmessage to be able to receive in incomming message */
>> memset(&inmessage, 0, sizeof (inmessage));
>> iov.iov_base = big_buffer;
>> @@ -579,11 +569,18 @@ int main(int argc, char *argv[]) {
>>
>> parse_arguments(argc, argv);
>>
>> + if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
>> + printf("malloc failure: %s\n", strerror(errno));
>> + DUMP_CORE;
>> + }
>> +
>
> This is still not what Neil meant in his feedback. Please fix it and resend
> your patch.
>

Oh, This malloced size is about 64K bytes, I don't think static declare 64k bytes buffer is good for a quite few codes.
And also, as I have stated, SERVER and CLIENT could share the same buffer, so malloc this space at startup for one time
is easy for the rest to use.


>> if (mode = SERVER) {
>> server_mode();
>> } else if (mode = CLIENT){
>> client_mode();
>> }
>> +
>> + free (big_buffer);
>> exit(1);
>> }
>>
>>

-- 
浮沉随浪只记今朝笑

--fan
