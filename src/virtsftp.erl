-module(virtsftp).
-behaviour(ssh_server_key_api).
-behavior(ssh_sftpd_file_api).
-include_lib("public_key/include/public_key.hrl").

%% API exports
-export([start_server/0, stop_server/1]).

%% ssh_server_key_api behavior callbacks
-export([host_key/2, is_auth_key/3]).

%% ssh_sftpd_file_api behavior callbacks
-export([close/2, delete/2, del_dir/2, get_cwd/1, is_dir/2, list_dir/2,
         make_dir/2, make_symlink/3, open/3, position/3, read/3, read_link/2,
		 read_link_info/2, read_file_info/2, rename/3, write/3,
		 write_file_info/3]).

%% Macros
-define(L(_F, _A),
	io:format(user, "~p:~s:~p "_F, [?MODULE, ?FUNCTION_NAME, ?LINE | _A])
).
-define(L(_F), ?L(_F, [])).

%%====================================================================
%% API functions
%%====================================================================

start_server() ->
	application:ensure_all_started(ssh),
	Spec = ssh_sftpd:subsystem_spec([{cwd, "./tmp/sftp/example"}, {file_handler, ?MODULE}]),
	case ssh:daemon(loopback, 0, [{key_cb, ?MODULE}, {subsystems, [Spec]}]) of
		{ok, DaemonRef} ->
			case ssh:daemon_info(DaemonRef) of
				{ok, DaemonInfo} -> [{ref, DaemonRef} | DaemonInfo];
				{error, Error} -> {error, daemon_info, Error}
			end;
		{error, Error} -> {error, daemon, Error}
	end.

stop_server(Ctx) ->
	ok = ssh:stop_daemon(proplists:get_value(ref, Ctx)).

%%====================================================================
%% ssh_server_key_api behavior callbacks
%%====================================================================

-spec(host_key(Algorithm :: ssh:pubkey_alg(),
		   DaemonOptions :: ssh_server_key_api:daemon_key_cb_options()
                  ) ->
    {ok, PrivateKey :: public_key:private_key()} | {error, term()}).
host_key('ssh-rsa', _DaemonOptions) ->
	{ok, #'RSAPrivateKey'{}};
host_key(Algorithm, DaemonOptions) ->
	PrivDaemonOptions = proplists:get_value(key_cb_private, DaemonOptions),
	?L("Algorithm ~p~nDaemonOptions ~p~n", [Algorithm, PrivDaemonOptions]),
	{error, {nokey, Algorithm}}.

-spec(
	is_auth_key(
		PublicKey :: public_key:public_key(),
		User :: string(),
		DaemonOptions :: ssh_server_key_api:daemon_key_cb_options()
    ) -> boolean()
).
is_auth_key(PublicUserKey, User, DaemonOptions) ->
	PrivDaemonOptions = proplists:get_value(key_cb_private, DaemonOptions),
	?L("PublicUserKey ~p, User ~p~nDaemonOptions ~p~n", [PublicUserKey, User, PrivDaemonOptions]),
	true.

%%====================================================================
%% ssh_sftpd_file_api behavior callbacks
%%====================================================================

-spec(close(IoDevice::term(), State::term()) ->  ok | {error, Reason::term()}).
close(_IoDevice, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(delete(Path::term(), State::term()) -> ok | {error, Reason::term()}).
delete(_Path, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(del_dir(Path::term(), State::term()) -> ok | {error, Reason::term()}).
del_dir(_Path, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(get_cwd(State::term()) -> {ok, Dir::term()} | {error, Reason::term()}).
get_cwd(_State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(is_dir(AbsPath::term(), State::term()) -> boolean()).
is_dir(_AbsPath, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(list_dir(AbsPath::term(), State::term()) -> {ok, Filenames::term()} | {error, Reason::term()}).
list_dir(_AbsPath, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(make_dir(Dir::term(), State::term()) -> ok | {error, Reason::term()}).
make_dir(_Dir, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(make_symlink(Path2::term(), Path::term(), State::term()) -> ok | {error, Reason::term()}).
make_symlink(_Path2, _Path, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(open(Path::term(), Flags::term(), State::term()) -> {ok, IoDevice::term()} | {error, Reason::term()}).
open(_Path, _Flags, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(position(IoDevice::term(), Offs::term(), State::term()) ->
    {ok, NewPosition::term()} | {error, Reason::term()}).
position(_IoDevice, _Offs, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(read(IoDevice::term(), Len::term(), State::term()) ->
    {ok, Data::term()} | eof | {error, Reason::term()}).
read(_IoDevice, _Len, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(read_link(Path::term(), State::term()) ->
    {ok, FileName::term()} | {error, Reason::term()}).
read_link(_Path, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(read_link_info(Path::term(), State::term()) ->
    {ok, FileInfo::term()} | {error, Reason::term()}).
read_link_info(_Path, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(read_file_info(Path::term(), State::term()) ->
    {ok, FileInfo::term()} | {error, Reason::term()}).
read_file_info(_Path, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.
	
-spec(rename(Path::term(), Path2::term(), State::term()) ->
    ok | {error, Reason::term()}).
rename(_Path, _Path2, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(write(IoDevice::term(), Data::term(), State::term()) ->
    ok | {error, Reason::term()}).
write(_IoDevice, _Data, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.

-spec(write_file_info(Path::term(),Info::term(), State::term()) ->
    ok | {error, Reason::term()}).
write_file_info(_Path, _Info, _State) -> {error, {?FUNCTION_NAME, unimplemented}}.